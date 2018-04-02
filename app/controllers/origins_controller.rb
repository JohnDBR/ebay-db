class OriginsController < ApplicationController
  before_action :set_origin, only: [:show, :update, :destroy]

  def index 
    render_ok @current_user.origins
  end

  def show
    render_ok @origin
  end

  def create
    origin = Origin.new({user:@current_user}.merge origin_params)
    save_and_render origin
  end

  def update
    if @origin.user_id == @current_user.id 
      @origin.update_attributes origin_params 
      save_and_render @origin
    else
      permissions_error
    end
  end

  def destroy
    if @origin.user_id == @current_user.id 
      render_ok @origin.destroy  
    else
      permissions_error
    end
  end

  private 
  def set_origin
    @origin = Origin.find params[:id]
  end

  def origin_params
    params.permit(
      :country,
      :state,
      :city,
      :postal_code,
      :address,
      :description
    )
  end
end
