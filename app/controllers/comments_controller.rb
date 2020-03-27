class CommentsController < ApplicationController
  before_action :set_product

  def create
    @comment = @product.comments.new(comment_params)
    if @comment.save
      respond_to do |format|
        format.json
      end
    else
      @comments = @group.comments.includes(:user)
      flash[:alert] = 'メッセージを入力してください。'
      redirect_to product_path(@product)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      respond_to do |format|
        format.json
      end
    else
      @comments = @group.comments.includes(:user)
      flash.now[:alert] = 'コメントの削除に失敗しました。'
      redirect_to product_path(@product)
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def comment_params
    params.require(:comment).permit(:text, :product_id).merge(user_id: current_user.id)
  end

end
