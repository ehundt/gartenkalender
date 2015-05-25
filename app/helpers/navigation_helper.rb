module NavigationHelper
  def active_class(link_path)
    if current_page?(link_path)
      "class=active"
    end
  end

  def display_tabs
    output = "<ul class=\"nav nav-tabs\" role=\"tablist\">"
    output += display_tab(root_path, "Aufgaben")
    output += display_tab(plants_path, "Meine Pflanzen")
    output += display_tab(new_plant_path, "Neue Pflanze")
    output += display_tab(plants_search_path, "Pflanzensuche")
    output += display_tab(users_path, "Gartenfreunde")
    output += "</ul>"
    output.html_safe
  end

  def display_tab(link_path, title)
    output = "<li "
    output += active_class(link_path) || ""
    output += ">"
    output += link_to title, link_path if link_path
    output += "</li>"
    output
  end
end
