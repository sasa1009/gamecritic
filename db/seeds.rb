# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

def file_path(name)
  File.open("#{Rails.root}/db/images/#{name}")
end

require './db/seeds/user.rb'
require './db/seeds/game.rb'
require './db/seeds/review.rb'
# require './db/seeds/guest.rb'

# Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| load seed }
