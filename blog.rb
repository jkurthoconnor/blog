require "sinatra/base"
require "ostruct"
require "psych"
require "redcarpet"
require "date"

class Blog < Sinatra::Base

  configure do
    set :root, File.expand_path("..", __FILE__)
    Tilt.register Redcarpet::Markdown
  end

  configure :development do
    require "sinatra/reloader"
    require "pry"

    register Sinatra::Reloader

    set :logging, true
    set :show_exceptions, :after_handler
  end

  before do
    headers "Cache-Control" => "public, must-revalidate, max-age=7200",
            "Expires" => Time.at(Time.now + 7200).to_s

    @title = "kurth o'connor"

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true)
  end

  before("/blog*") do
    @posts = []

    Dir.glob("articles/*.md") do |article|
      meta, body = File.read(File.expand_path(article)).split("\n\n", 2)
      post = OpenStruct.new(Psych.load(meta))
      post.body = body
      post.resource = post.title.strip
                                .split[0..4]
                                .map { |w| w.gsub(/\W/, "") }
                                .join("-")
                                .downcase
                                .prepend("blog/")
      @posts << post
    end
  end

  get "/" do

    erb :landing
  end

  get "/projects/?" do
    erb :project_index
  end

  get "/blog/?" do
    erb :blog_index
  end

  get "/blog/:title" do
    @post = @posts.find { |post| post.resource.include?(params[:title]) }

    pass unless @post

    erb :blog_post
  end

  not_found do
    @message =  "Resource `#{request.env["REQUEST_PATH"] }` is unavailable."

    erb :landing
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
