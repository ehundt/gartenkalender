class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    #startpage_first_steps_path
    startpage_welcome_path
  end
end
