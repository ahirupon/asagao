# frozen_string_literal: true

class SessionsController < ApplicationController
  # セッション状態をつくる
  def create
    member = Member.find_by(name: params[:name])
    if member&.authenticate(params[:password]) # memberのパスワードの一致がtrueか？memberにnilが入っているとエラーになるためボッチ演算子をつかう
      session[:member_id] = member.id # セッション状態の変数にmemberのidを代入しセッション状態に
    else
      flash.alert = 'Name and Password do not mach.'
    end
    redirect_to :root
  end

  # セッション状態を消す
  def destroy
    session.delete(:member_id) # セッション状態の変数の中身を消す
    redirect_to :root
  end
end
