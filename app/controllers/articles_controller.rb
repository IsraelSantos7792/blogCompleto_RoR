# controller articles index and more
class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @highlights = Article.desc_order.first(3)
    current_page = (params[:page] || 1).to_i
    highlights_ids = @highlights.pluck(:id).join(',')
    @articles = Article.desc_order
                       .without_highlights(highlights_ids)
                       .page(current_page)
  end

  def show; end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article, notice: "Artigo foi criado com sucesso."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Artigo foi atualizado com sucesso."
    else
      render :edit
    end
  end

  def destroy
    @article.destroy

    redirect_to root_path , notice: "Artigo foi deletado com sucesso."
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :category_id)
  end

  def set_article
    @article = Article.find(params[:id])
  end
end
