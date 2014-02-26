require 'sequential_file/counter_finder'

module SequentialFile
  module Namer

    module Initializer
      def initialize(options = {})
        super do
          name = options[:name]
          name ?
            derive_name_parts_from_name(name) :
            set_name_parts(options[:filename_first_part], options[:filename_third_part], options[:file_extension])
          @directory_path = options[:directory_path]
          @process_date = options[:process_date] || Date.today
          if options[:append]
            @last_filename_counter = self.last_used_counter
          else
            @last_filename_counter = self.get_next_available_counter
          end
          @name = self.determine_name
        end
      end
    end

    # :directory_path -         directory path where file will be located
    # :name -                   complete intelligent *and* sequential filename
    # :process_date -           date stamp of invocation, used as part of filename
    # :filename_first_part -    first part of filename,   separated from third part by the chronometer
    # :filename_third_part -    third part of filename,  separated from first  part by the chronometer
    # :last_filename_counter -  the last-used file counter;  prevent files from stepping on each other.
    # :file_extension -         the file extension
    def self.included(klass)
      klass.send :prepend, Initializer
      klass.send :attr_accessor, :directory_path, :name, :process_date, :filename_first_part, :filename_third_part, :last_filename_counter, :file_extension
    end

    protected
    def set_name_parts(first_part, third_part, name_extension)
      @filename_first_part = first_part
      @filename_third_part = third_part
      @file_extension = name_extension
    end

    def derive_name_parts_from_name(name_option)
      parts = name_option.split('.')
      raise ArgumentError, ":name must have three parts separated by dots ('.') in order to be a valid option for #{self.class.name}" unless parts.length == 3
      set_name_parts(parts[0], parts[1], '.' << parts[2])
    end

    def globular_file_parts
      chrono = get_chronometer
      with_dot = chrono.empty? ? '' : ".#{chrono}"
      "#{@filename_first_part}#{with_dot}.#{@filename_third_part}"
    end

    def determine_name
      "#{globular_file_parts}.#{@last_filename_counter}#{@file_extension}"
    end

    def get_chronometer
      @process_date.respond_to?(:strftime) ?
        @process_date.strftime("%Y%m%d") :
        @process_date.to_s
    end

    # determines the last used file counter value
    # returns:
    #   an integer representation of the counter
    def last_used_counter
      directory_glob.inject(0) do |high_value, file|
        counter = get_counter_for_file(file)
        ((high_value <=> counter) == 1) ? high_value : counter
      end
    end

    # determines the counter value for the next bump file to create
    # returns:
    #   an integer representation of the next counter to use
    def get_next_available_counter
      if @last_filename_counter
        @last_filename_counter + 1
      else
        last_used_counter + 1
      end
    end

    # determines the counter value of the filename passed in.
    # params:
    #   none
    # returns:
    #   an array of file names in the directory matching the glob
    def directory_glob
      glob = File.join(directory_path, "#{globular_file_parts}.*")
      Dir.glob(glob)
    end

    # determines the counter value of the filename passed in.
    # params:
    #   filename - string, complete filename
    # returns:
    #   an integer representation of the counter
    def get_counter_for_file(filename)
      CounterFinder.new(filename, @file_extension).counter
    end

  end
end
