class Api::ArticlesController < ApplicationController
  def index
    articles = Article.all
    if articles.any?
      render json: articles, each_serializer: ArticlesSerializer
    else
      render json: { error: 'No articles found' }, status: 422
    end
  end

  def show
    article = Article.find(params[:id])
    render json: article, serializer: ArticleShowSerializer
  end

  def create
    article = Article.create(article_params)
    if article.persisted?
      render json: { message: 'Your article was successfully created' }
    else
      render json: { error: 'Something went wrong' }, status: 422
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :lead, :content, :category)
  end
end
