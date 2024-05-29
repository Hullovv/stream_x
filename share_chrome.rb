require 'selenium-webdriver'

DISPLAY=100

def take_screen(id, path)
  system "import -display :#{id} -window root #{path}"
rescue StandardError => e
  puts e
  nil
end

def launch_x(id, dims="1920x1080x16")
  pid = spawn("Xvfb :#{id} -screen 0 #{dims} &")
  puts pid
  pid
end

def kill_x(pid)
  Process.kill("SIGKILL", pid)
end

def check_proc(pid)
  puts `ps aux | grep #{pid}`
end

pid = launch_x(DISPLAY)

options = Selenium::WebDriver::Chrome::Options.new

# set xvfb display
options.add_argument("--display=:#{DISPLAY}")

# default
options.add_argument("--disable-infobars")
options.add_argument("--disable-background-networking=true")
options.add_argument("--enable-features=NetworkService,NetworkServiceInProcess")
options.add_argument("--disable-background-timer-throttling=true")
options.add_argument("--disable-backgrounding-occluded-windows=true")
options.add_argument("--disable-breakpad=true")
options.add_argument("--disable-client-side-phishing-detection=true")
options.add_argument("--disable-default-apps=true")
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--disable-extensions")
options.add_argument("--disable-features=AudioServiceOutOfProcess,site-per-process,TranslateUI,BlinkGenPropertyTrees")
options.add_argument("--disable-hang-monitor")
options.add_argument("--disable-ipc-flooding-protection")
options.add_argument("--disable-popup-blocking")
options.add_argument("--disable-prompt-on-repost")
options.add_argument("--disable-renderer-backgrounding")
options.add_argument("--disable-sync")
options.add_argument("--force-color-profile=srgb")
options.add_argument("--metrics-recording-only")
options.add_argument("--safebrowsing-disable-auto-update")
options.add_argument("--password-store=basic")
options.add_argument("--use-mock-keychain")

# custom flags
options.add_argument("--kiosk") # remove head
options.add_argument("--window-size=1920,1080")
options.add_argument("--window-position=0,0")
options.add_argument("--disable-translate")

# исключаем для скрытия строки "Браузером Chrome управляет автоматизированное тестовое ПО"
options.exclude_switches << "enable-automation"
##

options.add_argument("--autoplay-policy=no-user-gesture-required")
options.add_argument("--no-sandbox")

driver = Selenium::WebDriver::Driver.for :chrome, options: options #, desired_capabilities: caps
driver.get "https://google.com"
driver.get "https://app.restream.su"
take_screen(DISPLAY, "./test.png")
kill_x(pid)
