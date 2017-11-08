class RemovalchargesController < ApplicationController
  def create
    @removal = Removal.find(params[:removal_id])
    @charge = @removal.removalcharges.create( removalcharge_params )
  end

  def destroy
    @removal = Mugshot.find(params[:removal_id])

    @removal.destroy
    respond_to do |format|
      format.html { redirect_to removal_path(@removal) }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def removalcharge_params
      params.require(:charge).permit(:charge)
    end

end
