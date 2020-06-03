class RenameYoutubeUrlColumnToYoutubeVideoId < ActiveRecord::Migration[5.2]
  def change
    rename_column :games, :youtube_url, :youtube_video_id
  end
end
