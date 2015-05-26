module SearchHelper
  def searched_for_text
    unless @inputs.blank?
      text = "Suche nach \""
      text += @inputs.collect{ |i| i.humanize }.join(", ")
      text += "\""
    end
    text
  end
end
