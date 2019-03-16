require_relative 'Command'
require 'fileutils'

class CreateDirCommand < Command
    attr_accessor(:dir)
    def initialize(n)
        super("This command takes a directory name and creates that directory.")
        self.dir=n
    end

    def execute
        if((not File::directory?(@dir)) and (@hasExecuted == false))
            Dir::mkdir(@dir)
            @hasExecuted=true
        end
    end

    def undo
        if(File::directory?(@dir) and @hasExecuted == true)
            Dir::delete(@dir)
            @hasExecuted=false
        end
    end
end