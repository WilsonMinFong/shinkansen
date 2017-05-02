require 'rack'
require_relative '../lib/controller_base'

# Server to test session cookies.  Refreshing page should increment by 1
# May increment by 2 (once for page, once for favicon load)
class MyController < ControllerBase
  def go
    session["count"] ||= 0
    session["count"] += 1
    render :counting_show
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
