class MugshotsAdminController < ApplicationController
  def index
    unless user_signed_in?
      redirect_to root_path
    end
    
    @mugshots = Mugshot.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 100)

    #multi offender list
    @mugshots = Mugshot.where(name: Mugshot.select(:name).group(:name).having('count(*) > 1')).order("created_at DESC").paginate(:page => params[:page], :per_page => 100)

    respond_to do |format|
      format.js
      format.html
    end
  end
end
