require "sequential_file/version"
require "sequential_file/namer"

# SequentialFile::Base is not loaded by default, because it is a reference implementation, and third party libs may not need or want it.
# It can be used by adding the following to any third party lib:
#require "sequential_file/base"

module SequentialFile
  # Just a namespace here...
end
