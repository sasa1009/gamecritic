class Game < ApplicationRecord
  belongs_to :user
  validates :title,  presence: true
  validates :developer,  presence: true
  validates :release_date,  presence: true
end
