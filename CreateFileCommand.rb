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

    def execute
        if((not File.exist?(@filepath)) and (@hasExecuted == false))
            File::open(@filepath, "w+") {|f| f.write(@fileContents)}
            @hasExecuted=true
        end
    end

    def undo
        if(File.exist?(@filepath) and @hasExecuted == true)
            File::delete(@filepath)
            @hasExecuted=false
        end
    end
end