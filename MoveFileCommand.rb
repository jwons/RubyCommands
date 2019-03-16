require_relative 'Command'
require 'fileutils'

class MoveFileCommand < Command
    attr_accessor(:ogPath)
    attr_accessor(:newPath)
    def initialize(o, n)
        super("This command moves a file to a new location")
        self.ogPath=o
        self.newPath=n
    end

    def execute 
        if(@hasExecuted==false and (not File::exist?(@newPath)))
            FileUtils.cp(@ogPath, @newPath)
            File::delete(@ogPath)
            @hasExecuted=true
        end
    end

    def undo 
        if(@hasExecuted==true and (File::exist?(@newPath)))
            FileUtils.cp(@newPath, @ogPath)
            File::delete(@newPath)
            @hasExecuted=false
        end
    end
end