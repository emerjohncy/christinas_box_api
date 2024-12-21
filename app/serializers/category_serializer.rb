class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :created_at, :updated_at
end
