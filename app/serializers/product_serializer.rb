class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :created_at, :updated_at
  belongs_to :category, serializer: SimplifiedCategorySerializer

  def price
    "%.2f" % object.price.to_f
  end
end
