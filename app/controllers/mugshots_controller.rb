class MugshotsController < ApplicationController
  include AdminHelper

  def index
    @mugshots = Mugshot.all.order("created_at DESC").order("created_at DESC").page(params[:page]).per_page(20)
  end

  def show
    @mugshot = Mugshot.friendly.find(params[:id])
    @county = County.find(@mugshot.county_id)
    @state = State.find(@county.state_id)
    @title="#{@mugshot.name.capitalize} | #{@county.name} County"
  end

  def new
    @mugshot = Mugshot.new
  end

  def edit
    @mugshot = Mugshot.find(params[:id])
  end

  def create
    @mugshot = Mugshot.new(mugshot_params)

    if @mugshot.save
      redirect_to @mugshot
    else
      render 'new'
    end
  end

  def update
    @mugshot = Mugshot.find(params[:id])

    if @mugshot.update(mugshot_params)
      redirect_to @mugshot
    else
      render 'edit'
    end
  end

  def destroy
    @mugshot = Mugshot.find(params[:id])
    @mugshot.destroy

    redirect_to mugshots_path
  end

  def re_scrape_mugshot

    @mugshot = Mugshot.friendly.find(params[:mugshot_id])

    re_fetch_mugshot('ada')

    respond_to do |format|
      format.js
    end

  end

  private
    def mugshot_params
      params.require(:mugshot).permit(:name, :photo)
    end
end
