module PlantsHelper

  def link_with_params(type, sorting_param, selection_param)
    sort_options = { name:               { title: "Name",      order: "asc" },
                     cached_votes_total: { title: "Bewertung", order: "desc" } }

    sel_options = { all:          "alle",
                    only_active:  "aktive",
                    only_public:  "öffentliche",
                    only_created: "von mir erstellte" }

    if type == :sorting
      title = sort_options[sorting_param][:title]
    elsif type == :selection
      title = sel_options[selection_param]
    end

    link_to title, plants_path( :sort_by        => sorting_param,
                                :filter         => selection_param,
                                #selection_param => 1,
                                :order          => sort_options[sorting_param][:order])
  end

  def display_duration(plant)
    if plant.duration % 7 == 0
      display_duration = "#{plant.duration / 7} Wochen"
    else
      display_duration = "#{plant.duration / 30} Monate"
    end
  end
end
