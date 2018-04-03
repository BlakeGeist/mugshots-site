class CountiesController < ApplicationController
  def index
    @counties = Counties.all.order("created_at DESC")
    @description="View mugshots from #{@county.name.capitalize} County."
  end

  def show
    @county = County.friendly.find(params[:id])
    @state = State.find(@county.state_id)
    @search = Mugshot.where(county: @county).order("created_at DESC").ransack(params[:q])
    @the_search = @search.result(distinct: true)
    @mugshots = @the_search.paginate(:page => params[:page], :per_page => 24)

    @title = "#{@county.name.capitalize} County Mugshots"
    @description = "View mugshots from #{@county.name.capitalize} County."
    @canonical_url = state_county_url(@county.state, @county)
  end

  def multi_offender_list
    @county = County.friendly.find(params[:county_id])
    @mugshots = Mugshot.where(county: @county).order("created_at DESC").group(:name, :id).paginate(:page => params[:page], :per_page => 24)
    render 'multi_offender_list'
  end

  def new
    @county = County.new
  end

  def edit
    @county = County.find(params[:id])
  end

  def create
    @state = State.friendly.find(params[:state_id])
  	@county = @state.counties.create( county_params )
    redirect_to :back
  end

  def update
    @county = County.friendly.find(params[:id])
    if @county.update(county_params)
      redirect_to :back
    end
  end

  def destroy
    @county = County.friendly.find(params[:id])
    @county.destroy
    redirect_to :back
  end

  private
    def county_params
      params.require(:county).permit(:name, :abbv, :list, :que, :description)
    end
end
