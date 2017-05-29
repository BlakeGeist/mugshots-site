class MugshotsAdminController < ApplicationController
  def index
    @mugshots = Mugshot.all.order("created_at DESC").page(params[:page]).per_page(100)
    unless user_signed_in?
      redirect_to root_path
    end
  end
end
