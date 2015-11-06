require File.expand_path(File.join(File.dirname(__FILE__), "../../spec", "support", "controller_macros"))
require File.expand_path(File.join(File.dirname(__FILE__), "../../spec", "factories", "users"))
#require 'FactoryGirl'

Given /^I am not authenticated$/ do
  visit('/users/sign_out') # ensure that at least
end

Given /^a user (.+) has an account$/ do |first_name|
  user = FactoryGirl.create(:user)
  sign_in user
end

When /^I am logged in$/ do |user|
  login_user
  #create_new_user_session_for( user )
end

def create_new_user_session_for(user)
  # TODO create proper setter and getter methods for instance variables
  #@current_user = User.where(first_name: user ) # ! method raises exception on failure
  #@current_session =  Devise::SessionsController.new(@current_user)  # ! method raises exception on failure
  @current_user = User.find_by_first_name!(user) # ! method raises exception on failure
  @current_session = UserSession.create!(@current_user)  # ! method raises exception on failure
end

Given /^I am a new, authenticated user$/ do
  email = 'testing@man.net'
  password = 'secretpass'
  User.new(:email => email, :password => password, :password_confirmation => password).save!

  visit '/users/sign_in'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Einloggen"
end
