class ArticlesSerializer < ActiveModel::Serializer
  attributes :id, :title, :lead, :category
end
