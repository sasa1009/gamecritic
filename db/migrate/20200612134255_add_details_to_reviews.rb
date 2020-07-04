class AddDetailsToReviews < ActiveRecord::Migration[5.2]
  def change
    add_index :reviews, [:user_id, :game_id], unique: true
    change_column_null :reviews, :user_id, false
    change_column_null :reviews, :game_id, false
  end
end
