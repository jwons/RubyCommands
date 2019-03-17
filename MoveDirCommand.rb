require_relative 'Command'
require 'fileutils'

class MoveDirCommand < Command
    attr_accessor(:ogPath)
    attr_accessor(:newPath)
    def initialize(o, n)
        super("This command moves a directory to a new location")
        self.ogPath=o
        self.newPath=n
    end

    def execute 
        if(@hasExecuted==false and (not File::directory?(@newPath)))
            FileUtils.cp_r(@ogPath, @newPath)
            FileUtils::rm_r(@ogPath)
            @hasExecuted=true
        end
    end

    def undo 
        if(@hasExecuted==true and (File::exist?(@newPath)))
            FileUtils.cp_r(@newPath, @ogPath)
            FileUtils::rm_r(@newPath)
            @hasExecuted=false
        end
    end
end