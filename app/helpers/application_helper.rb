module ApplicationHelper
  def markdown # TODO: this will be called several times, but should be created only once!
    require 'logger'
    Logger.new("log/debug.log").debug("new Redcarpet markdown object created!")
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end
end
