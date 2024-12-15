class Api::V1::CategoriesController < ApplicationController
    # GET /categories
  def index
    @categories = Category.all

    render json: @categories
  end

end
