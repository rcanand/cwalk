#! /usr/bin/env ruby

require 'minitest/autorun'
require 'byebug'
require_relative '../func_def'

class TestFunctionDefinition < MiniTest::Test
  def setup
  end
  
  def test_can_create_func_def
    assert_silent {FunctionDefinition.new("foo", [])}
  end
  
  def test_can_create_func_def_with_valid_names
    ["foo", "main", "foo_bar", "main_foo", "auto_main", " foo ", "name1", "_name"].each do |name|
      assert_silent{FunctionDefinition.new(name, [])}
    end
  end
  
  def test_cannot_create_func_def_with_invalid_names
    ["&foo", "auto", "foo bar", "1name", " foo\tbar "].each do |name|
     assert_raises(ArgumentError, "#{name} failed"){FunctionDefinition.new(name,[])}
    end
  end  
  
  def test_clear_fd_works
    skip
  end
end