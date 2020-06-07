class AddDetailsToGames < ActiveRecord::Migration[5.2]
  def change
    change_column_null :games, :youtube_video_id, false
  end
end
