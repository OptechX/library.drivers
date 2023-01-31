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
model = "Surface Laptop Studio"
output_text = "Microsoft,Surface Laptop Studio," + model + ","
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

# DOWNLOAD PAGE
driver.get("https://www.microsoft.com/en-us/download/details.aspx?id=103505")
driver.find_element(By.XPATH,'/html/body/main/div/div/form/div/div[2]/div/div/div/div[2]/div/div/div/div/div[2]/div[3]/div/div/div/a').click()
pageSource = driver.page_source
fileToWrite = open(html_src, "w")
fileToWrite.write(pageSource)
fileToWrite.close()
fileToRead = open(html_src, "r")
fileToRead.close()
driver.quit()

# USE BS4 TO READ HTML
with open(html_src, 'r') as f:
    contents = f.read()
    soup = BeautifulSoup(contents, 'lxml')
    data_table = soup.find_all('table')

# MAP OUT DATA
table_body = data_table[0].find('tbody')
for row in table_body.find_all('tr'):
    if search('Win10', row.text):
        win10 = 'True,'
    if search('Win11', row.text):
        win11 = 'True'

# SET OUTPUT
output_text = output_text + win10 + win11

# WRITE TO CSV
with open(output_csv, 'a') as f:
    f.write(output_text)
    f.write('\n')