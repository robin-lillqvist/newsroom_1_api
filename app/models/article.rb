class Article < ApplicationRecord
  has_one_attached :image
  validates_presence_of :title, :lead, :content, :category, :premium
  enum category: [:latest_news, :tech, :food, :sports, :culture]
end
