#! /usr/bin/env ruby
require 'minitest/autorun'
require_relative '../runner.rb'

class TestRunner < MiniTest::Test
  def setup
    @good_folder_path = './test/__test__/good'
    @a_func_name = 'a'
    @commented_line_number = 6
    @runner_good = Runner.new(@good_folder_path, @a_func_name)
  end
  
  def test_folder_function_works
    runner = nil
    assert_silent {
      runner = Runner.new(@good_folder_path, @a_func_name)
    }
    runner.run
    files = FunctionDefinition.func_def.files
    assert(files.count>0)
    file_paths = files.map(&:path)
    file_names = file_paths.map{|p|File.basename(p)}
    assert(file_names.include?('a.c'))
    
    # ****
    assert(file_names.include?('a2.c'))
    # ****
    
    refute(file_names.include?('a.rb'))  
    a_c_file = files.find{|f| File.basename(f.path) == 'a.c'} 
    lines = a_c_file.lines
    line_numbers = lines.map(&:number)
    assert(line_numbers.include?(1) && line_numbers.include?(9))
  end
    
  def test_folder_func_filter_valid_filename_works_with_single_file_match
    @runner_good.run
    @runner_good.cmd = 'a2.c'
    @runner_good.run
    files = FunctionDefinition.func_def.files
    assert(files.count>0)
    file_paths = files.map(&:path)
    file_names = file_paths.map{|p|File.basename(p)}
    assert(file_names.include?('a2.c'))

    assert_equal(1, file_names.count('a2.c'))
    
    # ****
    assert_equal(2, file_names.count('a.c'))      
    # ****
    
    refute(file_names.include?('a.rb'))  
    a2_c_file = files.find{|f| File.basename(f.path) == 'a2.c'} 
    lines = a2_c_file.lines
    line_numbers = lines.map(&:number)
    puts line_numbers.inspect
    assert(line_numbers.include?(1))
  end

  def test_folder_func_filter_valid_filename_works_with_multiple_file_path_matches
    @runner_good.run
    @runner_good.cmd = 'a.c'
    @runner_good.run
    files = FunctionDefinition.func_def.files
    assert(files.count>0)
    file_paths = files.map(&:path)
    file_names = file_paths.map{|p|File.basename(p)}
    assert(file_names.include?('a.c'))
    assert_equal(2, file_names.count('a.c'))
    
    # ****
    refute(file_names.include?('a2.c'))      
    # ****
    
    refute(file_names.include?('a.rb'))  
    a_c_file = files.find{|f| File.basename(f.path) == 'a.c'} 
    lines = a_c_file.lines
    line_numbers = lines.map(&:number)
    assert(line_numbers.include?(1) && line_numbers.include?(9))
    assert_equal(2, line_numbers.count(1))
  end
  
  def test_folder_func_filter_valid_filename_colon_linenumber_works
    skip
  end
  
  def test_folder_func_filter_valid_linenumber_works_with_single_match
    skip
  end
  
  def test_folder_func_filter_valid_linenumber_works_with_multiple_matches
    skip
  end
  
  def test_folder_func_change_valid_folder_works
    skip
  end
  
  def test_folder_func_change_valid_func_works
    skip
  end
  
  def test_empty_cmd_is_ignored
    skip
  end
  
  def test_folder_func_filter_nomatch_file_errors_gracefully
    skip
  end
  
  def test_folder_func_filter_nonexistent_file_errors_gracefully
    skip
  end
  
  def test_folder_func_empty_files_ignored_silently
    skip
  end
  
  def test_folder_func_file_filter_valid_line_number_works
    skip
  end

  def test_folder_func_file_filter_invalid_line_number_gives_meaningful_error
    skip
  end  
  
  def test_empty_folder_func_uses_defaults
    skip
  end

  def test_commented_functions_are_ignored
    skip
    @runner_good.run
    refute(FunctionDefinition.func_def.files[0].lines.map(&:number).include?(@commented_line_number))
  end  
end