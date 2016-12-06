class ChargesController < ApplicationController
  def create
    @mugshot = Mugshot.find(params[:mugshot_id])
    @charge = @mugshot.charges.create( charge_params )

    redirect_to @mugshot

  end

  def destroy
    @mugshot = Mugshot.find(params[:mugshot_id])

    @charge.destroy
    respond_to do |format|
      format.html { redirect_to mugshot_path(@mugshot) }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def charge_params
      params.require(:charge).permit(:charge)
    end

end
