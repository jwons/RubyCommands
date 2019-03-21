require_relative 'Command'
require_relative 'CreateFileCommand'
require_relative 'RenameFileCommand'
require_relative 'CopyFileCommand'
require_relative 'MoveFileCommand'
require_relative 'DeleteFileCommand'
require_relative 'CreateDirCommand'
require_relative 'RenameDirCommand'
require_relative 'CopyDirCommand'
require_relative 'MoveDirCommand'
require_relative 'DeleteDirCommand'
require_relative 'CompositeCommand'

require 'test/unit'

class TestCommands < Test::Unit::TestCase
    attr_accessor(:fileName)
    attr_accessor(:newName)
    attr_accessor(:dirName)
    attr_accessor(:newDir)
    def setup
        puts("Starting new test")
        self.fileName="./testData/test.txt"
        self.newName="./testData/newTest.txt"
        self.dirName="./testData/dir"
        self.newDir="./testData/newDir"
    end

    # To ensure that no files left over from previous tests affect 
    # later tests, clear the test data folder
    def teardown
        FileUtils::rm_r("./testData")
        Dir::mkdir("./testData")
    end

    def test_create_new_file
        
        c = CreateFileCommand.new(@fileName, "Hello World\n")

        # Post-execution a file should exist in the previously blank folder
        c.execute
        assert_equal(true, File.exist?(@fileName))

        # When undone the folder should not have the file anymore
        c.undo
        assert_equal(false, File.exist?(@fileName))

        # Check the inherited description member works
        assert_equal("This command takes a filename and file contents, and creates that file.", c.description)
    end

    def test_create_file_order
        c = CreateFileCommand.new(@fileName, "Hello World\n")

        #Ensure execute can only be called if it hasn't already been called or undone first
        c.hasExecuted=true
        c.execute
        assert_equal(false, File.exist?(@fileName))

        #Ensure undo will only be called if execute has been called first
        c.hasExecuted=false
        File::open(@fileName, "w+") {|f| f.write("Hello World\n")}
        c.undo
        assert_equal(true, File.exist?(@fileName))

        #Remove files
        c.hasExecuted=true
        c.undo

    end

    def test_rename_file
        File::open(@fileName, "w+") {|f| f.write("Hello World\n")}

        # Once executed, the file should have a different name
        c = RenameFileCommand.new(@fileName, @newName)
        c.execute
        assert_equal(true, File.exist?(@newName))

        # Once undone, the file should have the first name
        c.undo
        assert_equal(true, File.exist?(@fileName))
    end

    def test_rename_order
        File::open(@newName, "w+") {|f| f.write("Hello World\n")}

        # Should not be able to set original name back if it has not already
        # been executed
        c = RenameFileCommand.new(@fileName, @newName)
        c.undo
        assert_equal(true, File.exist?(@newName))

        File::delete(@newName)
        File::open(@fileName, "w+") {|f| f.write("Hello World\n")}

        # Should not be able to set execute if it already has executed
        c.hasExecuted=true
        c.execute
        assert_equal(true, File.exist?(@fileName))

    end

    def test_copy_file
        File::open(@fileName, "w+") {|f| f.write("Hello World\n")}

        c = CopyFileCommand.new(@fileName, @newName)

        # After execution there should be two files, the original
        # and the new one that has been copied
        c.execute
        assert_equal(true, File.exist?(@fileName))
        assert_equal(true, File.exist?(@newName))

        # After being undone there should be one file, the original
        c.undo
        assert_equal(true, File.exist?(@fileName))
        assert_equal(false, File.exist?(@newName))

    end

    def test_copy_order
        File::open(@newName, "w+") {|f| f.write("Hello World\n")}
        File::open(@fileName, "w+") {|f| f.write("Hello World\n")}

        c = CopyFileCommand.new(@fileName, @newName)

        # should not be able to undo without executing first
        c.undo
        assert_equal(true, File.exist?(@fileName))
        assert_equal(true, File.exist?(@newName))

        File::delete(@newName)
        c.hasExecuted=true

        # should not be able to execute if already executed
        c.execute
        assert_equal(true, File.exist?(@fileName))
        assert_equal(false, File.exist?(@newName))
    end

    def test_move_file
        File::open(@fileName, "w+") {|f| f.write("Hello World\n")}

        c = MoveFileCommand.new(@fileName, @newName)

        # After execution the file should be changed from old to the new name
        c.execute
        assert_equal(false, File.exist?(@fileName))
        assert_equal(true, File.exist?(@newName))

        # After being undone the file should have its original name, and the new file gone
        c.undo
        assert_equal(true, File.exist?(@fileName))
        assert_equal(false, File.exist?(@newName))
    end

    def test_move_order
        File::open(@newName, "w+") {|f| f.write("Hello World\n")}

        c = MoveFileCommand.new(@fileName, @newName)

        # Cannot be undone if the command has not been executed
        c.undo
        assert_equal(false, File.exist?(@fileName))
        assert_equal(true, File.exist?(@newName))

        c.hasExecuted=true
        File.rename(@newName, @fileName)

        # Cannot execute a command that has already been executed
        c.execute
        assert_equal(true, File.exist?(@fileName))
        assert_equal(false, File.exist?(@newName))
    end

    def test_delete_file
        File::open(@fileName, "w+") {|f| f.write("Hello World\n")}

        ogLines = File::readlines(@fileName)

        c = DeleteFileCommand.new(@fileName)

        # Afer execution file should be gone
        c.execute
        assert_equal(false, File.exist?(@fileName))

        # Afer being undone file should be back
        c.undo
        assert_equal(true, File.exist?(@fileName))

        # The contents should be the same
        newLines = File::readlines(@fileName)
        assert_equal(ogLines, newLines)
    end

    def test_delete_order
        File::open(@fileName, "w+") {|f| f.write("Hello World\n")}

        c = DeleteFileCommand.new(@fileName)
        c.hasExecuted=true

        # Should not be able to execute if already executed
        c.execute
        assert_equal(true, File.exist?(@fileName))

        File::delete(@fileName)

        c.hasExecuted=false

        # Should not be able to undo if not executed
        c.undo
        assert_equal(false, File.exist?(@fileName))
    end

    def test_create_directory
        c = CreateDirCommand.new(@dirName)

        # Directory must exist after execution
        c.execute
        assert_equal(true, File::directory?(@dirName))

        # Directory must be deleted after being undone
        c.undo
        assert_equal(false, File::directory?(@dirName))
    end

    def test_create_dir_order
        c = CreateDirCommand.new(@dirName)
        Dir::mkdir(@dirName)

        # cannot be undone without be executed
        c.undo
        assert_equal(true, File::directory?(@dirName))

        Dir::delete(@dirName)
        c.hasExecuted=true

        # Cannot be executed if already executed
        c.execute
        assert_equal(false, File::directory?(@dirName))
    end

    def test_rename_directory
        Dir::mkdir(@dirName)
        c = RenameDirCommand.new(@dirName, @newDir)

        # Directory must change names when command executed
        c.execute
        assert_equal(true, File::directory?(@newDir))

        # Directory must have original name when undone
        c.undo
        assert_equal(true, File::directory?(@dirName))
    end

    def test_rename_directory_order
        Dir::mkdir(@newDir)
        c = RenameDirCommand.new(@dirName, @newDir)

        # Cannot undo without executing first
        c.undo
        assert_equal(true, File::directory?(@newDir))

        File::rename(@newDir, @dirName)
        c.hasExecuted=true

        # cannot execute twice wihtout undoing 
        c.execute
        assert_equal(true, File::directory?(@dirName))
    end

    def test_copy_directory
        Dir::mkdir(@dirName)

        c = CopyDirCommand.new(@dirName, @newDir)

        # Two directories must exist 
        c.execute
        assert_equal(true, File::directory?(@newDir))
        assert_equal(true, File::directory?(@dirName))
        
        # One directory must exist 
        c.undo
        assert_equal(false, File::directory?(@newDir))
        assert_equal(true, File::directory?(@dirName))
    end

    def test_copy_directory_order
        Dir::mkdir(@dirName)
        Dir::mkdir(@newDir)

        c = CopyDirCommand.new(@dirName, @newDir)

        # Cannot undo without executing
        c.undo
        assert_equal(true, File::directory?(@newDir))
        assert_equal(true, File::directory?(@dirName))

        Dir::delete(@newDir)
        c.hasExecuted=true

        # Cannot execute after an execute
        c.execute
        assert_equal(false, File::directory?(@newDir))
        assert_equal(true, File::directory?(@dirName))
    end

    def test_move_directory
        Dir::mkdir(@dirName)

        c = MoveDirCommand.new(@dirName, @newDir)

        # Directory should be moved post execute
        c.execute
        assert_equal(true, File::directory?(@newDir))
        assert_equal(false, File::directory?(@dirName))

        # Directory should be moved back post undo
        c.undo
        assert_equal(false, File::directory?(@newDir))
        assert_equal(true, File::directory?(@dirName))
    end

    def test_move_directory_order
        Dir::mkdir(@newDir)

        c = MoveDirCommand.new(@dirName, @newDir)

        # Cannot undo without executing 
        c.undo
        assert_equal(true, File::directory?(@newDir))
        assert_equal(false, File::directory?(@dirName))

        FileUtils.cp_r(@newDir, @dirName)
        FileUtils::rm_r(@newDir)

        c.hasExecuted=true

        # Cannot execute if already executed  
        c.execute
        assert_equal(false, File::directory?(@newDir))
        assert_equal(true, File::directory?(@dirName))
    end

    def test_delete_directory
        Dir::mkdir(@dirName)

        c = DeleteDirCommand.new(@dirName)

        # Directory should be deleted after execute
        c.execute
        assert_equal(false, File::directory?(@dirName))

        # Directory should be back after undo
        c.undo
        assert_equal(true, File::directory?(@dirName))
    end

    def test_delete_directory_order
        Dir::mkdir(@dirName)

        c = DeleteDirCommand.new(@dirName)
        c.hasExecuted=true

        # Cannot execute if already executed
        c.execute
        assert_equal(true, File::directory?(@dirName))

        Dir::delete(@dirName)
        c.hasExecuted=false

        # Don't undo if not yet executed
        c.undo
        assert_equal(false, File::directory?(@dirName))
    end

    # This tests to make sure a directory can be deleted and undone 
    def test_deleting_dir_with_contents
        Dir::mkdir(@dirName)
        Dir::mkdir("./testData/dir/moreDirs")
        File::open("./testData/dir/test.txt", "w+") {|f| f.write("Hello World\n")}
        File::open("./testData/dir/test2.txt", "w+") {|f| f.write("Hello World again\n")}
        File::open("./testData/dir/moreDirs/test3.txt", "w+") {|f| f.write("Hello World!!!\n")}

        c = DeleteDirCommand.new(@dirName)
        
        c.execute
        assert_equal(false, File::directory?(@dirName))

        c.undo
        assert_equal(true, File::directory?(@dirName))
        assert_equal(true, File::directory?("./testData/dir/moreDirs"))
        assert_equal(true, File::exist?("./testData/dir/test.txt"))
        assert_equal(true, File::exist?("./testData/dir/test2.txt"))
        assert_equal(true, File::exist?("./testData/dir/moreDirs/test3.txt"))
    end

    # This composite command creates moves and deletes files
    # It tests the stepping forward and backward by checking the index
    # into the array of commands. It also checks to make sure the 
    # stepping cannot go out of range. 
    def test_composite_commands
        cc = CompositeCommand.new

        cc.addCommand(CreateFileCommand.new(@fileName, "Hello World!"))
        cc.addCommand(MoveFileCommand.new(@fileName, @newName))
        cc.addCommand(DeleteFileCommand.new(@newName))

        # there won't be files at the beginning and end of the execute and undo
        # just in the middle
        cc.execute
        assert_equal(cc.commandIndex, (cc.commands.length()))

        cc.undo
        assert_equal(cc.commandIndex, 0)

        # The first command is creating a file, check for its existence 
        cc.stepForward(1)
        assert_equal(cc.commandIndex, 1)
        assert_equal(true, File.exist?(@fileName))

        cc.stepBackward(1)
        assert_equal(cc.commandIndex, 0)
        assert_equal(false, File.exist?(@fileName))

        cc.stepForward(5)
        assert_equal(cc.commandIndex, 0)

        cc.stepForward(2)
        assert_equal(cc.commandIndex, 2)
        assert_equal(true, File.exist?(@newName))

        cc.stepBackward(5)
        assert_equal(cc.commandIndex, 2)

        cc.undo
        assert_equal(cc.commandIndex, 0)
        assert_equal(false, File.exist?(@newName))
        assert_equal(false, File.exist?(@fileName))
    end

    # This test also tests the composite class but with a sub-composite class 
    def test_composite_with_composite
        cc1 = CompositeCommand.new

        cc1.addCommand(CreateFileCommand.new(@fileName, "Hello World!"))
        cc1.addCommand(MoveFileCommand.new(@fileName, @newName))

        cc2 = CompositeCommand.new
        cc2.addCommand(cc1)
        cc2.addCommand(CopyFileCommand.new(@newName, @fileName))

        cc2.execute

        assert_equal(true, File.exist?(@fileName))
        assert_equal(true, File.exist?(@newName))

        cc2.undo

        assert_equal(false, File.exist?(@fileName))
        assert_equal(false, File.exist?(@newName))
    end

end
