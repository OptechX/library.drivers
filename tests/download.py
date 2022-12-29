from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options

import time

prefs = {"download.default_directory" : "/home/runner/work/optechx.drivers/optechx.drivers/downloads"}

options = Options()
options.headless = True
options.add_experimental_option("prefs",prefs)
driver = webdriver.Chrome('./chromedriver', options=options)


try:
    driver.get('https://www.browserstack.com/test-on-the-right-mobile-devices')
    downloadcsv = driver.find_element_by_css_selector('.icon-csv')
    gotit = driver.find_element_by_id('accept-cookie-notification')
    gotit.click()
    downloadcsv.click()
    time.sleep(5)
    driver.close()
except:
    print("Invalid URL")
