# frozen_string_literal: true

class EntriesController < ApplicationController
  # ネストされたリソース(会員ごとの記事一覧)と通常のリソース(全記事一覧)をあつかう

  before_action :login_required, except: %i[index show]

  # 記事一覧
  def index
    if params[:member_id] # ネストされたリソースを扱うかどうかをこれの有無で調べる
      @member = Member.find(params[:member_id]) # あれば会員を@memberにとりだして
      @entries = @member.entries # @memberの記事を@entriesに代入する
    else
      @entries = Entry.all # すべての記事を取り出す
    end

    @entries = @entries.readable_for(current_member).order(posted_at: :desc).page(params[:page]).per(3) # スコープreadable_forを利用し、kaminariのページネーション機能も使う
  end

  # 記事詳細
  def show
    @entry = Entry.readable_for(current_member).find(params[:id]) # readable_forスコープとfindメゾットを組み合わせるfind(params[:id])に閲覧できない記事が指定されあた時は例外が発生する
  end

  def new; end

  def edit; end
end
