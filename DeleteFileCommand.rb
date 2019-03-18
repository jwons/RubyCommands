require_relative 'Command'
require 'fileutils'

class DeleteFileCommand < Command
    attr_accessor(:fileName)
    attr_accessor(:contents)
    def initialize(n)
        super("This command deletes a given file")
        self.fileName=n
        self.contents=""
    end

    def execute
        if(@hasExecuted == false and File::exist?(@fileName))
            self.contents=File::readlines(@fileName)
            File::delete(@fileName)
            @hasExecuted=true
        end
    end

    def undo 
        if(@hasExecuted == true and (not File::exist?(@fileName)))
            File::open(@fileName, "w+") { |f| 
            for line in contents
                f.puts(line)
            end }
            @hasExecuted=false
        end
    end
end