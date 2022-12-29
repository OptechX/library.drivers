from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By

import os
import time

# variables
download_dir = "/home/runner/work/optechx.drivers/optechx.drivers/downloads"

# notice
print("File location using os.getcwd():", os.getcwd())

# Surface Book Download Links
surface_book_3 = 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=101315'
surface_book_2 = 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=56261'
surface_book = 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=49497'

def latest_download_file():
    path = r'/Users/danijel-rpc/Projects/repasscloud/optechx.drivers/downloads'
    os.chdir(path)
    files = sorted(os.listdir(os.getcwd()), key=os.path.getmtime)
    newest = files[-1]
    return newest

# set download directory
prefs = {"download.default_directory" : download_dir}

# google chrome options
options = Options()
options.headless = True
options.add_experimental_option("prefs",prefs)

# create google chrome
driver = webdriver.Chrome(options=options)

# download files
surface_books = [surface_book_3, surface_book_2, surface_book]
for x in surface_books:
  driver.get(x)
  time.sleep(5)

fileends = "crdownload"
while "crdownload" == fileends:
    time.sleep(15)
    newest_file = latest_download_file()
    if "crdownload" in newest_file:
        fileends = "crdownload"
        print("Still downloading")
    else:
        fileends = "none"

driver.close()
