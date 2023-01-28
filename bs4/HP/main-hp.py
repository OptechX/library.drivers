from selenium import webdriver

import requests
from bs4 import BeautifulSoup
import os
import re

# html file variables
html_src = os.path.join(os.path.dirname(os.path.realpath(__file__)),'page_source.html')
output_csv = os.path.join(os.path.dirname(os.path.realpath(__file__)),'hp-all.csv')
tmp_txt = os.path.join(os.path.dirname(os.path.realpath(__file__)),'temp.txt')
csv_header = 'Model,Win7,Win8.1,Win10,Win11'

# remove if file exists
try:
    os.remove(html_src)
    os.remove(output_csv)
    os.remove(tmp_txt)
except OSError:
    pass

# create blank csv
with open(output_csv, 'a') as f:
    f.write(csv_header)
    f.write('\n')

options = webdriver.ChromeOptions() 
options.add_argument('--headless')
driver = webdriver.Chrome(options=options)
# driver.maximize_window()

driver.get("https://hpia.hpcloud.hp.com/downloads/driverpackcatalog/HP_Driverpack_Matrix_x64.html")
pageSource = driver.page_source
fileToWrite = open(html_src, "w")
fileToWrite.write(pageSource)
fileToWrite.close()
fileToRead = open(html_src, "r")
fileToRead.close()
driver.quit()

# now to use bs4
with open(html_src, 'r') as f:
    contents = f.read()

    soup = BeautifulSoup(contents, 'lxml')
    data_table = soup.find_all('table')
    print(len(data_table))

notebook_tablet_driver_pack = data_table[1]

for machine in notebook_tablet_driver_pack.find_all('tbody'):
    rows = machine.find_all('tr')
    for row in rows:
        pl_machine = row.find('td').find('p').text
        print(f'{pl_machine}')