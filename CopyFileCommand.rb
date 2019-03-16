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

    def execute
        if(@hasExecuted==false and (not File::exist?(@newPath)))
            FileUtils.cp(@ogPath, @newPath)
            @hasExecuted=true
        end
    end

    def undo 
        if(@hasExecuted==true and (File::exist?(@newPath)))
            File::delete(@newPath)
            @hasExecuted=false
        end
    end
end