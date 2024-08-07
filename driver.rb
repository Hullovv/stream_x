require 'selenium-webdriver'

class Driver
  attr_reader :driver, :options, :client

  def initialize(display)
    @driver = Selenium::WebDriver::Driver.for :chrome, options: set_options(display), http_client: set_client # , desired_capabilities: caps
  end

  def set_options(display)
    options = Selenium::WebDriver::Chrome::Options.new
    # set xvfb display
    options.add_argument("--display=:#{display}")
    # default
    options.add_argument('--disable-infobars')
    options.add_argument('--disable-background-networking=true')
    options.add_argument('--enable-features=NetworkService,NetworkServiceInProcess')
    options.add_argument('--disable-background-timer-throttling=true')
    options.add_argument('--disable-backgrounding-occluded-windows=true')
    options.add_argument('--disable-breakpad=true')
    options.add_argument('--disable-client-side-phishing-detection=true')
    options.add_argument('--disable-default-apps=true')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--disable-extensions')
    options.add_argument('--disable-features=AudioServiceOutOfProcess,site-per-process,TranslateUI,BlinkGenPropertyTrees')
    options.add_argument('--disable-hang-monitor')
    options.add_argument('--disable-ipc-flooding-protection')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--disable-prompt-on-repost')
    options.add_argument('--disable-renderer-backgrounding')
    options.add_argument('--disable-sync')
    options.add_argument('--force-color-profile=srgb')
    options.add_argument('--metrics-recording-only')
    options.add_argument('--safebrowsing-disable-auto-update')
    options.add_argument('--password-store=basic')
    options.add_argument('--use-mock-keychain')
    # custom flags
    options.add_argument('--kiosk') # remove head
    options.add_argument('--window-size=1920,1080')
    options.add_argument('--window-position=0,0')
    options.add_argument('--disable-translate')
    # исключаем для скрытия строки "Браузером Chrome управляет автоматизированное тестовое ПО"
    options.exclude_switches << 'enable-automation'
    ##
    options.add_argument('--autoplay-policy=no-user-gesture-required')
    options.add_argument('--no-sandbox')

    options.page_load_strategy = 'eager'
    # options.add_option('pageLoadStrategy', 'eager')
    options
  end

  def set_client
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 5 # seconds
    client
  end

  def start
    # driver.get 'https://google.com'
    @driver.navigate.to 'https://www.youtube.com/watch?v=Zocjk0nZX_4'
  rescue StandardError => e
    puts "Error navigate: #{e}"
    nil
  end
end
