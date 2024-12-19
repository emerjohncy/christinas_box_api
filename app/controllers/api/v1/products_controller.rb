class Api::V1::ProductsController < ApplicationController
  before_action :get_category, only: [ :index, :show, :create, :update, :destroy ]
  before_action :get_product, only: [ :show, :update, :destroy ]

  # GET /categories/:category_id/products || GET /products
  def index
    if @category
      @products = @category.products
    else
      @products = Product.all
    end
    render json: @products
  end

  # GET /categories/:category_id/products/:id || GET /products/:id
  def show
    render json: @product
  end

  # POST /categories/:category_id/products/
  def create
    @product = @category.products.new(product_params)

    if @product.save
      render json: { status: "Success", message: "Product was created successfully.", data: @product }, status: :created
    else
      render json: { status: "Error", message: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH /categories/:category_id/products/:id
  def update
    if @product.update(product_params)
      render json: { status: "Success", message: "Product was updated successfully." }, status: :ok
    else
      render json: { status: "Error", message: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /categories/:category_id/products/:id
  def destroy
    if @product.destroy
      render json: { status: "Success", message: "Product was deleted successfully." }, status: :ok
    else
      render json: { status: "Error", message: "Failed to delete product" }, status: :unprocessable_entity
    end
  end

  private

  def get_category
    if params[:category_id]
      @category = Category.find_by(id: params[:category_id])

      unless @category
        render json: { status: "Error", message: "Category not found" }, status: :not_found
      end
    end
  end

  def get_product
    if @category
      @product = @category.products.find_by(id: params[:id])
    else
      @product = Product.find_by(id: params[:id])
    end

    unless @product
      render json: { status: "Error", message: "Product not found" }, status: :not_found
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :category_id)
  end
end
