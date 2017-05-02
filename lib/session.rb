require 'json'

class Session
  attr_reader :session

  def initialize(req)
    cookie = req.cookies['_rails_lite_app']
    @session = cookie ? JSON.parse(cookie) : {}
    @session[:path] = '/'
  end

  def [](key)
    session[key]
  end

  def []=(key, val)
    session[key] = val
  end

  def store_session(res)
    cookie = session.to_json
    res.set_cookie('_rails_lite_app', cookie)
  end
end
