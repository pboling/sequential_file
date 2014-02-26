module SequentialFile
  module Namer

    module Initializer
      def initialize(options = {})
        super do
          if options[:name]
            parts = options[:name].split('.')
            raise ArgumentError, ":name must have three parts separated by dots ('.') in order to be a valid option for #{self.class.name}" unless parts.length == 3
            options[:filename_first_part] = parts[0]
            options[:filename_third_part] = parts[1]
            options[:file_extension] = '.' << parts[2]
          end
          @process_date = options[:process_date] || Date.today
          @filename_first_part = options[:filename_first_part]
          @filename_third_part = options[:filename_third_part]
          @file_extension = options[:file_extension]
          if options[:append]
            @last_filename_counter = self.last_used_counter
          else
            @last_filename_counter = self.get_next_available_counter
          end
          @name = self.determine_name
        end
      end
    end

    def self.included(klass)
      klass.send :prepend, Initializer

      klass.send :attr_accessor, :name                         # complete intelligent *and* sequential filename
      klass.send :attr_accessor, :process_date                 # date stamp of invocation, used as part of filename
      klass.send :attr_accessor, :filename_first_part          # First part of filename,   separated from third part by the chronometer
      klass.send :attr_accessor, :filename_third_part          # Third part of filename,  separated from first  part by the chronometer
      klass.send :attr_accessor, :last_filename_counter        # the last-used file counter;  prevent files from stepping on each other.
      klass.send :attr_accessor, :file_extension               # the file extension
    end

    protected
    def globular_file_parts
      chrono = self.get_chronometer
      with_dot = chrono.empty? ? '' : ".#{chrono}"
      "#{self.filename_first_part}#{with_dot}.#{self.filename_third_part}"
    end
    def determine_name
      "#{self.globular_file_parts}.#{self.last_filename_counter}#{self.file_extension}"
    end

    def get_chronometer
      self.process_date.respond_to?(:strftime) ?
        self.process_date.strftime("%Y%m%d") :
        self.process_date.nil? ?
          '' :
          self.process_date
    end

    # determines the last used file counter value
    # returns:
    #   an integer representation of the counter
    def last_used_counter
      return self.last_filename_counter unless self.last_filename_counter.nil?
      high_value = 0
      self.directory_glob.each do |file|
        counter = self.get_counter_for_file(file)
        high_value = ((high_value <=> counter) == 1) ? high_value : counter
      end
      high_value
    end

    # determines the counter value for the next bump file to create
    # returns:
    #   an integer representation of the next counter to use
    def get_next_available_counter
      if self.last_filename_counter
        self.last_filename_counter + 1
      else
        self.last_used_counter + 1
      end
    end

    # determines the counter value of the filename passed in.
    # params:
    #   none
    # returns:
    #   an array of file names in the directory matching the glob
    def directory_glob
      glob = File.join(self.directory_path, "#{self.globular_file_parts}.*")
      Dir.glob(glob)
    end

    # determines the counter value of the filename passed in.
    # params:
    #   filename - string, complete filename
    # returns:
    #   an integer representation of the counter
    def get_counter_for_file(filename)
      base = File.basename(filename, self.file_extension)
      index = base.rindex('.')
      tail = index.nil? ? nil : base[index+1,base.length]
      # Ensure numbers - sanity check
      tail.nil? ? 0 : tail[/\d*/].to_i
    end

  end
end
