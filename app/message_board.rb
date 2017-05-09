require 'rack'
require_relative '../lib/controller/router'
require_relative '../lib/controller/show_exceptions'
require_relative './controllers/messages_controller'
require_relative '../lib/model/db_connection'

router = Router.new
router.draw do
  get Regexp.new("^/$"), MessagesController, :index
  get Regexp.new("^/messages$"), MessagesController, :index
  post Regexp.new("^/messages$"), MessagesController, :create
  get Regexp.new("^/messages/new$"), MessagesController, :new
  get Regexp.new("^/messages/(?<message_id>\\d+)$"), MessagesController, :show
  delete Regexp.new("^/messages/(?<message_id>\\d+)$"), MessagesController, :destroy
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use ShowExceptions
  run app
end.to_app

Rack::Server.start(
 app: app,
 Port: 3000
)
