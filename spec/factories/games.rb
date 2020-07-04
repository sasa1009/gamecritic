FactoryBot.define do
  factory :game do
    user_id {}
    sequence(:title) { |n| "Game #{n}" }
    developer { "capcom" }
    release_date { "2020-05-02 12:50:16" }
    summary { "hogehoge" }
    youtube_video_id { "https://youtu.be/EyCZP1wDxEM" }
    after(:build) do |sekiro|
      sekiro.jacket.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'SEKIRO.jpg')), filename: 'SEKIRO.jpg', content_type: 'image/jpeg')
    end
  end

  factory :kingdom_hearts, class: Game do
    user_id {}
    title { "キングダム ハーツIII" }
    developer { "スクウェア・エニックス" }
    release_date { "2020-08-01 00:00:00" }
    summary { "<ストーリー>
      ある日キーブレードという鍵型の剣を手にした少年ソラは、離ればなれになってしまった親友のリクとカイリを取り戻すため、王様(ミッキー)の命を受けたドナルドとグーフィーと共に旅に出た。世界を救う為には光と闇の両方の世界から鍵をかける必要があり、親友のリクは闇の世界に残る選択をした。<br>
      世界で暗躍するXIII機関という組織は、世界の心、人の心の集合体ともいわれているキングダムハーツの完成の為に必要なキーブレードを持つソラの前に何度となく立ちはだかり、様々な戦いを引き起こしてきた。<br>
      これまでのキングダムハーツをめぐる戦いが、 キーブレード戦争を引き起こそうと目論むマスター・ゼアノートの意のままに進んでいたことを知ったソラ達は、闇に対抗する、7人の光の守護者を揃えようとしていた。<br>
      王様とリクは歴戦のキーブレード使いの居場所を探し始め、ソラ、ドナルド、グーフィーの3人は「目覚めの力」を取り戻すため、 再び様々なディズニーのワールドを駆け巡って行くのだった。" }
    youtube_video_id { "https://youtu.be/4Bj3RAUOd-A" }
    after(:build) do |kingdom_hearts|
      kingdom_hearts.jacket.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'キングダムハーツ.jpg')), filename: 'キングダムハーツ.jpg', content_type: 'image/jpeg')
    end
  end

  factory :sekiro, class: Game do
    user_id { }
    title { "SEKIRO" }
    developer { "フロムソフトウェア" }
    release_date { "2019-03-22 00:00:00" }
    summary { "隻腕の狼、戦国に忍ぶ。
               史上最も血なまぐさい時代・戦国。連れ攫われた皇子を奪還し、自らの左腕を斬り落とした侍に復讐を果たすため、孤独な忍びの戦いが始まる。" }
    youtube_video_id { "https://youtu.be/rXMX4YJ7Lks" }
    after(:build) do |sekiro|
      sekiro.jacket.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'SEKIRO.jpg')), filename: 'SEKIRO.jpg', content_type: 'image/jpeg')
    end
  end
end
