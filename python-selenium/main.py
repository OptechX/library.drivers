from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options

import time

options = Options()
# options.headless = True
driver = webdriver.Chrome('./chromedriver', options=options)

driver.get("https://www.microsoft.com/en-us/download/confirmation.aspx?id=101315")
print(driver.title)
time.sleep(30)
# search_bar = driver.find_element_by_name("q")
# search_bar.clear()
# search_bar.send_keys("getting started with python")
# search_bar.send_keys(Keys.RETURN)
# print(driver.current_url)
# driver.close()
