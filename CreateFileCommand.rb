require_relative 'Command'
require 'fileutils'

class CreateFileCommand < Command
    attr_accessor(:fileContents)
    attr_accessor(:filepath)
    def initialize(path, contents)
        super("This command takes a filename and file contents, and creates that file.")
        self.fileContents=contents
        self.filepath=path
    end

    # This method creates a file so long as the command already has not been executed and
    # the file does not already exist
    def execute
        if((not File.exist?(@filepath)) and (@hasExecuted == false))
            File::open(@filepath, "w+") {|f| f.write(@fileContents)}
            @hasExecuted=true
        end
    end

    # This method deletes the file so long as the command already has not been undone and
    # the file has not already been deleted
    def undo
        if(File.exist?(@filepath) and @hasExecuted == true)
            File::delete(@filepath)
            @hasExecuted=false
        end
    end
end