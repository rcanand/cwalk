class NameChecker
  attr_reader :name    
  
  def initialize name
    init_keywords
    raise ArgumentError.new("#{name} is not a valid function name because it is a reserved keyword in C") if @keywords.include?(name)

    if(name =~ /\A\s*[a-zA-Z_][a-zA-Z0-9_]*\s*\Z/)
      @name = name.chomp
    else
      raise ArgumentError.new("#{name} is an invalid function name")
    end
    @name = name
  end
  
  def init_keywords
    @keywords = %w-
    auto
    break
    case
    char
    const
    continue
    default
    do
    double
    else
    enum
    extern
    float
    for
    goto
    if
    int
    long
    register
    return
    short
    signed
    sizeof
    static
    struct
    switch
    typedef
    union
    unsigned
    void
    volatile
    while-
  end  
end