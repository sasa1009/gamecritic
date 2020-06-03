FactoryBot.define do
  factory :game do
    user_id { }
    sequence(:title) { |n| "Game #{n}" }
    developer { "capcom" }
    release_date { "2020-05-02 12:50:16" }
    summary { "MyText" }
    youtube_video_id { "https://youtu.be/EyCZP1wDxEM" }
  end

  factory :sekiro, class: Game do
    user_id { }
    title { "SEKIRO" }
    developer { "フロムソフトウェア" }
    release_date { "2019-03-22 00:00:00" }
    summary { "隻腕の狼、戦国に忍ぶ。
               史上最も血なまぐさい時代・戦国。連れ攫われた皇子を奪還し、自らの左腕を斬り落とした侍に復讐を果たすため、孤独な忍びの戦いが始まる。" }
    youtube_video_id { "https://youtu.be/rXMX4YJ7Lks" }
  end
end
