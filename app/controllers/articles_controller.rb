# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :login_required, except: %i[index show]
  def index
    @articles = Article.order(released_at: :desc) # released_at 順にorder
    @articles = @articles.open_to_the_public unless current_member # ログイン状態でない場合、一般公開の記事のみを用いる

    unless current_member&.administrator? # ログイン状態でなくかつ管理者フラグもたっていない場合
      @articles = @articles.visible # 公開期限内の記事のみを用いる
    end

    @articles = @articles.page(params[:page]).per(5)
  end

  # 記事詳細
  def show
    # 記事詳細もソートする
    articles = Article.all
    articles = articles.open_to_the_public unless current_member
    articles = ariticles.visible unless current_member&.administrator?

    @article = articles.find(params[:id])
  end

  # 新規登録フォーム
  def new
    @article = Article.new
  end

  # 編集フォーム
  def edit
    @article = Article.find(params[:id])
  end

  # 新規作成
  def create
    @article = Article.new(params[:article])
    if @article.save
      redirect_to @article, notice: 'News has been registered'
    else
      render 'new'
    end
  end

  # 更新機能
  def update
    @article = Article.find(params[:id])
    @article.assign_attributes(params[:article])

    if @article.save
      redirect_to @article, notice: 'News has been updated'
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to :articles
  end
end
