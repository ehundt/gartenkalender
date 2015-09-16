module PlantsHelper

  def display_options_menu(selected_option)
    options = { all:          "alle",
                only_active:  "aktive",
                only_public:  "öffentliche",
                only_created: "von mir erstellte" }

    output = '<button type="button" class="btn btn-default">'

    output += link_to options[selected_option], plants_path(selected_option => 1)
    options.delete(selected_option)

    output += '</button>
               <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <span class="caret"></span>
               </button>
               <ul class="dropdown-menu">'

    options.each do |option, title|
      output += '<li>'
      output += link_to title, plants_path(option => 1)
      output += '</li>'
    end
    output += '</ul>'
    output.html_safe
  end
end
