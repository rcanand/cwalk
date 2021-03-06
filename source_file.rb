require 'coderay'

class SourceFile
  attr_accessor :path, :lines
  
  def initialize path, lines
    @path = File.expand_path(path)
    @path, @lines= path, lines
  end
  
  def print
    @lines.each do |l|
      puts "\nIn #{@path}:#{l.number}\n\n#{CodeRay.scan(l.func, :c).term}\n\n"
    end
  end
end