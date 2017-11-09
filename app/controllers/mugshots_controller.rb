class MugshotsController < ApplicationController
  include AdminHelper

  def index
    @mugshots = Mugshot.all.order("created_at DESC").page(params[:page]).per_page(20)
    @canonical_url = root_url
  end

  def show
    @mugshot = Mugshot.friendly.find(params[:id])
    @county = County.find(@mugshot.county_id)
    @state = State.find(@county.state_id)
    @title = "#{@mugshot.name.capitalize} | #{@county.name.capitalize} County, #{@county.state.name}"
    @canonical_url = state_county_mugshot_url(@mugshot.county.state, @mugshot.county, @mugshot)

    @mugshots = Mugshot.all.where.not(county: [nil, ""])
    @mugshots = @mugshots.search(@mugshot.name)
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
    respond_to do |format|
      format.js
    end
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

  def sitemap
    @states = State.all
    @title = 'HTML Sitemap'
  end

  def xml_sitemap
    @states = State.all
    @title = 'XML Sitemap'
    respond_to do |format|
      format.xml
      format.html
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
      params.require(:mugshot).permit(:name, :photo, :refetched, :org_name)
    end
end
