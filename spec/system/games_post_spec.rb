require 'rails_helper'

RSpec.describe 'GamesPost', type: :system, js: true do
  include ActiveJob::TestHelper

  let!(:user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:admin) }

  describe "access to the Game Post page" do
    context "with non admin user" do
      # アドミンユーザー以外がログインしている場合はゲーム投稿画面へのリンクが表示されない。
      it "can't access to the Game Post page" do
        sign_in_as(user)
        click_link("Menu")
        expect(page).to_not have_selector("#game_post")
      end
    end

    context "with non admin user" do
      # アドミンユーザーがログインしている場合はゲーム投稿画面へのリンクが表示される。
      it "can access to the Game Post page" do
        sign_in_as(admin)
        click_link("Menu")
        expect(page).to have_selector("#game_post")
      end
    end
  end

  describe "posting game data" do
    before do
      sign_in_as(admin)
      visit new_game_path
    end

    context "with invalid information" do
      # 不適切な情報を入力した場合ゲームデータが作成されない。
      it "does not create game data" do
        find("#title").set("")
        find("#developer").set("")
        find("#game_release_date_1i").set("")
        find("#game_release_date_2i").set("")
        find("#game_release_date_3i").set("")
        find("#summary").set("")
        click_button("投稿")
        expect(page).to have_selector(".alert-danger")
        expect(page).to have_selector("#title")
      end
    end

    context "with valid information" do
      # 適切な情報を入力した場合ゲームデータが作成される。
      # ジャケット画像とYouTube URLを入力するとゲーム詳細画面に追加される
      # ジャケット画像をアップロードした場合、game.jacket.attached?がtrueになる。
      it "creates game data and redirect to the game's information page" do
        find("#title").set("Persona 5 Royal")
        find("#developer").set("Atlus")
        find("#game_release_date_1i").set("2020")
        find("#game_release_date_2i").set("3")
        find("#game_release_date_3i").set("31")
        find("#summary").set("奪え、その意志で。ペルソナ5、新生(ザ・ロイヤル)―。全世界累計セールス270万本を突破し、数多くのゲームアワードを受賞したピカレスク・ジュブナイルRPG「ペルソナ5」が、多数の追加要素により生まれ変わって新登場。新たなキャラクターや未知なる3学期が加わり「ペルソナ5」では語られなかった深層が明らかに…! 
        また、新スポット・イベントの追加で充実の学生ライフはさらに濃密に。放課後の怪盗ライフでは新たな敵やギミック、謎のオタカラなど、攻略すべきパレスにも異変が…!? 心を盗む怪盗団の新たなる活躍をご覧あれ!
        
        怪盗たちが盗むのは悪い大人たちの腐った心　大都会を騒がせる謎に包まれた怪盗団
        今、「心の怪盗団」を名乗る者たちが、大都会・東京を騒がせている。怪盗たちが“盗む”のは、歪んだ欲望を抱く、悪い大人の“心”。彼らから予告状を送り付けられた人間は、ことごとく「自らの罪を告白し、改心してしまう」ようだ。生徒に暴言暴行を働く教師、詐欺まがいの悪徳金融、盗作上等の芸術家…怪盗団のターゲットは、そんな腐った大人たち。
        前代未聞の世直し劇が、いま始まる。")
        find("#file_field").set(Rails.root.join('spec', 'fixtures', 'files', 'ペルソナ５.jpg'), filename: 'ペルソナ５.jpg')
        find("#youtube_video_id").set("https://youtu.be/dFWXBQH9f5s")
        click_button("投稿")
        expect(page).to have_current_path game_path(Game.last)
        expect(page).to have_selector(".alert-info")
        expect(page).to have_selector(".youtube")
        within("div.game_info") do
          expect(page).to have_selector(".jacket")
          expect(Game.last.jacket.attached?).to eq true
          # ゲームの概要が長い場合、less_summaryクラスが適用されている
          expect(page).to have_selector(".less_summary")
          #「全てを表示」を押すと概要が全て表示されて「全てを表示」が「折りたたむ」に切り替わる
          expect(find("#expand")).to have_content("全てを表示")
          find("#expand").click
          expect(page).to have_selector(".summary_first_wrapper")
          expect(find("#expand")).to have_content("折りたたむ")
          # 「折りたたむ」を押すと概要が省略されて「全てを表示」に切り替わる
          find("#expand").click
          expect(page).to have_selector(".less_summary")
          expect(find("#expand")).to have_content("全てを表示")
        end
      end
    end
  end
end
