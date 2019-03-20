require 'sinatra/base'

class Blog < Sinatra::Base
  configure do
    set :root, File.dirname(__FILE__)
  end

  configure :development do
    require 'pry'
    set :logging, true
  end


  get '/' do
    settings.root
    settings.app_file
  end

# run server when file is invoked directly;
# allows rackup, tests, etc to run file indirectly
  if __FILE__ == $0
    run!
  end
end
