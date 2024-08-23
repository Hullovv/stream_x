require 'selenium-webdriver'
require 'puppeteer'

class Pupper
  attr_reader :driver, :options, :client

  def initialize(display, audio)
    @driver = Puppeteer.launch(
       headless: false,
       args: set_options(display, audio),
       ignore_default_args: ['enable-automation'],
       env: {'PULSE_SINK' => audio.pulse_id.to_s}
     )
  end

  def set_options(display, audio)
    options = []
    # set xvfb display
    options.append("--display=:#{display}")
    # options.append("--alsa-output-device=#{audio.pulse_id}.monitor")
    # default
    options.append('--disable-infobars')
    options.append('--disable-background-networking=true')
    options.append('--enable-features=NetworkService,NetworkServiceInProcess')
    options.append('--disable-background-timer-throttling=true')
    options.append('--disable-backgrounding-occluded-windows=true')
    options.append('--disable-breakpad=true')
    options.append('--disable-client-side-phishing-detection=true')
    options.append('--disable-default-apps=true')
    options.append('--disable-dev-shm-usage')
    options.append('--disable-extensions')
    options.append('--disable-features=AudioServiceOutOfProcess,site-per-process,TranslateUI,BlinkGenPropertyTrees')
    options.append('--disable-hang-monitor')
    options.append('--disable-ipc-flooding-protection')
    options.append('--disable-popup-blocking')
    options.append('--disable-prompt-on-repost')
    options.append('--disable-renderer-backgrounding')
    options.append('--disable-sync')
    options.append('--force-color-profile=srgb')
    options.append('--metrics-recording-only')
    options.append('--safebrowsing-disable-auto-update')
    options.append('--password-store=basic')
    options.append('--use-mock-keychain')
    # custom flags
    options.append('--kiosk') # remove head
    options.append('--window-size=1920,1080')
    options.append('--window-position=0,0')
    options.append('--disable-translate')
    # исключаем для скрытия строки "Браузером Chrome управляет автоматизированное тестовое ПО"
    options.append('--disable-blink-features=AutomationControlled')
    options.append('--enable-features=NetworkService,NetworkServiceInProcess')

    ##
    options.append('--autoplay-policy=no-user-gesture-required')
    options.append('--no-sandbox')
    # options.append('--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101 Firefox/78.0')
    # options.append('--guest')
    # options.add_option('pageLoadStrategy', 'eager')
    options
  end

  def set_client
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 120 # seconds
    client
  end

  def start
    # driver.get 'https://google.com'
    page = @driver.new_page

    page.viewport = Puppeteer::Viewport.new(width: 1920, height: 1080)
    page.goto 'https://rutube.ru/video/2c7230d6ac4767e7cc0b7aeea0907143/', wait_until: 'domcontentloaded' # 'https://ya.ru/video/preview/287310971696413437' #'https://www.youtube.com/watch?v=Zocjk0nZX_4'
    p "created page #{page.url}"
  rescue StandardError => e
    puts "Error navigate: #{e}"
    nil
  end
end
