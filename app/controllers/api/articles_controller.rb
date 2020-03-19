class Api::ArticlesController < ApplicationController
  def index
    @articles = Article.all
    render json: @articles, each_serializer: ArticlesSerializer
  end
end
