module CommentsHelper
  def display_date_time(date_time)
    if date_time <= 1.day.ago
      return "am #{l date_time, :format => :short}"
    else
      return "vor #{distance_of_time_in_words(date_time, to_time = DateTime.now)}"
      #l date_time, :format => :default
    end
  end
end
