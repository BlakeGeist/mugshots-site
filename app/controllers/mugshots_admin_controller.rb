class MugshotsAdminController < ApplicationController
  def index
    @mugshots = Mugshot.all.order("created_at DESC")
    unless user_signed_in?
      redirect_to root_path
    end
  end
end
