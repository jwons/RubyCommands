require_relative 'MoveDirCommand'
require 'fileutils'

# This "Delete" command works similar to how something is 'deleted' on a OS like MacOS or Windows
# rather than straight 'rm'ing it from existence, it is moved to the trash. In this case, the 
# trash is a hidden directory with the same name. Because it is being moved to the trash, this 
# inherits from the Move dir class, since that is what 'delete' is doing. 
class DeleteDirCommand < MoveDirCommand
    def initialize(n)
        # Given /testData/dir this will produce /testData/.dirTrash
        # This allows the "deletion" of the folder by moving it to a hidden folder for the time being 
        super(n, "#{File.dirname(n)}/.#{File.basename(n)}Trash")
    end
end