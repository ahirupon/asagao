# frozen_string_literal: true

class Member < ApplicationRecord
  # 空のレコードはダメ
  # 長さは72文字以下
  # 確認用と一致しなければならない
  has_secure_password

  has_many :entries, dependent: :destroy

  validates :number, presence: true,
                     numericality: {
                       only_integer: true,
                       greater_than: 0,
                       less_than: 100,
                       allow_blank: true
                     },
                     uniqueness: true
  validates :name, presence: true,
                   format: {
                     with: /\A[A-Za-z][A-Za-z0-9]*\z/,
                     allow_blank: true,
                     message: :invalid_member_name
                   },
                   length: { minimum: 2, maximum: 20, allow_blank: true },
                   uniqueness: { case_sensitive: false }
  validates :full_name, presence: true, length: { maximum: 20 }
  validates :email, email: { allow_blank: true }

  attr_accessor :current_password # パスワード変更フォームに現在のパスワードを入力する欄を設け現在のパスワードに対するバリデーションを行うために利用する
  validates :password, presence: { if: :current_password } # presenceは空文字を禁止するバリデーションだがオブジェクトが新規作成される時しか働かないので、
  # current_passwordに値がセットされている場合は常に働くようにする

  class << self
    def search(query)
      rel = order('number')
      if query.present?
        rel = rel.where('name LIKE ? OR full_name LIKE ?',
                        "%#{query}%", "%#{query}%")
      end
      rel
    end
  end
end
