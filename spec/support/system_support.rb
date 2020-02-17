module SystemSupport
  # 一意の名称を作成するために実行時のtimestampを、
  # 数字でインスタンス変数に格納するsetterです。地味に便利。
  def timestamp!(timestamp = Time.now.to_i)
    @timestamp = timestamp
  end

  # getterです
  def timestamp
    @timestamp
  end

  # ブロックの結果がtrueになるまでループするメソッド。すげえ使う。
  def wait_until(wait_time = Capybara.default_max_wait_time)
    Timeout.timeout(wait_time) do
      loop until yield
    end
  end

  # 特定のcssが登場する、もしくは、なくなるまでループするメソッド
  def wait_for_css(selector, wait_time = Capybara.default_max_wait_time, non_display: false)
    Timeout.timeout(wait_time) do
      loop until send((non_display ? :has_no_css? : :has_css?), selector)
    end
    yield if block_given?
  end

  # 非同期通信が終わるまでループするメソッド
  def wait_for_ajax(wait_time = Capybara.default_max_wait_time)
    Timeout.timeout(wait_time) do
      loop until page.evaluate_script("jQuery.active").zero?
    end
    yield if block_given?
  end
end
