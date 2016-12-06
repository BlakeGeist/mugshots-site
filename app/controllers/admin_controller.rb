class AdminController < ApplicationController
  def index
    @state = State.new
    @states = State.all

    unless user_signed_in?
      redirect_to root_path
    end
  end
end
