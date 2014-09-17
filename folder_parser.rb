class FolderParser
  attr_reader :folder_path
  
  def initialize folder_path
    raise ArgumentError.new("Invalid path #{folder_path}") if(folder_path.nil? || folder_path.empty? || folder_path.chomp.empty?)
    if(Dir.exist?(folder_path))
      @folder_path = File.expand_path(folder_path)
      @folder_path ||= File.expand_path(".") #default
    else
      raise ArgumentError.new("Invalid path #{folder_path}")
    end
  end
  
  # currently assumes C language source files
  def file_paths
    src_file_mask = File.join(@folder_path, "**", "*.c")
    @file_paths =  Dir.glob(src_file_mask)
    return @file_paths
  end
end