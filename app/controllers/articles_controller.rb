# controller articles index and more
class ArticlesController < ApplicationController
  include Paginable
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_article, only: %i[show edit update destroy]

  def index
    category = Category.find_by_name(params[:category]) if params[:category].present?

    @highlights = Article.filter_by_category(category)
                         .desc_order
                         .first(3)

    highlights_ids = @highlights.pluck(:id).join(',')

    @articles = Article.desc_order
                       .without_highlights(highlights_ids)
                       .filter_by_category(category)
                       .page(current_page)

    @categories = Category.sorted
  end

  def show; end

  def new
    @article = current_user.articles.new
  end

  def create
    @article = current_user.articles.new(article_params)

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
    authorize @article
  end
end
