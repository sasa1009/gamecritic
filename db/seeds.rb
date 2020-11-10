# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

def file_path(name)
  File.open("#{Rails.root}/db/images/#{name}.jpg")
end

User.create!(name:  "Akinori Sasakura",
             email: "conventional1009@gmail.com",
             password:              "password",
             password_confirmation: "password",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

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

atsumori = Game.new(user_id: User.first.id,
                    title: "あつまれ　どうぶつの森",
                    developer: "任天堂",
                    release_date: "2020-03-20 00:00:00",
                    summary: "無人島移住ではじまる自由気ままな楽園生活<br>現実と同じ時間が流れる世界で、自由気ままに暮らし、ときには四季折々のイベントやどうぶつたちとの交流を楽しむ「どうぶつの森」シリーズ最新作がNintendo Switchに登場。",
                    youtube_video_id: "https://youtu.be/UcB9KrrD26M" )
atsumori.jacket.attach(io: file_path('atsumori'), 
                           filename: 'atsumori.jpg', 
                           content_type: 'image/jpeg')
atsumori.save

ff7 = Game.new(user_id: User.first.id,
                    title: "ファイナルファンタジーⅦ リメイク",
                    developer: "スクウェア・エニックス",
                    release_date: "2020-04-10 00:00:00",
                    summary: "1997年にPlayStationで発売された『FINAL FANTASY VII』の主要スタッフが手掛ける『FINAL FANTASY VII REMAKE』。<br>

                    壮大な物語や魅力的なキャラクター、当時の最先端技術が駆使された映像で多くの人を魅了した不朽の名作が、時を経て「新たな物語」として生まれ変わります。",
                    youtube_video_id: "https://youtu.be/FbYxZMGdXUc" )
ff7.jacket.attach(io: file_path('FF7REMAKE'),
                      filename: 'FF7REMAKE.jpg',
                      content_type: 'image/jpeg')
ff7.save

persona5 = Game.new(user_id: User.first.id,
                    title: "ペルソナ5 ザ・ロイヤル",
                    developer: "アトラス",
                    release_date: "2019-10-31 00:00:00",
                    summary: "全世界累計セールス270万本を突破したピカレスク・ジュブナイルRPG「ペルソナ５」が、多数の追加要素により生まれ変わって登場。<br>

                    新たなキャラクターや“未知なる３学期”が加わり「ペルソナ５」では語られなかった“深層”が明らかに。",
                    youtube_video_id: "https://youtu.be/o9QjlLdYK5I" )
persona5.jacket.attach(io: file_path('p5r'),
                           filename: 'p5r.jpg',
                           content_type: 'image/jpeg')
persona5.save

biohazard3 = Game.new(user_id: User.first.id,
                    title: "BIOHAZARD RE:3 Z Version",
                    developer: "カプコン",
                    release_date: "2020-04-03 00:00:00",
                    summary: "『バイオハザード RE:3』再誕!<br>

                    2作を収めた贅沢な1本、『バイオハザード RE:3』を遊び尽くせ!
                    極限からの生還を目指すサバイバルホラー『バイオハザード3 ラスト エスケープ』のフルリメイク作品と、オンラインでの新たなバイオハザードともいうべき、非対称対戦サバイバルホラー『バイオハザード レジスタンス』とをあわせたコンピレーションタイトル。",
                    youtube_video_id: "https://youtu.be/w5-GWjLOghg" )
biohazard3.jacket.attach(io: file_path('bio-hazard3'),
                             filename: 'bio-hazard3.jpg',
                             content_type: 'image/jpeg')
biohazard3.save

assasin_origin = Game.new(user_id: User.first.id,
                    title: "アサシン クリード オリジンズ デラックスエディション",
                    developer: "UBIsoft",
                    release_date: "2019-07-11 00:00:00",
                    summary: "ストーリー<br>首都アレクサンドリアから遠く、広大な砂漠の中に孤立するように存在するシワオアシス。そこで暮らしているバエクは、古代エジプトの社会と伝統を脈々と守ってきた最後のメジャイである。
                    息子を殺されるという大いなる悲劇に見舞われたバエクは、やはりメジャイである妻のアヤと共に、事件の真相と敵を求めて旅に出ることとなる。そしてついに、敵はエジプト全土の抑圧と支配を目指す秘密結社の一員であることを突き止める。",
                    youtube_video_id: "https://youtu.be/fBTFF9GNOV0" )
assasin_origin.jacket.attach(io: file_path('assassin-creed-origins'),
                                 filename: 'assassin-creed-origins.jpg',
                                 content_type: 'image/jpeg')
assasin_origin.save

witcher_3 = Game.new(user_id: User.first.id,
                    title: "ウィッチャー3 ワイルドハント ゲームオブザイヤーエディション",
                    developer: "CD PROJEKT RED",
                    release_date: "2016-09-01 00:00:00",
                    summary: "2015年5月の発売以降、全世界で800以上のメディアアワード&ノミネーションを獲得し、名実共に2015年最高のRPGとなった。この傑作RPGが、これまでに配信された全てのコンテンツを同梱した「ゲームオブザイヤーエディション」として再び登場! !",
                    youtube_video_id: "https://youtu.be/i_5CFNACAds" )
witcher_3.jacket.attach(io: file_path('witcher3'),
                            filename: 'witcher3.jpg',
                            content_type: 'image/jpeg')
witcher_3.save

fallout4 = Game.new(user_id: User.first.id,
                    title: "Fallout 4 Game of the Year Edition",
                    developer: "Bethesda Softwork",
                    release_date: "2017-09-26 00:00:00",
                    summary: "『Fallout 4: Game of the Year Edition』には、ゲーム本編および『Far Harbor』や『Nuka-World』など6つ全ての追加コンテンツのダウンロードコードが封入されています。『Fallout 4』は、Bethesda Game Studiosが手掛けた核戦争後の世界を舞台にしたゲーム。日本で「日本ゲーム大賞2015・フューチャー部門」や「PlayStationR Awards 2016ユーザーズチョイス賞」を獲得しているほか、世界では200以上もの「最優秀賞」に輝いています。<br>
                    あなたは「Vault 111」唯一の生存者として、核戦争で荒廃した世界で生き抜き、ウェイストランドの命運を担うことになります。",
                    youtube_video_id: "https://youtu.be/BhXDeEBk53I" )
fallout4.jacket.attach(io: file_path('fallout4'),
                           filename: 'fallout4.jpg',
                           content_type: 'image/jpeg')
fallout4.save

mario_cart = Game.new(user_id: User.first.id,
                    title: "マリオカート8 デラックス",
                    developer: "任天堂",
                    release_date: "2017-04-28 00:00:00",
                    summary: "あらゆる場所がサーキット。レース、バトル、すべてがデラックス。今までにないキャラクター、コース、マシンが加わり、『マリオカート8』がデラックスに。<br>
                    Wii U『マリオカート8』の追加コンテンツを全て収録し、本作独自の新しいキャラクターやコース、マシンなどの新要素がプラスされ、シリーズ最大ボリュームのマリオカートとして新たに登場。",
                    youtube_video_id: "https://youtu.be/HljJvwifETg" )
mario_cart.jacket.attach(io: file_path('mariokart8'), 
                             filename: 'mariokart8.jpg', 
                             content_type: 'image/jpeg')
mario_cart.save

kingdom_hearts = Game.new(user_id: User.first.id,
                    title: "キングダム ハーツIII",
                    developer: "スクウェア・エニックス",
                    release_date: "2019-01-25 00:00:00",
                    summary: "<ストーリー><br>
                    ある日キーブレードという鍵型の剣を手にした少年ソラは、離ればなれになってしまった親友のリクとカイリを取り戻すため、王様(ミッキー)の命を受けたドナルドとグーフィーと共に旅に出た。世界を救う為には光と闇の両方の世界から鍵をかける必要があり、親友のリクは闇の世界に残る選択をした。<br>
                    世界で暗躍するXIII機関という組織は、世界の心、人の心の集合体ともいわれているキングダムハーツの完成の為に必要なキーブレードを持つソラの前に何度となく立ちはだかり、様々な戦いを引き起こしてきた。<br>
                    これまでのキングダムハーツをめぐる戦いが、 キーブレード戦争を引き起こそうと目論むマスター・ゼアノートの意のままに進んでいたことを知ったソラ達は、闇に対抗する、7人の光の守護者を揃えようとしていた。<br>
                    王様とリクは歴戦のキーブレード使いの居場所を探し始め、ソラ、ドナルド、グーフィーの3人は「目覚めの力」を取り戻すため、 再び様々なディズニーのワールドを駆け巡って行くのだった。",
                    youtube_video_id: "https://youtu.be/4Bj3RAUOd-A" )
kingdom_hearts.jacket.attach(io: file_path('kingdom-hearts'), 
                                 filename: 'kingdom-hearts.jpg', 
                                 content_type: 'image/jpeg')
kingdom_hearts.save

sekiro = Game.new(user_id: User.first.id,
                    title: "SEKIRO: SHADOWS DIE TWICE",
                    developer: "フロムソフトウェア",
                    release_date: "2019-03-22 00:00:00",
                    summary: "史上最も血なまぐさい時代・戦国。連れ攫われた皇子を奪還し、自らの左腕を斬り落とした侍に復讐を果たすため、孤独な忍びの戦いが始まる。 
                    『DARK SOULS』シリーズ、『Bloodborne』などで知られるフロム・ソフトウェアの最新作である本作は、戦国末期の日本を舞台とした、RPG要素を備えたアクションアドベンチャーゲームです。 ",
                    youtube_video_id: "https://youtu.be/rXMX4YJ7Lks" )
sekiro.jacket.attach(io: file_path('SEKIRO'), 
                         filename: 'SEKIRO.jpg', 
                         content_type: 'image/jpeg')
sekiro.save

lastofus2 = Game.new(user_id: User.first.id,
                    title: "The Last of Us Part II",
                    developer: "ソニー・インタラクティブエンタテインメント",
                    release_date: "2020-06-19 00:00:00",
                    summary: "謎の感染爆発によって変わり果てたアメリカを横断した危険な旅路から5年、エリーとジョエルはワイオミング州ジャクソンで暮らしていた。生き残った者たち(生存者たち)によるコミュニティーは順調に発展し、二人は安らぎと落ち着きを取り戻したかのように見えた。もちろん、さまざまな危険は存在する。感染者とそれ以外――惨めな境遇にいる他の生存者たちだ。そして、あるすさまじい出来事が平和を崩壊させたとき、エリーの無慈悲な旅が再び始まる。",
                    youtube_video_id: "https://youtu.be/OkT-oRad_fs" )
lastofus2.jacket.attach(io: file_path('lastofus2'), 
                         filename: 'lastofus2.jpg', 
                         content_type: 'image/jpeg')
lastofus2.save

ghostoftsushima = Game.new(user_id: User.first.id,
                    title: "Ghost of Tsushima",
                    developer: "ソニー・インタラクティブエンタテインメント",
                    release_date: "2020-07-17 00:00:00",
                    summary: "Ghost of Tsushima ( ゴーストオブツシマ )は、武士の道から外れた境井 仁(さかい じん)が、冥府から蘇った「冥人(くろうど)」となり、対馬を敵の手から解き放つ。 期待のオープンワールド時代劇アクションアドベンチャー
                    民のために戦え 名誉を捨てて――対馬を奪い返すためには、身分や立場を問わず、さまざまな島民の力を借りなくてはならない。 たとえ武士の道から外れようと、元軍を倒すために新たな兵術を作り出し、故郷を守り抜け。",
                    youtube_video_id: "https://youtu.be/QO6fChKB20Y" )
ghostoftsushima.jacket.attach(io: file_path('ghostoftsushima'), 
                         filename: 'ghostoftsushima.jpg', 
                         content_type: 'image/jpeg')
ghostoftsushima.save

watchdogslegion = Game.new(user_id: User.first.id,
                    title: "ウォッチドッグス レギオン",
                    developer: "UBIsoft",
                    release_date: "2020-10-29 00:00:00",
                    summary: "バーチャル上で出会う人々を自由に仲間に加えてレジスタンスを組織し、ハッキング、潜入、戦闘を繰り広げて崩壊の危機に直面する近未来のロンドンを取り戻そう。今こそ、レジスタンスのもとに集え。
                    街で出会う誰でも仲間に加え、その人物としてプレイできるほか、それぞれにバックストーリー、個性、スキルが設定されている。
                    武装ドローンをハックし、スパイダーボットを展開させ、ARクロークで身を隠しながら敵を排除しよう。
                    広大な都市を再現したオープンワールドを探索し、ロンドンに点在するランドマークの数々や楽しいサイドアクティビティを楽しもう。
                    新たなメンバーをオンラインに誘い、フレンドと協力してミッションをこなし、高難度のエンドゲームコンテンツに挑もう。",
                    youtube_video_id: "https://youtu.be/u2_SfHrMFzY" )
watchdogslegion.jacket.attach(io: file_path('watchdogslegion'), 
                         filename: 'watchdogslegion.jpg', 
                         content_type: 'image/jpeg')
watchdogslegion.save

apex = Game.new(user_id: User.first.id,
                    title: "エーペックスレジェンズ",
                    developer: "Electronic Arts",
                    release_date: "2019-02-05 00:00:00",
                    summary: "熾烈な侵略戦が展開する「エーペックスレジェンズ」は、強力なアビリティを操る伝説の戦士が結集してフロンティアの辺境で富と名声を懸けて戦う、基本プレイ無料*のバトルロイヤルシューティング。 次々と登場する個性豊かなレジェンドを操り、戦術性が高く奥深い部隊プレイを究めよう。バトルロイヤルゲームが野心的な進化を遂げるのは、何が起きても不思議ではない荒涼とした世界だ。 君はここで、新世代のバトルロイヤルを体感する。",
                    youtube_video_id: "https://youtu.be/_ZpLbriJXvM" )
apex.jacket.attach(io: file_path('apexlegends'), 
                         filename: 'apexlegends.jpg', 
                         content_type: 'image/jpeg')
apex.save

#  = Game.new(user_id: User.first.id,
#                     title: "",
#                     developer: "",
#                     release_date: "2019-03-22 00:00:00",
#                     summary: "",
#                     youtube_video_id: "" )
# .jacket.attach(io: file_path(''), 
#                          filename: '.jpg', 
#                          content_type: 'image/jpeg')
# .save

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


