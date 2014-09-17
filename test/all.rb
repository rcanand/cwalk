#! /usr/bin/env ruby 

require 'minitest/autorun'

if __FILE__ == $0
  Dir.glob('./**/test/test_*.rb'){ |f| require f }
end