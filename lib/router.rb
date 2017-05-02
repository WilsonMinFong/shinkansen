require_relative './route'

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |method|
    define_method(method) do |pattern, controller_class, action_name|
      add_route(pattern, method, controller_class, action_name)
    end
  end

  def match(req)
    routes.find { |route| route.matches?(req) }
  end

  def run(req, res)
    route = match(req)

    if route
      route.run(req, res)
    else
      res.status = 404
      res.write("Route does not exist")
    end
  end
end
