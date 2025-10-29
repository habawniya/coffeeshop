class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = Item.where(available: true)
    @items = @items.where(category_id: params[:category_id]) if params[:category_id].present?
    @unavailable_items = Item.where(available: false)

    respond_to do |format|
    format.html
    format.turbo_stream do
    render turbo_stream: turbo_stream.replace(
      "items_list",
      partial: "items/items_list",
      locals: { items: @items }
    )
     end
   end
  end

  def show
    authorize @item
  end

  def new
    @item = Item.new
    authorize @item
  end

  def create
    @item = Item.new(item_params)
    authorize @item

    if @item.save
      redirect_to items_path, notice: "Item created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @item
  end

  def update
    authorize @item
    if @item.update(item_params)
      redirect_to items_path, notice: "Item updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @item
    @item.destroy
    redirect_to items_path, notice: "Item deleted successfully."
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :price, :tax_rate, :available, :category_id, :image)
  end
end