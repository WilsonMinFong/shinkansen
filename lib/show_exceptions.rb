require 'erb'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    app.call(env)

  rescue StandardError => e
    ['500', { 'Content-type' => 'text/html' }, [render_exception(e)]]
  end

  def source_code_preview(e)
    path, line = e.backtrace[0].split(":")

    source_code = IO.readlines(path)

    line_num = line.to_i
    start_preview = [0, line_num - 3].max
    end_preview = [line_num + 3, source_code.length].min

    source_code[start_preview...end_preview]
  end

  private

  def render_exception(e)
    path = "lib/templates/rescue.html.erb"
    template = ERB.new(File.read(path))

    template.result(binding)
  end

end
