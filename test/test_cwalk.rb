#! /usr/bin/env ruby
require 'minitest/autorun'
require_relative '../cwalk.rb'

class TestCWalk < MiniTest::Test
  def setup
    @good_folder_path = "./test/__test__/good"
    @a_func_name = "a"
    @commented_line_number = 6
    @cwalk_good = CWalk.new(@good_folder_path, @a_func_name)
  end
  
  def test_folder_function_works
    cwalk = nil
    assert_silent {
      cwalk = CWalk.new(@good_folder_path, @a_func_name)
    }
    cwalk.run
    files = FunctionDefinition.func_def.files
    assert_equal(1, files.count)
    assert_equal("a.c", File.basename(files[0].path))
    lines = files[0].lines
  end
  
  def test_commented_functions_are_ignored
    skip
    @cwalk_good.run
    refute(FunctionDefinition.func_def.files[0].lines.map(&:number).include?(@commented_line_number))
  end
end