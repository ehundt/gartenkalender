module ApplicationHelper
  def markdown
    require 'logger'
    Logger.new("log/debug.log").debug("new Redcarpet markdown object created!")
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end
end
