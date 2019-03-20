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

    # This method will copy the chosen file to a new location and then
    # remove the old, therefore "moving" it. But only if it has not already been moved
    # and executed
    def execute 
        if(@hasExecuted==false and (not File::exist?(@newPath)))
            FileUtils.cp(@ogPath, @newPath)
            File::delete(@ogPath)
            @hasExecuted=true
        end
    end

    # This method will copy the new file to the original location and then
    # remove the new, therefore "moving" it back into place. Must call 'execute' first
    def undo 
        if(@hasExecuted==true and (File::exist?(@newPath)))
            FileUtils.cp(@newPath, @ogPath)
            File::delete(@newPath)
            @hasExecuted=false
        end
    end
end