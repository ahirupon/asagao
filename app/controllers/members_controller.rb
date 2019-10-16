# frozen_string_literal: true

class MembersController < ApplicationController
  before_action :login_required # ログイン前のユーザーが/membersにアクセスできないようにする(application_controller.rb)

  def index
    @members = Member.order('number').page(params[:page]).per(15) # データベースからnumber順に取得
  end

  def search # 会員の検索機能
    @members = Member.search(params[:q]).page(params[:page]).per(15) # qには検索ワードが入る、searchメゾットはapp/model/members.rbに
    render 'index' # index.html.erbを表示
  end

  def show # 会員の詳細情報
    @member = Member.find(params[:id])
  end

  def new # 会員の新規登録フォームのページへ
    @member = Member.new(birthday: Date.new(1980, 1, 1))
  end

  def create # 会員の新規登録
    @member = Member.new(params[:member])
    if @member.save
      redirect_to @member, notice: 'Member registered'
    else
      render 'new'
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    @member.assign_attributes(params[:member]) # assign_attrbutesメゾットでフォームからのデータをセットする
    if @member.save
      redirect_to @member, notice: 'Member updated'
    else
      render 'edit'
    end
  end

  def destroy # 会員情報の削除
    @member = Member.find(params[:id])
    @member.destroy
    redirect_to :members, notice: 'Destroy member'
  end
end
