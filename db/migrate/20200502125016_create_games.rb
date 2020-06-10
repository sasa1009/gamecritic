class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :user_id
      t.string :title
      t.string :developer
      t.datetime :release_date
      t.text :summary

      t.timestamps
    end
  end
end
