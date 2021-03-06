# controller articles index and more
class ArticlesController < ApplicationController
  include Paginable
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_article, only: %i[ edit update destroy ]
  before_action :set_categories, only: %i[new create edit update]

  def index
    @categories = Category.sorted
    category = @categories.select { |c| c.name == params[:category]}[0] if params[:category].present?

    @highlights = Article.includes(:category, :user)
                         .filter_by_category(category)
                         .filter_by_archive(params[:month_year])
                         .desc_order
                         .first(3)

    highlights_ids = @highlights.pluck(:id).join(',')

    @articles = Article.includes(:category, :user)
                       .desc_order
                       .without_highlights(highlights_ids)
                       .filter_by_category(category)
                       .filter_by_archive(params[:month_year])
                       .page(current_page)

    @archives = Article.group_by_month(:created_at, format: '%B %Y').count
  end

  def show
    @article = Article.includes(comments: :user).find(params[:id])
    authorize @article
  end

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

  def set_categories
    @categories = Category.sorted
  end

  def article_params
    params.require(:article).permit(:title, :body, :category_id)
  end

  def set_article
    @article = Article.find(params[:id])
    authorize @article
  end
end
