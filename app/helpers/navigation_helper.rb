module NavigationHelper

  # def display_tabs
  #   output =  "<nav role='navigation'>"
  #   output += "<ul class=\"nav nav-tabs\" role=\"tablist\">"
  #   output += display_tab(startpage_index_path, "Meine Aufgaben")
  #   output += display_tab(plants_path, "Meine Pflanzen")
  #   output += display_tab(search_index_path, "Pflanzensuche")
  #   output += display_tab(new_plant_path, "Neue Pflanze")
  #   output += display_tab(users_path, "Gartenfreunde")
  #   output += "</ul></nav>"
  #   output.html_safe
  # end

  def display_tab(link_path, title, classes=nil, disabled=false)
    output = "<li "
    output += current_page?(link_path) ? "class=active" : ""
    output += disabled ? "class=disabled" : ""
    output += ">"
    if classes.nil?
      output += link_to title, link_path
    else
      output += link_to title, link_path, class: classes
    end
    output += "</li>"
    output
  end

  def display_plant_tabs(plant)
    output = "<ul class=\"nav nav-tabs\">"

    # plant is my plant
    if (user_signed_in? and plant.user == current_user)
      output += display_tab(plant, "Beschreibung", "small-nav")
      output += display_tab(plant_tasks_path(plant), "Pflege", "small-nav")
#      output += display_tab(new_plant_task_path(plant), "Neue Aufgabe", "small-nav")
      output += display_tab(plant_done_tasks_path(plant), "Tagebuch", "small-nav")

      unless plant.original?
        if plant.original.public
          output += display_tab(plant.original, "Original", "small-nav")
        else
          output += display_tab(plant.original, "Original", "small-nav", true)
        end
      end

    # plant is not my plant
    # i have copied plant
    elsif user_signed_in? && plant.copied_by?(current_user)
      output += display_tab(plant.copy_of(current_user), "Beschreibung", "small-nav")
      output += display_tab(plant_tasks_path(plant.copy_of(current_user)), "Pflege", "small-nav")
#      output += display_tab(new_plant_task_path(plant), "Neue Aufgabe", "small-nav")
      output += display_tab(plant_done_tasks_path(plant.copy_of(current_user)), "Tagebuch", "small-nav")
      output += display_tab(plant, "Original", "small-nav")

    # anonymous user or plant is not copied and not my plant
    else
      output += display_tab(plant, "Original", "small-nav")
      output += display_tab(plant_tasks_path(plant), "Pflege", "small-nav")
    end

    if plant.original.public || plant.comments.count > 0
      output += display_tab(plant_comments_path(plant.original), "Kommentare", "small-nav")
    end

    output += "</ul>"
    output.html_safe
  end
end
