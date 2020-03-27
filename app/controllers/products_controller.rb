class ProductsController < ApplicationController
  before_action :move_to_index, except: [:index, :show]
  before_action :set_product, only: [:show, :destroy, :edit, :update, :purchase, :pay, :move_to_purchase]
  before_action :set_category, only: [:edit, :new]
  before_action :move_to_purchase, only: [:purchase, :pay]

  def index
    @product = Procducts.all.order("created_at DESC").limit(3)
  end


  def new
    @product = Product.new
    @product.images.new
    @category_parent_array = ["選択してください"] 
    @category_parent_array = Category.where(ancestry: nil).pluck(:name)  
    @delivery_pay =["送料込み(出品者負担)","着払い(購入者負担)"]
    @lead_time =["1~2日で発送","2~3日で発送","4~7日で発送"]
    @condition =["新品、未使用","未使用に近い","目立った傷や汚れなし","やや傷や汚れあり","傷や汚れあり","全体的に状態が悪い"]
  end 

  def get_category_children
    @category_children = Category.find(params[:parent_name]).children
  end  

  def get_category_grandchildren
    @category_grandchildren = Category.find(params[:child_id]).children
  end 

  def show
    @comment = Comment.new
    @parents = Category.where(ancestry: nil)
    @product.images
    @category = @product.category
    @product.images.each_with_index do |image, i|
      if i == 0
        @image = image
      end
    end
  end

  def edit
    if @product.user_id == current_user.id
      @regist_images = Image.find_by(product_id: @product.id)
      @ids = @product.images.map{|image| image.id }
    else
      flash[:alert] = "商品編集の権限がありません"
      redirect_to product_path(@product)
    end
  end

  def update
    
    
    if @product.user.id != current_user.id
      flash[:alert] = "商品編集の権限がありません"
      redirect_to product_path(@product)
    end
    
    if @product.update(products_params)
      flash[:notice] = '商品の編集が完了しました'
      redirect_to product_path(@product.id)
    else
      flash.now[:alert] = '商品の編集に失敗しました'
      render :edit
    end
  end

  def destroy
    if @product.user.id == current_user.id
      @product.destroy
      flash[:notice] = '出品した商品を削除しました'
      redirect_to root_path
    else
      flash.now[:alert] = '商品の削除に失敗しました'
      render :edit
    end
  end

  def purchase

    if Card.find_by(user_id: current_user.id) == nil
      flash[:alert] = "カードを登録してください"
      redirect_to new_card_path
    else  
      card = Card.find_by(user_id: current_user.id)
      Payjp.api_key = Rails.application.credentials[:PAYJP_PRIVATE_KEY]
      customer = Payjp::Customer.retrieve(card.customer_id)
      @default_card_information = customer.cards.retrieve(card.card_id)
      @regist_images = Image.find_by(product_id: @product.id)
      @product = Product.find(params[:id])
      @profile = Profile.find_by(user_id:@product.user_id)
    end

  end

  def pay
      @product.update(status: 1)
      @card = Card.find_by(user_id: current_user.id)
      Payjp.api_key = Rails.application.credentials[:PAYJP_PRIVATE_KEY]
      Payjp::Charge.create(
        amount: @product.price, #支払金額を引っ張ってくる
        customer: @card.customer_id,  #顧客ID
        currency: 'jpy',              #日本円
      )
      redirect_to confirm_product_path #完了画面に移動
  end

  def confirm
    card = Card.find_by(user_id: current_user.id)
    Payjp.api_key = Rails.application.credentials[:PAYJP_PRIVATE_KEY]
    customer = Payjp::Customer.retrieve(card.customer_id)
    @default_card_information = customer.cards.retrieve(card.card_id)
    @product = Product.find(params[:id])
    @regist_images = Image.find_by(product_id: @product.id)
    @profile = Profile.find_by(user_id:@product.user_id)
  end

  def create
    @product = Product.new(products_params)
    if @product.save
      redirect_to product_path(@product)
    else
      flash[:alert] = "入力されていない項目があります"
      redirect_to new_product_path
    end
  end 

  def search
    @parents = Category.where(ancestry: nil)
    @search = params[:search]
    @search_product = Product.ransack(params[:q])
    if @search
      @products = Product.search(params[:search]).order("created_at DESC").page(params[:page]).per(20)
    else
      @search = Product.ransack(params[:q]).item_name_cont
      @products = @search_product.result.page(params[:page])
    end
    
    unless @search.present?
      flash[:alert] = "キーワードを入力してください"
      redirect_to root_path
    end

  end


  def get_category_children
    @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
  end  

  def get_category_grandchildren
    @category_grandchildren = Category.find(params[:child_id]).children
  end 

  def image_destroy
      @image = Image.find(params[:prevew_id])
      @image.destroy
  end


  private

  def move_to_index
    redirect_to new_user_session_path unless user_signed_in?
  end

  def products_params
    params.require(:product).permit(:item_name, 
                                    :item_detail, 
                                    :brand, 
                                    :condition_id, 
                                    :price, :category_id, 
                                    :delivery_pay_id, 
                                    :prefecture_id, 
                                    :lead_time_id, 
                                    :brand, 
                                    images_attributes: [:id, :image, :_destroy])
                                    .merge(user_id: current_user.id, status: 0)
  end

  def set_product
    @product = Product.find(params[:id])
    @delivery_pay = DeliveryPay.where(id: @product.delivery_pay)
  end

  def set_category
    @category_parent_array = ["選択してください"]
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << parent.name
    end  
    @delivery_pay =["選択してください","送料込み(出品者負担)","着払い(購入者負担)"]
    @lead_time =["選択してください","1~2日で発送","2~3日で発送","4~7日で発送"]
    @condition =["選択してください","新品、未使用","未使用に近い","目立った傷や汚れなし","やや傷や汚れあり","傷や汚れあり","全体的に状態が悪い"]
  end

  def move_to_purchase

    if @product.user_id == current_user.id
      flash[:alert] = "自身が出品した商品は購入できません"
      redirect_to product_path(@product)
    end

    if @product.status == 1
      flash[:alert] = "この商品はすでに購入されています"
      redirect_to product_path(@product)
    end

  end

end