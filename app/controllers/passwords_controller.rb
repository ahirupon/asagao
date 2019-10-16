# frozen_string_literal: true

class PasswordsController < ApplicationController
  before_action :login_required

  def show
    redirect_to :account
  end

  def edit
    @member = current_member
  end

  def update
    @member = current_member
    current_password = params[:account][:current_password] # current_passwordをパラメータから取得

    if current_password.present? # current_passwordは存在するか？
      if @member.authenticate(current_password) # current_passwordは有効かつまり、passwordとpassword_confirmationが一致しているか？
        @member.assign_attributes(params[:account]) # @memberの情報を更新する
        if @member.save # @memberを保存できるか？
          redirect_to :account, notice: 'password changed'
        else
          render 'edit'
        end
      else
        @member.errors.add(:current_password, :wrong) # current_passwordが有効でなければバリデーションエラーを起こす
        render 'edit'
      end
    else
      @member.errors.add(:current_password, :empty) # current_passwordが存在していなっかたらバリデーションエラーを起こす
      render 'edit'
    end
  end
end
