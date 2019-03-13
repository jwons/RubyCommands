require_relative './Command'
require './CreateFileCommand'

require 'test/unit'

class TestCommands < Test::Unit::TestCase
    def setup
        puts("Starting new test")
    end

    def test_create_new_file
        c = CreateFileCommand.new(".", "Hello World")
        c.execute
    end
end
