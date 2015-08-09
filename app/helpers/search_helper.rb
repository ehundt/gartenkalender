module SearchHelper
  def searched_for_text
    search_terms = Array.new()
    types = { :creator  => "AutorIn",
              :name     => "Pflanzenname",
              :category => "Kategorie" }
    unless @searched_for.blank?
      @searched_for.each do |type, value|
        unless value.blank? || value == "keine"
          search_terms.push("#{types[type]}: \"#{value.split(' ').map{ |val| val.humanize }.join('" oder "')}\"")
        end
      end
      text = "Suche nach "
      text += search_terms.join(" und ")
    end
    text
  end
end
