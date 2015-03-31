module ApplicationHelper
  def show_logged_in_status
    if current_user
      if (current_user.first_name && current_user.last_name)
        status = "#{current_user.first_name} #{current_user.last_name}"
      else
        status = current_user.email
      end
      status += " (Administrator)" if current_user.admin?
    else
      "Logged out"
    end
  end
end
