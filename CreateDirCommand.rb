require_relative 'Command'
require 'fileutils'

class CreateDirCommand < Command
    attr_accessor(:dir)
    def initialize(n)
        super("This command takes a directory name and creates that directory.")
        self.dir=n
    end

    # This method creates a directory so long as the command already has not been executed and
    # the directory does not already exist
    def execute
        if((not File::directory?(@dir)) and (@hasExecuted == false))
            Dir::mkdir(@dir)
            @hasExecuted=true
        end
    end

    # This method deletes the directory so long as the command already has not been undone and
    # the directory has not already been deleted
    def undo
        if(File::directory?(@dir) and @hasExecuted == true)
            Dir::delete(@dir)
            @hasExecuted=false
        end
    end
end