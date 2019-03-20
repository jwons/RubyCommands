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

    # This method will copy the chosen directory to a new location and then
    # remove the old, therefore "moving" it. Only if it has not already been moved
    # and executed
    def execute 
        if(@hasExecuted==false and (not File::directory?(@newPath)))
            FileUtils.cp_r(@ogPath, @newPath)
            FileUtils::rm_r(@ogPath)
            @hasExecuted=true
        end
    end

    # This method will copy the new directory to the original location and then
    # remove the new, therefore "moving" it back into place. Must call 'execute' first
    def undo 
        if(@hasExecuted==true and (File::exist?(@newPath)))
            FileUtils.cp_r(@newPath, @ogPath)
            FileUtils::rm_r(@newPath)
            @hasExecuted=false
        end
    end
end