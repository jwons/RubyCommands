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

    def test_create_new_file
        c = CreateFileCommand.new(@fileName, "Hello World\n")
        c.execute
        assert_equal(true, File.exist?(@fileName))

        c.undo
        assert_equal(false, File.exist?(@fileName))
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
        newFile = CreateFileCommand.new(@fileName, "Hello World\n")
        newFile.execute

        c = RenameFileCommand.new(@fileName, @newName)
        c.execute
        assert_equal(true, File.exist?(@newName))

    end

    def test_rename_order
        File::open(@newName, "w+") {|f| f.write("Hello World\n")}

        c = RenameFileCommand.new(@fileName, @newName)
        c.undo
        assert_equal(true, File.exist?(@newName))

        File::delete(@newName)
        File::open(@fileName, "w+") {|f| f.write("Hello World\n")}

        c.hasExecuted=true
        c.execute
        assert_equal(true, File.exist?(@fileName))

        File::delete(@fileName)
    end

    def test_copy_file
        File::open(@fileName, "w+") {|f| f.write("Hello World\n")}

        c = CopyFileCommand.new(@fileName, @newName)
        c.execute
        assert_equal(true, File.exist?(@fileName))
        assert_equal(true, File.exist?(@newName))

        c.undo
        assert_equal(true, File.exist?(@fileName))
        assert_equal(false, File.exist?(@newName))

        File::delete(@fileName)
    end

    def test_copy_order
        File::open(@newName, "w+") {|f| f.write("Hello World\n")}
        File::open(@fileName, "w+") {|f| f.write("Hello World\n")}

        c = CopyFileCommand.new(@fileName, @newName)

        c.undo
        assert_equal(true, File.exist?(@fileName))
        assert_equal(true, File.exist?(@newName))

        File::delete(@newName)
        c.hasExecuted=true
        c.execute

        assert_equal(true, File.exist?(@fileName))
        assert_equal(false, File.exist?(@newName))
        
        File::delete(@fileName)
    end

    def test_move_file
        File::open(@fileName, "w+") {|f| f.write("Hello World\n")}

        c = MoveFileCommand.new(@fileName, @newName)

        c.execute
        assert_equal(false, File.exist?(@fileName))
        assert_equal(true, File.exist?(@newName))

        c.undo

        assert_equal(true, File.exist?(@fileName))
        assert_equal(false, File.exist?(@newName))

        File::delete(@fileName)
    end

    def test_move_order
        File::open(@newName, "w+") {|f| f.write("Hello World\n")}

        c = MoveFileCommand.new(@fileName, @newName)

        c.undo
        assert_equal(false, File.exist?(@fileName))
        assert_equal(true, File.exist?(@newName))

        c.hasExecuted=true
        File.rename(@newName, @fileName)

        c.execute
        assert_equal(true, File.exist?(@fileName))
        assert_equal(false, File.exist?(@newName))

        File::delete(@fileName)
    end

    def test_delete_file
        File::open(@fileName, "w+") {|f| f.write("Hello World\n")}

        ogLines = File::readlines(@fileName)

        c = DeleteFileCommand.new(@fileName)
        c.execute
        assert_equal(false, File.exist?(@fileName))

        c.undo
        assert_equal(true, File.exist?(@fileName))

        newLines = File::readlines(@fileName)
        assert_equal(ogLines, newLines)

        File::delete(@fileName)
    end

    def test_delete_order
        File::open(@fileName, "w+") {|f| f.write("Hello World\n")}

        c = DeleteFileCommand.new(@fileName)
        c.hasExecuted=true
        c.execute

        assert_equal(true, File.exist?(@fileName))

        File::delete(@fileName)

        c.hasExecuted=false
        c.undo

        assert_equal(false, File.exist?(@fileName))
    end

    def test_create_directory
        c = CreateDirCommand.new(@dirName)

        c.execute
        assert_equal(true, File::directory?(@dirName))

        c.undo
        assert_equal(false, File::directory?(@dirName))
    end

    def test_create_dir_order
        c = CreateDirCommand.new(@dirName)
        Dir::mkdir(@dirName)

        c.undo
        assert_equal(true, File::directory?(@dirName))

        Dir::delete(@dirName)
        c.hasExecuted=true

        c.execute
        assert_equal(false, File::directory?(@dirName))
    end

    def test_rename_directory
        Dir::mkdir(@dirName)
        c = RenameDirCommand.new(@dirName, @newDir)

        c.execute
        assert_equal(true, File::directory?(@newDir))

        c.undo
        assert_equal(true, File::directory?(@dirName))

        Dir::delete(@dirName)
    end

    def test_rename_directory_order
        Dir::mkdir(@newDir)
        c = RenameDirCommand.new(@dirName, @newDir)

        c.undo
        assert_equal(true, File::directory?(@newDir))

        File::rename(@newDir, @dirName)
        c.hasExecuted=true
        c.execute

        assert_equal(true, File::directory?(@dirName))

        Dir::delete(@dirName)
    end

    def test_copy_directory
        Dir::mkdir(@dirName)

        c = CopyDirCommand.new(@dirName, @newDir)

        c.execute
        assert_equal(true, File::directory?(@newDir))
        assert_equal(true, File::directory?(@dirName))
        
        c.undo
        assert_equal(false, File::directory?(@newDir))
        assert_equal(true, File::directory?(@dirName))

        Dir::delete(@dirName)
    end

    def test_copy_directory_order
        Dir::mkdir(@dirName)
        Dir::mkdir(@newDir)

        c = CopyDirCommand.new(@dirName, @newDir)

        c.undo
        assert_equal(true, File::directory?(@newDir))
        assert_equal(true, File::directory?(@dirName))

        Dir::delete(@newDir)
        c.hasExecuted=true

        c.execute
        assert_equal(false, File::directory?(@newDir))
        assert_equal(true, File::directory?(@dirName))

        Dir::delete(@dirName)
    end

    def test_move_directory
        Dir::mkdir(@dirName)

        c = MoveDirCommand.new(@dirName, @newDir)

        c.execute
        assert_equal(true, File::directory?(@newDir))
        assert_equal(false, File::directory?(@dirName))

        c.undo
        assert_equal(false, File::directory?(@newDir))
        assert_equal(true, File::directory?(@dirName))

        Dir::delete(@dirName)
    end

    def test_move_directory_order
        Dir::mkdir(@newDir)

        c = MoveDirCommand.new(@dirName, @newDir)

        c.undo
        assert_equal(true, File::directory?(@newDir))
        assert_equal(false, File::directory?(@dirName))

        FileUtils.cp_r(@newDir, @dirName)
        FileUtils::rm_r(@newDir)

        c.hasExecuted=true
        c.execute

        assert_equal(false, File::directory?(@newDir))
        assert_equal(true, File::directory?(@dirName))

        FileUtils::rm_r(@dirName)
    end

    def test_delete_directory
        Dir::mkdir(@dirName)

        c = DeleteDirCommand.new(@dirName)

        c.execute
        assert_equal(false, File::directory?(@dirName))

        c.undo
        assert_equal(true, File::directory?(@dirName))

        Dir::delete(@dirName)
    end

    def test_delete_directory_order
        Dir::mkdir(@dirName)

        c = DeleteDirCommand.new(@dirName)

        c.hasExecuted=true
        c.execute
        assert_equal(true, File::directory?(@dirName))

        Dir::delete(@dirName)
        c.hasExecuted=false
        c.undo
        assert_equal(false, File::directory?(@dirName))
    end
end