class MugshotsAdminController < ApplicationController
  def index
    @mugshots = Mugshot.all.order("created_at DESC")
  end
end
