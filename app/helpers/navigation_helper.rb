module NavigationHelper

  def display_tabs
    output = "<ul class=\"nav nav-tabs\" role=\"tablist\">"
    output += display_tab(root_path, "Aufgaben")
    output += display_tab(plants_path, "Meine Pflanzen")
    output += display_tab(new_plant_path, "Neue Pflanze")
    output += display_tab(search_index_path, "Pflanzensuche")
    output += display_tab(users_path, "Gartenfreunde")
    output += "</ul>"
    output.html_safe
  end

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
      output += display_tab(plant, "Meine Pflanze", "small-nav")
      output += display_tab(plant_tasks_path(plant), "Meine Aufgaben", "small-nav")
      output += display_tab(plant_done_tasks_index_path(plant), "Erledigt", "small-nav")

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
      output += display_tab(plant.copy_of(current_user), "Meine Pflanze", "small-nav")
      output += display_tab(plant_tasks_path(plant.copy_of(current_user)), "Meine Aufgaben", "small-nav")
      output += display_tab(plant_done_tasks_index_path(plant.copy_of(current_user)), "Erledigt", "small-nav")
      output += display_tab(plant, "Original", "small-nav")

    else
      output += display_tab(plant, "Original", "small-nav")
      output += display_tab(plant_tasks_path(plant), "Meine Aufgaben", "small-nav")
    end

    if plant.comments.present?
      output += display_tab(plant_comments_path(plant.original), "Kommentare", "small-nav")
      # TODO: why is plant.public == nil when it s actually false in DB???
    elsif plant.public
      output += display_tab(plant_comments_path(plant.original), "Kommentare", "small-nav")
    elsif plant.original.public
      output += display_tab(plant_comments_path(plant.original), "Kommentare", "small-nav")
    end

    output += "</ul>"
    output.html_safe
  end
end
