require_relative 'Command'
require 'fileutils'

class CopyDirCommand < Command
    attr_accessor(:ogPath)
    attr_accessor(:newPath)
    def initialize(o, n)
        super("This command copies a directory to a new location")
        self.ogPath=o
        self.newPath=n
    end

    def execute
        if(@hasExecuted==false and (not File::directory?(@newPath)))
            FileUtils.cp_r(@ogPath, @newPath)
            @hasExecuted=true
        end
    end

    def undo 
        if(@hasExecuted==true and (File::directory?(@newPath)))
            FileUtils::rm_r(@newPath)
            @hasExecuted=false
        end
    end
end