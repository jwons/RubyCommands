require_relative 'Command'
require_relative 'CreateFileCommand'
require_relative 'RenameFileCommand'
require_relative 'CopyFileCommand'

require 'test/unit'

class TestCommands < Test::Unit::TestCase
    attr_accessor(:fileName)
    attr_accessor(:newName)
    def setup
        puts("Starting new test")
        self.fileName="./testData/test.txt"
        self.newName="./testData/newTest.txt"
    end

    def test_create_new_file
        c = CreateFileCommand.new(@fileName, "Hello World\n")
        c.execute
        assert_equal(true, File.exist?(@fileName))

        c.undo
        assert_equal(false, File.exist?(@fileName))
    end

    def test_new_file_execute_undo_order
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
end