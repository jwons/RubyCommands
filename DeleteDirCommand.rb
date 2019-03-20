require_relative 'Command'
require 'fileutils'

class DeleteDirCommand < Command
    attr_accessor(:fileName)

    def initialize(n)
        super("This command deletes a given directory")
        self.fileName=n
    end

    # This method will delete the chosen directory if the directory exists
    # and the command has not already been executed
    def execute
        if(@hasExecuted == false and File::directory?(@fileName))
            Dir::delete(@fileName)
            @hasExecuted=true
        end
    end

    # This method will recreate the chosen directory if the directory does not exist
    # and the command has not already been undone
    def undo 
        if(@hasExecuted == true and (not File::directory?(@fileName)))
            Dir::mkdir(@fileName)
            @hasExecuted=false
        end
    end
end