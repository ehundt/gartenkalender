module ApplicationHelper
  def markdown # TODO: this will be called several times, but should be created only once!
    require 'logger'
    Logger.new("log/debug.log").debug("new Redcarpet markdown object created!")
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end

  def display_date_time(date_time)
    if date_time <= 1.day.ago
      return "am #{l date_time, :format => :short}"
    else
      return "vor #{distance_of_time_in_words(date_time, to_time = DateTime.now)}"
      #l date_time, :format => :default
    end
  end
end
