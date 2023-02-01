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

# SETUP
from pathlib import Path
OEM = 'Microsoft'
script_root = Path(os.path.realpath(__file__))
current_dir = Path(script_root.parent.absolute())
parent_dir = Path((script_root.parent.absolute()).parent.absolute())
output_dir = os.path.join(current_dir,f'data/{OEM}')
tmp_dir = os.path.join(current_dir,'tmp')
output_file_dell = os.path.join(output_dir,os.path.basename(__file__).replace(".py",""))
if not os.path.exists(output_dir):
    os.makedirs(output_dir)
if not os.path.exists(tmp_dir):
    os.makedirs(tmp_dir)
html_src = f'{tmp_dir}/page_source.html'
output_csv = f'{output_dir}/microsoft-all.csv'
tmp_txt = f'{tmp_dir}/temp.txt'
csv_header = 'Make,Series,Model,Win10,Win11'
href2 = str()
href3 = str()
url = 'https://www.microsoft.com/en-us/download/details.aspx?id=49497'

# CSV OUTPUT SETUP
model = "Surface Book"
output_text = "Microsoft,Surface Book," + model + ","
win10 = 'False,'
win11 = 'False'

# GENERATE CSV IF NOT EXIST
if not os.path.isfile(output_csv):
    with open(output_csv, 'a') as f:
        f.write(csv_header)
        f.write('\n')

# REMOVE HTML SOURCE FILE
remove_files = [html_src,tmp_txt]
for i in remove_files:
    try:
        os.remove(i)
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
