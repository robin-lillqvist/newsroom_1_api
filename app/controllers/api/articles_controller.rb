class Api::ArticlesController < ApplicationController
  def index
    article = Article.all

    render json: { articles: article }
  end
end
