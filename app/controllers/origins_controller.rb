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
    if is_my_origin? 
      if is_not_a_purchase_associated?
        @origin.update_attributes origin_params 
        save_and_render @origin
      end
    end
  end

  def destroy
    if is_my_origin?
      if is_not_a_product_associated?
        render_ok @origin.destroy
      end
    end
  end

  private 
  def set_origin
    @origin = Origin.find params[:id]
  end

  def is_my_origin?
    if @origin.user.id == @current_user.id then true else permissions_error ; false end
  end

  def is_not_a_product_associated?
    if Product.where(origin_id:@origin.id).empty?
      true
    else
      render json: {authorization: 'You can not edit/destroy origin with products associated'}, status: :unprocessable_entity
      false
    end
  end 

  def is_not_a_purchase_associated?
    render = false
    Product.where(origin_id:@origin.id).map { |product| if !product.purchases.empty? then render = true ; break end }
    if !render
      true 
    else  
      render json: {authorization: 'You can not edit/destroy products that users already bought, we have to preserve the history'}, status: :unprocessable_entity
      false
    end
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
