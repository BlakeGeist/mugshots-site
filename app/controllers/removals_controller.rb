class RemovalsController < ApplicationController
  def index
    @removals = Removal.all.order("created_at DESC")
  end

  def create
    @removal = Removal.new(removal_params)
    @mugshot = Mugshot.find(params[:mugshotID])
    @county = @mugshot.county
    @state = @county.state
    @photo = Photo.find(params[:photo])
    @removal.photo = @photo.image.url
    if @removal.save
      redirect_to state_county_path(@state, @county)
    end
  end

  def show
    @removal = Removal.find(params[:id])
  end

  def destroy
    @removal = Removal.find(params[:id])
    @removal.destroy
    redirect_to :back
  end

  def remove_mugshot
    @removal = Removal.find(params[:id])
    @mugshot = Mugshot.find(@removal.mugshotID)
    @mugshot.destroy
    redirect_to root_path
  end

  private
    def removal_params
      params.permit(:name, :county, :photo, :mugshotID, :email)
    end

end
