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
    if article.persisted? && attach_image(article)      
      render json: { message: 'Your article was successfully created' }
    else
      render json: { error: 'Something went wrong' }, status: 422
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :lead, :content, :category)
  end

  def attach_image(article)
    params_image = params['article']['image']

    if params_image.present? 
      DecodeService.attach_image(params_image, article.image)
    end
  end
end
