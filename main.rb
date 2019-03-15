require_relative 'Command'
require_relative 'CreateFileCommand'

require 'test/unit'

class TestCommands < Test::Unit::TestCase
    def setup
        puts("Starting new test")
    end

    def test_create_new_file
        fileName = "./test.txt"
        c = CreateFileCommand.new(fileName, "Hello World\n")
        c.execute
        assert_equal(true, File.exist?(fileName))

        c.undo
        assert_equal(false, File.exist?(fileName))
    end

    
end