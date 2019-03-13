require_relative 'Command'

class CreateFileCommand < Command
    attr_accessor(:fileContents)
    attr_accessor(:filepath)
    def initialize(path, contents)
        
        self.fileContents=contents
        self.filepath=path
    end

    def execute
        if(not File.exist?(@filepath))
            File.new(@filepath)
        end
    end
end