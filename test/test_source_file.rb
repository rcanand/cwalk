#! /usr/bin/env ruby
require 'minitest/autorun'
require_relative '../folder_parser.rb'

class TestSourceFile < MiniTest::Test
  def test_can_create_source_file_with_valid_c_file_path
    assert_silent{SourceFile.new("/some/nonexistent/path/a.c", [])}
  end
  
  def test_cannot_create_source_file_with_relative_path
    assert_raises(ArgumentError){SourceFile.new("some/relative/path/a.c", [])}
  end
end