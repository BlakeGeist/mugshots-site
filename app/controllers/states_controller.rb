class StatesController < ApplicationController
  def index
    @states = States.all.order("created_at DESC")
  end

  def show
    @state = State.friendly.find(params[:id])
  end

  def new
    @state = State.new
  end

  def edit
    @state = State.find(params[:id])
  end

  def create
    @state = State.new(state_params)

    if @state.save
      redirect_to :back
    end
  end

  def update
    @state = State.find(params[:id])

    if @state.update(state_params)
      redirect_to @state
    else
      render 'edit'
    end
  end

  def destroy
    @state = State.friendly.find(params[:id])
    @state.destroy

    redirect_to :back
  end

  private
    def state_params
      params.require(:state).permit(:name, :abbv)
    end

end
