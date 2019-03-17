require_relative 'Command'
require 'fileutils'

class DeleteDirCommand < Command
    attr_accessor(:fileName)

    def initialize(n)
        super("This command deletes a given directory")
        self.fileName=n
    end

    def execute
        if(@hasExecuted == false and File::directory?(@fileName))
            Dir::delete(@fileName)
            @hasExecuted=true
        end
    end

    def undo 
        if(@hasExecuted == true and (not File::directory?(@fileName)))
            Dir::mkdir(@fileName)
            @hasExecuted=false
        end
    end
end