class StaticPagesController < ApplicationController
  before_filter :authenticate_user!

  authorize_resource :class => false

  def help
  end

  def recommendations
  end
end
