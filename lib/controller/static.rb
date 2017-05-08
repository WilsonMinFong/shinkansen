require 'byebug'
class Static
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    app.call(env)
    debugger
    # ['200', { 'Content-type' => 'text/html' }, [render_exception(e)]]
  end
end
