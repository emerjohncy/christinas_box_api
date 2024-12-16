class Api::V1::CategoriesController < ApplicationController
  before_action :get_category, only: [:show]

  # GET /categories
  def index
    @categories = Category.all

    render json: @categories
  end

  # GET /categories/1
  def show
    render json: @category
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      render json: { status: 'Success', message: 'Category created successfully.', data: @category }, status: :created
    else
      render json: { status: 'Error', message: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def get_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
