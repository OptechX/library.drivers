from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options

from bs4 import BeautifulSoup

from re import search
import os
import sys

print(f'Running script -> {sys.argv[0]}')

# VARIABLES
html_src = os.path.join(os.path.dirname(os.path.realpath(__file__)),'output/page_source.html')
output_csv = os.path.join(os.path.dirname(os.path.realpath(__file__)),'output/micrososft-all.csv')
tmp_txt = os.path.join(os.path.dirname(os.path.realpath(__file__)),'output/temp.txt')
csv_header = 'Make,Series,Model,Win10,Win11'

# CSV OUTPUT SETUP
model = "Surface Studio 2"
output_text = "Microsoft,Surface Studio," + model + ","
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
driver.get('https://www.microsoft.com/en-us/download/details.aspx?id=57593')
elements = driver.find_elements(By.PARTIAL_LINK_TEXT,"Download")

href = elements[0].get_attribute('href')

driver.get(href)
elements = driver.find_elements(By.PARTIAL_LINK_TEXT,"manually")

href = elements[0].get_attribute('href')

driver.quit()


if search('Win10', href):
    win10 = 'True,'
if search('Win11', href):
    win11 = 'True'

# SET OUTPUT
output_text = output_text + win10 + win11

# WRITE TO CSV
with open(output_csv, 'a') as f:
    f.write(output_text)
    f.write('\n')