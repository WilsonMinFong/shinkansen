require 'json'

class Flash
  attr_reader :now

  def initialize(req)
    cookie = req.cookies['_shinkansen_app_flash']
    @now = cookie ? JSON.parse(cookie) : {}
    @flash = { path: '/' }
  end

  def [](key)
    key_string = key.to_s
    flash[key_string] || now[key_string]
  end

  def []=(key, val)
    flash[key] = val
  end

  def store_flash(res)
    cookie = flash.to_json
    res.set_cookie('_shinkansen_app_flash', cookie)
  end

  protected

  attr_reader :flash
end
