require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = req.params.merge(params)
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "Content already rendered" if already_built_response?

    res.location = url
    res.status = 302
    session.store_session(res)
    self.already_built_response = true
  end

  def render_content(content, content_type)
    raise "Content already rendered" if already_built_response?

    res['Content-Type'] = content_type
    res.write(content)
    session.store_session(res)
    self.already_built_response = true
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    path = "views/#{controller_name}/#{template_name}.html.erb"
    template = ERB.new(File.read(path))

    content = template.result(binding)
    render_content(content, "text/html")
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  def invoke_action(action_name)
    send(action_name)
    render(action_name) unless already_built_response?
  end

  protected

  attr_writer :already_built_response
end
