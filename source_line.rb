class SourceLine
  attr_accessor :number, :func
  
  def initialize number, func
    @number, @func = number, func
  end
end
