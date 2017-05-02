require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'

# Server to test router

$games = [
  { id: 1, name: "Zelda: Breath of the Wild" },
  { id: 2, name: "Nier: Automata" }
]

$reviews = [
  { id: 1, game_id: 1, text: "Best Zelda yet!" },
  { id: 2, game_id: 2, text: "Game of the Year!" },
  { id: 3, game_id: 1, text: "10 out of 10!" }
]

class ReviewsController < ControllerBase
  def index
    reviews = $reviews.select do |review|
      review[:game_id] == Integer(params['game_id'])
    end

    render_content(reviews.to_json, "application/json")
  end
end

class Games2Controller < ControllerBase
  def index
    render_content($games.to_json, "application/json")
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/games$"), Games2Controller, :index
  get Regexp.new("^/games/(?<game_id>\\d+)/reviews$"), ReviewsController, :index
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
