require 'sinatra/base'
require 'pry'

class Blog < Sinatra::Base
  get '/' do
    "hello world!"
  end

#
# run server when file is invoked directly;
  if __FILE__ == $0
    run!
  end
end
