class AddDataToArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :title, :string
    add_column :articles, :lead, :string
    add_column :articles, :content, :text
  end
end
