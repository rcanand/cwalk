require_relative 'source_file'
require_relative 'source_line'

class FunctionDefinition
  @func_def = nil
  
  class << self
    attr_accessor :func_def
    
    def clear
      @func_def = nil
    end
        
    def parse name, file_path
      funcdefpattern = /(?<full>[\w*]*\s*\**\b#{name}\b\s*(?<para_expression>\(([^()]|\g<para_expression>)*\))\s*(?<brace_expression>\{([^{}]|\g<brace_expression>)*\}))/
      file = File.read(file_path)
      matches = file.scan(funcdefpattern) 
      matches.each do |match|
        func = match[0]
        line = nil
        unless(file.split(func).empty?)
          line = file.split(func).first.scan(/\n/).length + 1
        end
           
        fd_f_l = FunctionDefinition.add_function_definition name, file_path, line, func 
        raise 'Fatal error: unable to add function definition' if fd_f_l.nil?
      end
    end
    
    def find_fd_f_l(func_name, file_path, line_number)
      return nil unless (!(@func_def.nil?) && (@func_def.name == func_name))
      fmatch = @func_def.files.find do |f|
        File.identical?(f.path, file_path)
      end
      return nil if (fmatch.nil?)
      lmatch = fmatch.lines.find do |l|
        l.number == line_number
      end
      return nil if lmatch.nil?
      
      return [@func_def, fmatch, lmatch]
    end
    
    def find_fd_f(func_name, file_path)
      return nil unless (!(@func_def.nil?) && (@func_def.name == func_name))
      
      fmatch = @func_def.files.find do |f|
        File.identical?(f.path, file_path)
      end
      return nil if (fmatch.nil?)

      return [@func_def, fmatch]
    end
    
    def find_fd_fname(func_name, file_name)
      return nil unless (!(@func_def.nil?) && (@func_def.name == func_name))
      
      fmatches = @func_def.files.find_all do |f|
        File.basename(f.path) == file_name
      end
      return nil if (fmatches.nil? || fmatches.empty?)

      return [@func_def, fmatches]
    end
    
    
    def find_fd(func_name)
      return nil unless (@func_def && @func_def.name && (@func_def.name == func_name))
      return @func_def
    end
    
    # finds or adds fd, f, l and returns an array with [fd, f, l]
    def add_function_definition func_name, file_path, line, func
      fd_f_l_match = FunctionDefinition.find_fd_f_l(func_name, file_path, line)
      # puts "[fd, f, l] match was #{fd_f_l_match.inspect}"
      return fd_f_l_match unless fd_f_l_match.nil?
      
      fd_f_match = FunctionDefinition.find_fd_f(func_name, file_path)
      # puts "[fd, f] match was #{fd_f_match.inspect}"
      if(fd_f_match)
        l = SourceLine.new(line, func)
        
        fd_f_match[1].lines << l
        
        fd_f_match << l # append line to fd_f_match to complete the three items        
        return fd_f_match # [fd, f, l]
      end
      
      fd_match = FunctionDefinition.find_fd(func_name)
      # puts "fd match was #{fd_match.inspect}"
      if(fd_match)
        l = SourceLine.new(line, func)
        f = SourceFile.new(file_path, [l])
        fd_match.files << f         
        return [fd_match, f, l]
      end
      
      # no match found at all, so construct entire chain
      l = SourceLine.new(line, func)
      f = SourceFile.new(file_path, [l])
      fd = FunctionDefinition.new(func_name, [f])
      # puts "[fd, f, l] created: #{[fd,f,l].inspect}"
      @func_def = fd           
      return [fd, f, l]
    end
  end
  
  attr_accessor :name, :files
  
  def initialize name, files
    @name = NameChecker.new(name).name
    @files = files
  end
  
  def print
    @files.each do |f|
      f.lines.each do |l|
        puts "\nFunction '#{@name}' found in #{f.path}:#{l.number}\n\n#{l.func}\n\n"
      end
    end
  end
  
end






