require_relative 'Command'
require 'fileutils'

class CompositeCommand < Command
    # Commands is an array of objects that inherit from the command class, 
    # including possible other CompositeCommands
    attr_accessor(:commands)
    # The index keeps track of where in the array commands have been executed
    attr_accessor(:commandIndex)

    def initialize
        super("")
        self.commands=[]
        self.commandIndex=0
    end

    # This method adds a given command to the array 
    def addCommand(c)
        @commands << c
    end

    # This method will print each description of each command in the array
    def description
        retVal = "Commands are as follows:\n"

        commandCounter = 0
        for command in @commands
            retVal << "#{commandCounter.to_s}. #{command.description}\n"
            commandCounter += 1
        end

        return(retVal)
    end

    # This command will execute each command passed in order they were added
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

    # This method will undo each command passed in reverse order they were added
    def undo
        if(@commandIndex != 0)
            for index in 0..@commandIndex - 1
                @commandIndex -= 1
                @commands[@commandIndex].undo
            end
        end
    end

    # This method will execute n number of commands from the array starting at 
    # the last command executed or otherwise the start. 
    def stepForward(n)
        if (n + @commandIndex) < @commands.length
            for index in 0..n -1
                @commands[@commandIndex].execute
                @commandIndex += 1
            end
        end
        
    end

    # This method will undo n number of commands from the array starting at 
    # the last command executed or otherwise the end. 
    def stepBackward(n)
        if (@commandIndex - n) >= 0
            for index in 0..@commandIndex -1
                @commandIndex -= 1
                @commands[@commandIndex].undo
            end
        end
    end

end