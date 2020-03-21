class Article < ApplicationRecord
  validates_presence_of :title, :lead, :content, :category
  enum category: [:latest_news, :tech, :food, :sports, :culture]
end
