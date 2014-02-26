module SequentialFile

  # This class takes a filename and an extension, and finds the counter (Integer) part of the file name
  class CounterFinder
    NUMBER_REGEX = /\d*/

    # determines the counter value of the filename passed in.
    # params:
    #   filename - string, complete filename
    #   extension - string, the part of the filename that is the extension (e.g. .log or .csv)
    def initialize(filename, extension)
      @filename = File.basename(filename, extension)
      @length = @filename.length
      @index_of_extension_separator = @filename.rindex('.')
    end

    def has_extension_separator?
      !!@index_of_extension_separator
    end

    # returns:
    #   an integer representation of the counter
    def counter
      has_extension_separator? ?
        @filename[@index_of_extension_separator + 1,@length][NUMBER_REGEX].to_i :
        0
    end
  end

end
