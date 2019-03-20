require_relative 'Command'
require 'fileutils'

class CopyFileCommand < Command
    attr_accessor(:ogPath)
    attr_accessor(:newPath)
    def initialize(o, n)
        super("This command copies a file to a new location")
        self.ogPath=o
        self.newPath=n
    end

    # This method copies a file to a new position if it has not already been done
    def execute
        if(@hasExecuted==false and (not File::exist?(@newPath)))
            FileUtils.cp(@ogPath, @newPath)
            @hasExecuted=true
        end
    end

    # This method removes a copied file if it has not already been undone
    def undo 
        if(@hasExecuted==true and (File::exist?(@newPath)))
            File::delete(@newPath)
            @hasExecuted=false
        end
    end
end