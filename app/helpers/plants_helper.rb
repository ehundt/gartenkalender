module PlantsHelper
  def searched_for_text
    unless @search_inputs.empty?
      text = "Suche nach \""
      text += @search_inputs.collect{ |i| i.humanize }.join(", ")
      text += "\""
    end
    text
  end
end
