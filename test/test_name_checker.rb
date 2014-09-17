#! /usr/bin/env ruby
require 'minitest/autorun'
require_relative '../name_checker.rb'

class TestNameChecker < MiniTest::Test
  def test_will_verify_valid_names
    ["foo", "main", "foo_bar", "main_foo", "auto_main", " foo ", "name1", "_name"].each do |name|
      assert_silent{NameChecker.new(name)}
      assert_equal(NameChecker.new(name).name, name.chomp)
    end
  end
  
  def test_will_fail_invalid_names
    ["&foo", "auto", "foo bar", "1name", " foo\tbar "].each do |name|
      assert_raises(ArgumentError){NameChecker.new(name)}
    end
  end
end
