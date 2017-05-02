require 'rack'
require_relative '../lib/controller_base.rb'
require_relative '../lib/router'

class Movie
  attr_reader :name, :director

  def self.all
    @movies ||= []
  end

  def initialize(params = {})
    params ||= {}
    @name, @director = params["name"], params["director"]
  end

  def errors
    @errors ||= []
  end

  def valid?
    unless @director.present?
      errors << "Owner can't be blank"
      return false
    end

    unless @name.present?
      errors << "Name can't be blank"
      return false
    end
    true
  end

  def save
    return false unless valid?

    Movie.all << self
    true
  end

  def inspect
    { name: name, director: director }.inspect
  end
end

class MoviesController < ControllerBase
  def create
    @movie = Movie.new(params["movie"])
    if @movie.save
      flash[:notice] = "Saved movie successfully"
      redirect_to "/movies"
    else
      flash.now[:errors] = @movie.errors
      render :new
    end
  end

  def index
    @movies = Movie.all
    render :index
  end

  def new
    @movie = Movie.new
    render :new
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/movies$"), MoviesController, :index
  get Regexp.new("^/movies/new$"), MoviesController, :new
  get Regexp.new("^/movies/(?<id>\\d+)$"), MoviesController, :show
  post Regexp.new("^/movies$"), MoviesController, :create
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)
