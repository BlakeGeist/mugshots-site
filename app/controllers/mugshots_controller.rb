class MugshotsController < ApplicationController
  include AdminHelper

  def index
    @mugshots = Mugshot.all.order("created_at DESC").order("created_at DESC").page(params[:page]).per_page(20)
  end

  def show
    @mugshot = Mugshot.friendly.find(params[:id])
    @county = County.find(@mugshot.county_id)
    @state = State.find(@county.state_id)
    @title="#{@mugshot.name.capitalize} | #{@county.name.capitalize} County, #{@county.state.name}"
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
    @county = County.find(@mugshot.county)
    @state = State.find(@county.state)
    @mugshot.destroy
    redirect_to :back
  end

  def re_scrape_mugshot
    @mugshot = Mugshot.friendly.find(params[:mugshot_id])
    @county = @mugshot.county
    re_fetch_mugshot(@county.name)
    @mugshot.refetched = true
    @mugshot.save
    respond_to do |format|
      format.js
    end
  end


  def modal
    @mugshot = Mugshot.friendly.find(params[:mugshot_id])
    respond_to do |format|
      format.js
    end
  end

  private
    def mugshot_params
      params.require(:mugshot).permit(:name, :photo, :refetched)
    end
end
