module GetCategory
  extend ActiveSupport::Concern
  def get_category
    if params[:category_id] || params[:id]
      @category = Category.find_by(id: params[:category_id] || params[:id])
      unless @category
        render json: { status: "Error", message: "Category not found" }, status: :not_found
      end
    end
  end
end
