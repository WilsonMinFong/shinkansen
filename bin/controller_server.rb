require 'rack'
require_relative '../lib/controller_base'

# Server to test ControllerBase render_content and redirect_to methods
class MyController < ControllerBase
  def go
    if @req.path == "/games"
      render_content("Here lies the game backlog!", "text/html")
    else
      redirect_to("/games")
    end
  end
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  MyController.new(req, res).go
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
