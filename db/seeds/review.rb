for i in 1..14 do
    game = Game.find(i)
    case i
    when 1..4 then
        for x in 1..100 do
            user = User.find(x)
            game.reviews.create(user_id: user.id,
                                score: rand(5..7),
                                review: Faker::Movies::HarryPotter.quote )
        end
    when 5..9 then
        for x in 1..100 do
            user = User.find(x)
            game.reviews.create(user_id: user.id,
                                score: rand(2..5),
                                review: Faker::Movies::HarryPotter.quote )
        end
    when 10..14 then
        for x in 1..100 do
            user = User.find(x)
            game.reviews.create(user_id: user.id,
                                score: rand(6..10),
                                review: Faker::Movies::HarryPotter.quote )
        end
    end
end

guest = User.find_by(email: "guest-user@example.com")
game = Game.find_by(title: "あつまれ　どうぶつの森")
review = game.reviews.new(user_id: guest.id,
                      score: 8,
                      review: "おいでよ どうぶつの森からプレイしています。
                      風に揺れる木の葉や美しい水のきらめき。
                      島が広いから水辺も多く、川辺や砂浜をお散歩するのがとても楽しい。
                      魚影が見えたらたまに釣ってみたり。メッセージボトルを拾ったり。
                      両手で手を振ってくれる可愛い仕草を見るためにどうぶつに会いに行く。
                      メッセージカードを書いてプレゼントを送ってまた海でぼーっとする。
                      そんなのんびりプレイが心地良く、とても癒されています。" )
review.images.attach(io: file_path('atsumori1.jpg'), 
                      filename: 'atsumori1.jpg', 
                      content_type: 'image/jpeg')
review.images.attach(io: file_path('atsumori2.jpg'), 
                      filename: 'atsumori2.jpg', 
                      content_type: 'image/jpeg')
review.save
