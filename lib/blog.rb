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

  before("/projects*") do
    @projects = []

    Dir.glob("projects/*.yaml") do |file|
      contents = File.read(File.expand_path(file))
      project = OpenStruct.new(Psych.load(contents))
      @projects << project
    end
  end

  get "/" do
    @home_status = "current"
    erb :landing, layout: false
  end

  get "/about" do
    @about_status = "current"
    erb :about
  end

  get "/projects/?" do
    @project_status = "current"
    erb :project_index
  end

  get "/blog/?" do
    @blog_status = "current"
    erb :blog_index
  end

  get "/blog/:title" do |title|
    @blog_status = "current"
    @post = @posts.find { |post| post.resource.include?(title) }
    pass unless @post

    markdown = Redcarpet::Markdown.new(HTMLwithPygments, fenced_code_blocks: true)
    erb :blog_post, locals: { markdown: markdown } 
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
