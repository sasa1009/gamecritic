User.create!(name:  "Akinori Sasakura",
            email: "conventional1009@gmail.com",
            password:              "password",
            password_confirmation: "password",
            admin: true,
            activated: true,
            activated_at: Time.zone.now)
  
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
guest.save

99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@railstutorial.org"
password = "password"
User.create!(name:  name,
                email: email,
                password:              password,
                password_confirmation: password,
                activated: true,
                activated_at: Time.zone.now)
end
