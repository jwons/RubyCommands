require_relative 'Command'
require 'fileutils'

class CreateFileCommand < Command
    attr_accessor(:fileContents)
    attr_accessor(:filepath)
    def initialize(path, contents)
        self.fileContents=contents
        self.filepath=path
    end

    def execute
        if(not File.exist?(@filepath))
            File::open(@filepath, "w+") {|f| f.write(@fileContents)}
        end
    end

    def undo
        if(File.exist?(@filepath))
            File::delete(@filepath)
        end
    end
end