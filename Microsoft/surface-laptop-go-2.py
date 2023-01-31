from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.wait import WebDriverWait
def document_initialised(driver):
    return driver.execute_script("return initialised")

from bs4 import BeautifulSoup

from re import search
import os, sys, time

print(f'Running script -> {sys.argv[0]}')

# VARIABLES
url = 'https://www.microsoft.com/en-us/download/details.aspx?id=104251'
html_src = os.path.join(os.path.dirname(os.path.realpath(__file__)),'output/page_source.html')
output_csv = os.path.join(os.path.dirname(os.path.realpath(__file__)),'output/micrososft-all.csv')
tmp_txt = os.path.join(os.path.dirname(os.path.realpath(__file__)),'output/temp.txt')
csv_header = 'Make,Series,Model,Win10,Win11'
href2 = str()

# CSV OUTPUT SETUP
model = "Surface Laptop Go 2"
output_text = "Microsoft,Surface Laptop," + model + ","
win10 = 'False,'
win11 = 'False'

# GENERATE CSV IF NOT EXIST
if not os.path.isfile(output_csv):
    with open(output_csv, 'a') as f:
        f.write(csv_header)
        f.write('\n')

# REMOVE HTML SOURCE FILE
try:
    os.remove(html_src)
except OSError:
    pass

# SETUP CHROME WEBDRIVER (SILENT)
options = webdriver.ChromeOptions() 
options.add_argument('--headless')
driver = webdriver.Chrome(options=options)

# GET DOWNLOAD LINK
driver.get(url)
time.sleep(3)
elements = driver.find_elements(By.PARTIAL_LINK_TEXT,"Download")
href = elements[0].get_attribute("href")
driver.get(href)
elements2 = driver.find_elements(By.PARTIAL_LINK_TEXT,"manually")
time.sleep(2)
for i in elements2:
    if (search('SurfaceLaptopGo', i.get_attribute('href'))):
        href2 = i.get_attribute('href')

# QUIT CHROME DRIVER
driver.quit()

# DETERMINE VALUES
if search('Win10', href2):
    win10 = 'True,'
if search('Win11', href2):
    win11 = 'True'

# SET OUTPUT
output_text = output_text + win10 + win11

# WRITE TO CSV
with open(output_csv, 'a') as f:
    f.write(output_text)
    f.write('\n')