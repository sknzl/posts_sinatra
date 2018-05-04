require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require "sqlite3"

require_relative "models/post"

DB = SQLite3::Database.new("db/posts.db")

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  @posts = Post.all
  erb :index
end

get '/create:post' do
  @posts = Post.all
  erb :create_post
end

post '/add_post' do
  # binding.pry
  post = Post.new({title: params[:title], url: params[:url]})
  post.save
  redirect "/"
end

get '/delete/:id' do
  post =
  post = Post.find(params[:id].to_i)
  post.destroy
  redirect "/"
end

get '/upvote/:id' do
  post =
  post = Post.find(params[:id].to_i)
  post.votes += 1
  post.save
  redirect "/"
end
