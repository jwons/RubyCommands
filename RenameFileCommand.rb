require_relative 'Command'
require 'fileutils'

class RenameFileCommand < Command
    attr_accessor(:filepath)
    attr_accessor(:newName)

    def initialize(path, nn)
        self.filepath=path
        self.newName=nn
        self.description= "This command takes a filename and a new name, and will rename the file to the new name."
        self.hasExecuted=false
    end

    def execute
        if(File.exist?(@filepath) and @hasExecuted == false)
            File.rename(@filepath, @newName)
        end
    end

    def undo
        if(File.exist?(@newName) and @hasExecuted == true)
            File.rename(@newName, @filepath)
        end
    end
end