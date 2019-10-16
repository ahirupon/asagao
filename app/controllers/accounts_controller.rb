# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :login_required

  def show
    @member = current_member
  end

  def edit
    @member = current_member
  end

  def update
    @member = current_member
    @member.assign_attributes(params[:account]) # assign_attributesで送られてきたパラメータ値を上書き
    if @member.save
      redirect_to :account, notice: 'Account information updated'
    else
      render 'edit'
    end
  end
end
