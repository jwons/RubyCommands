# This class represents all of the members common across all file and dir commands
class Command 
    attr_accessor(:description)
    attr_accessor(:hasExecuted)

    # All commands have descriptions and when an object is created it has not been executed
    # yet so set the execution flag to false
    def initialize(desc)
        self.description=desc
        self.hasExecuted=false
    end
end