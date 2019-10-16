# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # セッションデータにidがあれば(セッション状態であれば)trueを返す
  private def current_member
    Member.find_by(id: session[:member_id]) if session[:member_id]
  end

  helper_method :man_or_woman
  helper_method :current_member # ヘルパーメゾットとして登録(テンプレートで使える)
  # StanddardErrorは一般的な例外を示す
  class LoginRequired < StandardError; end
  class Forbidden < StandardError; end

  private def login_required
    raise LoginRequired unless current_member # ログイン状態でなければ例外LoginRequiredを発生させる
  end
end
