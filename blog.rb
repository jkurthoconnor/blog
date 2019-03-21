require 'sinatra/base'
require 'sinatra/reloader'

class Blog < Sinatra::Base

  configure do
    set :root, File.dirname(__FILE__)
  end

  configure :development do
    require 'pry'
    register Sinatra::Reloader
    set :logging, true
    set :show_exceptions, :after_handler
  end

  get '/' do
    @title = "Kurth O'Connor"
    @test_string = "Project root is `#{self.class.root}`"
    erb :landing
  end

  get '/blog' do
    @title = "Blog"
    @test_string = "This is a blog title"
    erb :blog
  end

  get '/:value/:other_val' do
    @title = "Sample params"
    @test_string = "#{params[:value]} : #{params[:other_val]}\n\n"
    erb :blog
  end

  not_found do
    redirect '/'
  end

  error 500 do
    puts "How could you break this?"
  end

# run server when file is invoked directly;
# allows rackup, tests, etc to run file indirectly
  if __FILE__ == $0
    run!
  end
end
