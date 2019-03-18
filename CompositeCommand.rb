require_relative 'Command'
require 'fileutils'

class CompositeCommand < Command
    attr_accessor(:commands)
    attr_accessor(:commandIndex)

    def initialize
        super("")
        self.commands=[]
        self.commandIndex=0
    end

    def addCommand(c)
        @commands << c
    end

    def description
        retVal = "Commands are as follows:\n"

        commandCounter = 0
        for command in @commands
            retVal << "#{commandCounter.to_s}. #{command.description}\n"
            commandCounter += 1
        end

        return(retVal)
    end

    def execute
        if(@commandIndex < commands.length)
            for index in @commandIndex..commands.length - 1
                puts @commandIndex
                @commands[@commandIndex].execute
                @commandIndex += 1
            end
            @hasExecuted=true
        end
    end


    def undo
        if(@commandIndex != 0)
            for index in 0..@commandIndex - 1
                @commandIndex -= 1
                @commands[@commandIndex].undo
            end
        end
    end

    def stepForward(n)
        if (n + @commandIndex) < @commands.length
            for index in 0..n -1
                @commands[@commandIndex].execute
                @commandIndex += 1
            end
        end
        
    end


    def stepBackward(n)
        if (@commandIndex - n) >= 0
            for index in 0..@commandIndex -1
                @commandIndex -= 1
                @commands[@commandIndex].execute
            end
        end
    end

end