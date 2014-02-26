require 'date'

module SequentialFile
  class Base

    include SequentialFile::Namer

    attr_accessor :directory_path               # directory path where file will be read from
    attr_accessor :complete_path                # the complete path to the file
    attr_accessor :read_position                # the byte position in the file where read stopped and monitor will begin.
    attr_accessor :file, :permission_style
    attr_accessor :buffer_size, :buffer_limit, :buffer_position

    def initialize(options = {}, &block)
      @directory_path = options[:directory_path]
      yield if block_given?
      @complete_path ||= File.join(self.directory_path, self.name)
      @buffer_limit = options[:buffer_limit] || 200 # bytes
      @buffer_size = 0
      @permission_style = options[:permission_style] || File::RDWR|File::CREAT
    end

    def info_string
      "PERM: #{self.permission_style}\n\tPATH: #{self.complete_path}"
    end

    def file_handle
      # autoclose: false => Keep the file descriptor open until we want to close it.
      File.new(self.complete_path, self.permission_style, {autoclose: false})
      self.file ||= File.new(self.complete_path, self.permission_style, {autoclose: false})
    end

    def num_lines
      self.file_handle.seek(0, IO::SEEK_SET)
      self.file_handle.readlines.size
    end

    # Need to remember to close file with self.close! after done using the file descriptor
    def write(msg, verbose = false)
      self.file_handle.flock(File::LOCK_EX) # an exclusive lock on the file.
      self.file_handle.seek(0, IO::SEEK_END)
      self.buffer_size += msg.length
      puts "#-------> @[ #{self.file_handle.pos} ] B[ #{self.buffer_size} ] in #{self.complete_path} <---------#\n#{msg}" if verbose
      self.file_handle.write(msg)
      self.flush_if_buffer_full
    end

    def flush_if_buffer_full
      if self.buffer_size >= self.buffer_limit
        self.file_handle.flush
        self.buffer_size = 0
      end
    end

    # Read file from beginning to end, recording position when done
    # Need to remember to close file with self.close! after done using the file descriptor
    def read &block
      self.file_handle.flock(File::LOCK_SH) # a shared lock on the file.
      self.file_handle.seek(0, IO::SEEK_SET)
      data = ''
      if block_given?
        self.file_handle.each {|line| yield line }
      else
        data = self.file_handle.read
      end
      self.read_position = self.file_handle.pos
      data
    end

    def close!
      self.file_handle.close
      # Set the file to nil, so it will be reopened when needed.
      self.file = nil
    end

    def clear!
      self.file_handle.truncate 0
      # Set the file to nil, so it will be reopened when needed.
      self.close!
    end

    def delete!
      if !self.file.nil?
        self.close! # just in case
        File.delete(self.complete_path)
      end
    end

  end
end

# Read file from #position where read stopped and continue to monitor for additional lines added
# Need to remember to close file with self.close! after done using the file descriptor
# WARNING: this is an infinite loop, so know how you will stop it before you start it.
#def monitor &block
#  f = File.open(self.complete_path,"r")
#  f.seek(self.read_position, IO::SEEK_SET)
#  while true do
#    select([f])   # Kernel#select
#    yield f.gets  # a line
#  end
#end
