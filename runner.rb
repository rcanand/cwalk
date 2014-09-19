#! /usr/bin/env ruby
require 'optparse'
require_relative 'folder_parser'
require_relative 'name_checker'
require_relative 'func_def'

class Runner
  attr_accessor :folder_path, :func_name, :file_name, :cmd, :history
  
  def initialize folder_path, func_name
    @folder_path = FolderParser.new(folder_path).folder_path
    @folder_path ||= FolderParser.new('.').folder_path
    
    @func_name = NameChecker.new(func_name).name
    @func_name ||= NameChecker.new("main").name
    
    @file_name = nil
    @history = []
    @cmd = "" # no cmd at start of program    
  end
    
  def do_start
    # output initial state
    puts "\nProject folder is #{@folder_path}\n\n"
    puts "\nEntry point function: #{@func_name}\n\n"
    
    FunctionDefinition.clear
    @file_name = nil
    @src_files = FolderParser.new(@folder_path).file_paths
    
    @src_files.each do |file_path|
      FunctionDefinition.parse(@func_name, file_path)  
    end      
    
    @func_def = FunctionDefinition.find_fd(@func_name)
    if @func_def.nil?
      puts "\n\nNo results to show. try another search\n\n"
    else
      @func_def.print 
    end
  end
  
  def do_folder
    # clear everything
    folder_path = FolderParser.new(@cmd).folder_path
    puts "Change project folder to #{folder_path}. Sure?(y|n)"
    if(STDIN.getc == 'y')
      @folder_path = folder_path
      puts "Folder path changed to #{folder_path}"      
      FunctionDefinition.clear      
      do_start
    else
      puts "Cancelled. No change to folder."
    end
  end
  
  def do_func_name
    raise StandardError.new("Cannot search for function name without a valid folder") if (@folder_path.nil? || @folder_path.empty?)
    puts "Using folder #{@folder_path}"
    @func_name = NameChecker.new(@cmd.chomp).name
    do_start
  end
  
  def do_files
    raise StandardError.new("Invalid folder") if (@folder_path.nil? || @folder_path.empty?)
    raise StandardError.new("Invalid function name") if (@func_name.nil? || @func_name.empty?)


    @file_name = @cmd.chomp
    fs = FunctionDefinition.find_fd_fname(@func_name, @file_name)[1]
    fs.each(&:print)
  end
  
  def do_files_line
    raise StandardError.new("Invalid folder") if (@folder_path.nil? || @folder_path.empty?)
    raise StandardError.new("Invalid function name") if (@func_name.nil? || @func_name.empty?)
    
    file_name, line = @cmd.split(':')
    
    @file_name = file_name.chomp
    fs = FunctionDefinition.find_fd_fname(@func_name, @file_name)[1]
    line.chomp!
    line_number = Integer(line)
    
    fs.each do |f|
      l = nil
      l = FunctionDefinition.find_fd_f_l(@func_name, f.path, line_number)[2] rescue nil
      puts "\n\nIn #{f.path}:#{line}\n\n#{l.func}\n\n" if((!l.nil?)  && l.number == line_number)
    end
  end
  
  def do_line
    raise StandardError.new("Invalid folder") if (@folder_path.nil? || @folder_path.empty?)
    raise StandardError.new("Invalid function name") if (@func_name.nil? || @func_name.empty?)
    
    line_number = Integer(@cmd.chomp)
    fs = FunctionDefinition.find_fd_fname(@func_name, @file_name)[1]
    fs.each do |f|
      l = nil
      l = f.lines.find do |ln|
        ln.number == line_number
      end
    
      puts "\n\nIn #{f.path}:#{line_number}\n\n#{l.func}\n\n" if((!l.nil?) && (!l.func.empty?) && l.number == line_number)
    end
  end
  
  def cmd_type
    if(@cmd == "" && @history.empty?)
      return :start
    else  
      folder_path = FolderParser.new(@cmd).folder_path rescue nil
      return :folder if(folder_path)
      
      func_name = NameChecker.new(@cmd.chomp).name rescue nil
      return :func_name unless (func_name.nil? || func_name.empty?)
      fs = FunctionDefinition.find_fd_fname(@func_name, @cmd.chomp)[1] rescue nil
      return :files unless(fs.nil?) 
      
      file, line = @cmd.split(':') rescue nil
      file_name = file.chomp
      unless(file_name.nil? || file_name.empty?)
        fs = FunctionDefinition.find_fd_fname(@func_name, file_name)[1] rescue nil
        unless (fs.nil?)
            @file_name = file_name
            line.chomp!
            line_number = Integer(line) rescue nil
            return :files_line unless line_number.nil?
        end
      end
      line_number = nil
      line_number = Integer(@cmd.chomp) rescue nil
      return :line unless line_number.nil?
    end
  end
  
  def run
    self.send("do_#{cmd_type}") 
    @history << @cmd
  end
end
