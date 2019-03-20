require_relative 'Command'
require 'fileutils'

class RenameDirCommand < Command
    attr_accessor(:oldDir)
    attr_accessor(:newName)

    def initialize(od, nn)
        super("This command takes a filename and a new name, and will rename the file to the new name.")
        self.oldDir=od
        self.newName=nn
    end

    # This method will rename a chosen directory if it has not already been renamed
    def execute
        if(File.directory?(@oldDir) and @hasExecuted == false)
            File.rename(@oldDir, @newName)
            @hasExecuted=true
        end
    end

    # This method will change the directory back to its original name if 
    # it has not already been undone. 
    def undo
        if(File.exist?(@newName) and @hasExecuted == true)
            File.rename(@newName, @oldDir)
            @hasExecuted=false
        end
    end
end