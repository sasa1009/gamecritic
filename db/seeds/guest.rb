guest = User.new(name:  "ゲストユーザー",
                email: "guest-user@example.com",
                password:              "password",
                password_confirmation: "password",
                admin: false,
                activated: true,
                activated_at: Time.zone.now,
                self_introduction: "最近はあつまれ動物の森で遊んでます！
                フレンド募集中です。一緒に遊びましょう！")
guest.profile_image.attach(io: file_path('tanukichi.jpeg'), 
               filename: 'tanukichi.jpeg', 
               content_type: 'image/jpeg')
guest.save!

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
review.images.attach(io: file_path('atsumori1.jpeg'), 
                      filename: 'atsumori1.jpeg', 
                      content_type: 'image/jpeg')
review.images.attach(io: file_path('atsumori2.jpeg'), 
                      filename: 'atsumori2.jpeg', 
                      content_type: 'image/jpeg')
review.save!
