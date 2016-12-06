class PhotosController < ApplicationController
  before_filter :set_photo, only: [:show, :edit, :update, :destroy]
	def create
		@mugshot = Mugshot.find(params[:mugshot_id])
		@photo = @mugshot.photos.create( photo_params )

    redirect_to @mugshot

	end

  def destroy
    @mugshot = Mugshot.find(params[:mugshot_id])

    @photo.destroy
    respond_to do |format|
      format.html { redirect_to mugshot_path(@mugshot) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:image)
    end
end
