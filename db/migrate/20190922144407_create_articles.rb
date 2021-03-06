# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title, null: false # タイトル
      t.text :body, null: false # 本文
      t.datetime :released_at, null: false # 掲載開始日
      t.datetime :expired_at # 掲載終了日
      t.boolean :member_only, null: false, default: false # 会員のみフラグ
      t.timestamps
    end
  end
end

