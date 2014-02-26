require 'date'

module SequentialFile
  # This is a reference implementation of a File-wrapper class that uses the Namer to determine which file to process
  class Base

    include SequentialFile::Namer

    attr_accessor :complete_path                # the complete path to the file
    attr_accessor :read_position                # the byte position in the file where read stopped and monitor will begin.
    attr_accessor :file, :permission_style
    attr_accessor :buffer_size, :buffer_limit, :buffer_position, :verbose

    def initialize(options = {}, &block)
      yield if block_given?
      @complete_path ||= File.join(self.directory_path, self.name)
      @buffer_limit = options[:buffer_limit] || 200 # bytes
      @buffer_size = 0
      @permission_style = options[:permission_style] || File::RDWR|File::CREAT
      @verbose = !!options[:verbose]
    end

    def info_string
      "PERM: #{@permission_style}\n\tPATH: #{@complete_path}"
    end

    def file_handle
      # autoclose: false => Keep the file descriptor open until we want to close it.
      File.new(@complete_path, @permission_style, {autoclose: false})
      self.file ||= File.new(@complete_path, @permission_style, {autoclose: false})
    end

    def num_lines
      file_handle.seek(0, IO::SEEK_SET)
      file_handle.readlines.size
    end

    # Need to remember to close file with self.close after done using the file descriptor
    def write(msg)
      prep_write
      puts "#-------> @[ #{@file_handle.pos} ] B[ #{@buffer_size} ] in #{@complete_path} <---------#\n#{msg}" if verbose
      add_to_buffer(msg)
      flush_if_buffer_full
    end

    def flush_if_buffer_full
      if buffer_size >= buffer_limit
        file_handle.flush
        @buffer_size = 0
      end
    end

    # Read file from beginning to end, recording position when done
    # Need to remember to close file with self.close after done using the file descriptor
    def read &block
      prep_read
      data = block_given? ?
        file_handle.each {|line| yield line } :
        file_handle.read
      @read_position = file_handle.pos
      data
    end

    def close
      file_handle.close
      # Set the file to nil, so it will be reopened when needed.
      self.file = nil
    end

    def clear
      file_handle.truncate 0
      # Set the file to nil, so it will be reopened when needed.
      close
    end

    def delete
      if file
        close # just in case
        File.delete(complete_path)
      end
    end

    protected
    def prep_write
      file_handle.flock(File::LOCK_EX) # an exclusive lock on the file.
      file_handle.seek(0, IO::SEEK_END)
    end
    def prep_read
      file_handle.flock(File::LOCK_SH) # a shared lock on the file.
      file_handle.seek(0, IO::SEEK_SET)
    end
    def add_to_buffer(msg)
      @buffer_size += msg.length
      file_handle.write(msg)
    end
  end
end

# Read file from #position where read stopped and continue to monitor for additional lines added
# Need to remember to close file with self.close after done using the file descriptor
# WARNING: this is an infinite loop, so know how you will stop it before you start it.
#def monitor &block
#  f = File.open(self.complete_path,"r")
#  f.seek(self.read_position, IO::SEEK_SET)
#  while true do
#    select([f])   # Kernel#select
#    yield f.gets  # a line
#  end
#end
