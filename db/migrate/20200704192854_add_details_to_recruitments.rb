class AddDetailsToRecruitments < ActiveRecord::Migration[5.2]
  def change
    change_column_null :recruitments, :description, false
    add_reference :recruitments, :user, foreign_key: true, null: false
    add_reference :recruitments, :game, foreign_key: true, null: false
    add_index :recruitments, [:user_id, :game_id], unique: true
  end
end
