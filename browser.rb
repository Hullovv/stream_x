require 'puppeteer'

class Browser
  attr_reader :link

  def initialize
    @link = nil
    @options = []
    @skip_options = []
    @envs = {}

    set_default_options
  end

  def launch
    @link = Puppeteer.launch(
      headless: false,
      args: @options,
      ignore_default_args: @skip_options,
      env: @envs
    )
    page = new_page

    page.viewport = Puppeteer::Viewport.new(width: 1920, height: 1080)
    page.goto 'https://rutube.ru/video/2c7230d6ac4767e7cc0b7aeea0907143/'
  end

  def option(name, value=true)
    case value
    when String then @options.append("--#{name}=#{value}")
    when TrueClass then @options.append("--#{name}")
    when FalseClass then @skip_options.append("--#{name}")
    end
  end
  
  def env(name, value)
    @envs[name] = value
  end

  def pages
    return [] unless @link
    @link.pages
  end

  def new_page
    return nil unless @link
    @link.new_page
  end

  def process
    return nil unless @link
    @link.process
  end

  def spawnargs
    return nil unless @link
    @link.process.spawnargs
  end

  def set_display(display_id)
    option('display', ":#{display_id}")
  end

  def set_audio(alsa_id)
    env('PULSE_SINK', alsa_id.to_s)
  end

  private

  def set_default_options
    option('disable-infobars')
    option('disable-background-networking')
    option('enable-features', 'NetworkService,NetworkServiceInProcess')
    option('disable-background-timer-throttling')
    option('disable-backgrounding-occluded-windows')
    option('disable-breakpad')
    option('disable-client-side-phishing-detection')
    option('disable-default-apps')
    option('disable-dev-shm-usage')
    option('disable-extensions')
    option('disable-features', 'AudioServiceOutOfProcess,site-per-process,TranslateUI,BlinkGenPropertyTrees')
    option('disable-hang-monitor')
    option('disable-ipc-flooding-protection')
    option('disable-popup-blocking')
    option('disable-prompt-on-repost')
    option('disable-renderer-backgrounding')
    option('disable-sync')
    option('force-color-profile', 'srgb')
    option('metrics-recording-only')
    option('safebrowsing-disable-auto-update')
    option('password-store', 'basic')
    option('use-mock-keychain')
    # custom flags
    option('kiosk') # remove head
    option('window-size', '1920,1080')
    option('window-position', '0,0')
    option('disable-translate')
    option('no-default-browser-check')

    # исключаем для скрытия строки "Браузером Chrome управляет автоматизированное тестовое ПО"
    option('enable-automation', false)
    option('disable-blink-features', 'AutomationControlled')
    # options.append("--enable-automation=false")
    option("excludeSwitches', 'enable-automation")
    # options.append("excludeSwitches=enable-automation")

    ##
    option('autoplay-policy', 'no-user-gesture-required')
    option('no-sandbox')
    option('user-agent', 'Stream_X')
  end
end