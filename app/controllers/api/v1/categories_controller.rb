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

  private

  def get_category
    @category = Category.find(params[:id])
  end
end
