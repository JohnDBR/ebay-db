class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :destroy]
  before_action :set_product, only: [:index]
  skip_before_action :get_current_user, only: [:index, :show]

  def index
    render json: @product.comments#.to_json(:include => { :user => {:only => :username} }), status: :ok 
  end

  def user_index
    render_ok @current_user.comments
  end

  def show 
    render_ok @comment
  end

  def create
    comment = Comment.new(user_id:@current_user.id, product_id:params[:product_id], comment:params[:comment])
    save_and_render comment
  end

  def destroy
    if @comment.user_id == @current_user.id
      render_ok @comment.destroy
    elsif is_current_user_admin.nil?
      render_ok @comment.destroy 
    end
  end

  private
  def set_comment
    @comment = Comment.find params[:id]
  end

  def set_product
    @product = Product.find params[:product_id]
  end
end