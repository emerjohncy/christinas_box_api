class Api::V1::CategoriesController < ApplicationController
  before_action :get_category, only: [ :show, :update, :destroy ]

  # GET /categories
  def index
    @categories = Category.order(:id)

    render json: { status: "Success", data: ActiveModelSerializers::SerializableResource.new(@categories, each_serializer: CategorySerializer) }
  end

  # GET /categories/1
  def show
    render json: { status: "Success", data: CategorySerializer.new(@category) }
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      render json: { status: "Success", message: "Category was created successfully.", data: CategorySerializer.new(@category) }, status: :created
    else
      render json: { status: "Error", message: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      render json: { status: "Success", message: "Category was updated successfully." }, status: :ok
    else
      render json: { status: "Error", message: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  def destroy
    if @category.destroy
      render json: { status: "Success", message: "Category was deleted successfully." }, status: :ok
    else
      render json: { status: "Error",  messages: "Failed to delete category" }, status: :unprocessable_entity
    end
  end

  private

  def get_category
    @category = Category.find_by(id: params[:id])
    unless @category
      render json: { status: "Error", message: "Category not found" }, status: :not_found
    end
  end

  def category_params
    params.require(:category).permit(:name, :status)
  end
end
