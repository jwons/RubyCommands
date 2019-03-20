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

    # This method copies a directory to a new position if it has not already been done
    def execute
        if(@hasExecuted==false and (not File::directory?(@newPath)))
            FileUtils.cp_r(@ogPath, @newPath)
            @hasExecuted=true
        end
    end

    # This method removes a copied directory if it has not already been undone
    def undo 
        if(@hasExecuted==true and (File::directory?(@newPath)))
            FileUtils::rm_r(@newPath)
            @hasExecuted=false
        end
    end
end