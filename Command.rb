class Command 
    attr_accessor(:description)
    attr_accessor(:hasExecuted)
    def initialize(desc)
        self.description=desc
        self.hasExecuted=false
    end
end