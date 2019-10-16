# frozen_string_literal: true

class TopController < ApplicationController
  def index
    @articles = Article.visible.order(released_at: :desc).limit(5)
    @articles = @articles.open_to_the_public unless current_member # ログイン状態でない場合一般公開の記事のみを用いる
  end
end
