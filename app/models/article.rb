# frozen_string_literal: true

class Article < ApplicationRecord
  validates :title, :body, :released_at, presence: true
  validates :title, length: { maximum: 80 }
  validates :body, length: { maximum: 2000 }

  def no_expiration
    expired_at.nil?
  end

  def no_expiration=(val)
    @no_expiration = val.in?([true, '1']) # 引数がtrue(consoleからtrueと入力する場合を考慮)か文字列の1の場合@no_expirationにtrueを代入する
  end

  before_validation do # <=クラスメゾットとしてある
    self.expired_at = nil if @no_expiration # @no_expiraionがtrueであれば属性(データベースの)expired_atにnilを代入する
  end
  validate do
    if expired_at && expired_at < released_at # もしexpired_at属性がtrueで“かつ”それがreleased_at属性よりも前だったら(時間なので)
      errors.add(:expired_at, :expired_at_too_old) # :expired_at_too_oldというerrorを発生させる
    end
  end

  # スコープはレコードの検索の仕方に名前を付けたもの

  scope :open_to_the_public, -> { where(member_only: false) } # member_onlyがfalseの検索方法をopen_to_the_publicに代入
  scope :visible, lambda {
    now = Time.current # 現在時刻を呼び出す
    where('released_at <= ?', now).where('expired_at > ? OR expired_at IS NULL', now) # ? に第二引数を代入、これはnowに比べreleased_at以降、expired_at未満またはnullの場合の検索方法を代入
  }
end
