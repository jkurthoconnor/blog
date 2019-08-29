require "sinatra/base"
require "ostruct"
require "psych"
require "redcarpet"
require "date"
require_relative "./htmlwithpygments"


class Blog < Sinatra::Base
  configure do
    set :root, File.expand_path("../..", __FILE__)
    Tilt.register Redcarpet::Markdown
  end

  configure :production do
    set :logging, true
  end

  configure :development do
    require "sinatra/reloader"
    require "pry"

    register Sinatra::Reloader
    set :logging, true
    set :show_exceptions, :after_handler
  end

  before do
    @title = "kurth o'connor"

    headers "Cache-Control" => "public, must-revalidate, max-age=7200",
            "Expires" => Time.at(Time.now + 7200).to_s
  end

  before("/about") do
    topics = []

    Dir.glob("topics/*.yaml") do |file|
      contents = File.read(File.expand_path(file))
      topic = OpenStruct.new(Psych.load(contents))
      topics << topic
    end

    @topics = topics.sort { |a, b| a.priority - b.priority }
  end

  get "/" do
    erb :landing, layout: false
  end

  get "/about" do
    erb :about
  end

  get "/resume" do
    file = File.join(File.expand_path('../..', __FILE__), 'public/kurth_oconnor_resume.pdf')
    send_file(file, type: :pdf, disposition: :inline)
  end

  not_found do
    @message =  "Resource `#{request.env["REQUEST_PATH"] }` is unavailable."
    @about_status = "current"

    erb :about
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
