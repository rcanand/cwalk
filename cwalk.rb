#! /usr/bin/env ruby
require 'byebug'
require 'optparse'
require 'readline'
require_relative 'folder_parser'
require_relative 'name_checker'
require_relative 'func_def'
require_relative 'runner'

DEFAULT_PATH_NAME = "."
DEFAULT_FUNC_NAME = "main"

def parse_options options
  parser = OptionParser.new do |opts|
    opts.banner = 'cwalk [options]\n\n(q to exit)'

    opts.on("-p PATHNAME","--path","The path to look for") do |path|
      options[:pathname] = path
    end

    opts.on("-f FUNCNAME","--func","The entry point function") do |func|
      options[:funcname] = func
    end
  end
  parser.parse!
end

options = {}

def main options  
  parse_options options
  folder_path = FolderParser.new(options[:pathname] || DEFAULT_PATH_NAME).folder_path
  func_name = NameChecker.new(options[:funcname] || DEFAULT_FUNC_NAME).name

  runner = Runner.new(folder_path, func_name)

  prompt = "cwalk(q to exit)> "
  while(runner.cmd != 'q')  
    runner.run
    runner.cmd = Readline.readline(prompt, true)
  end
end

main options