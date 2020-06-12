class AddDetailsToReviews < ActiveRecord::Migration[5.2]
  def change
    add_index :reviews, [:user_id, :game_id], unique: true
  end
end
