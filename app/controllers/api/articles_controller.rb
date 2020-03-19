class Api::ArticlesController < ApplicationController
  def index
    @articles = Article.all
    if @articles.any?
      render json: @articles, each_serializer: ArticlesSerializer
    else
      render json: { error: "No articles found" }, status: 422
    end
  end
end
