#! /usr/bin/env ruby
require 'minitest/autorun'
require_relative '../folder_parser.rb'

class TestFolderParser < MiniTest::Test
  def setup
    @valid_folder = File.expand_path('./test/__test__')
    @invalid_folder = './nofolder'
    @file_path = './test_folder_parser.rb'
  end
  
  def test_cannot_pass_nil_to_folder_parser
    assert_raises(ArgumentError){FolderParser.new}
    assert_raises(ArgumentError){FolderParser.new('')}
    assert_raises(ArgumentError){FolderParser.new(' ')}
    assert_raises(ArgumentError){FolderParser.new("\t")}
    assert_raises(ArgumentError){FolderParser.new("\n")}
  end
  
  def test_can_parse_valid_folder
    assert_silent {FolderParser.new(@valid_folder)}
  end
  
  def test_invalid_folder_raises_error
    assert_raises(ArgumentError){FolderParser.new(@invalid_folder)}
  end
  
  def test_passing_file_path_raises_error
    assert_raises(ArgumentError){FolderParser.new(@file_path)}
  end
  
  def test_can_get_file_list_from_folder
    fp = FolderParser.new(@valid_folder)
    
    refute_nil(fp.file_paths) 
    fp.file_paths.each do |f|
      assert_equal '.c', f[-2,2]
    end
  end
end