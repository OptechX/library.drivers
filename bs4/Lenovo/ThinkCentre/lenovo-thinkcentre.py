from selenium import webdriver

import requests
from bs4 import BeautifulSoup
import os
import re

# html file variables
html_src = os.path.join(os.path.dirname(os.path.realpath(__file__)),'page_source.html')
output_csv = os.path.join(os.path.dirname(os.path.realpath(__file__)),'lenovo-thinkcentre.csv')
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

driver.get("https://support.lenovo.com/au/en/solutions/ht074984")
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

thinkcentre_driver_pack = data_table[4]



for machine in thinkcentre_driver_pack.find_all('tbody'):
    rows = machine.find_all('tr')
    for row in rows:
        line_output = ''
        pl_machine = row.find('td').text.replace(',','')
        line_output = line_output + pl_machine + ','
        pl_win7 = row.find_all('td')[1].text
        if (pl_win7 != None):
            if (pl_win7 != '-'):
                # print(f'{pl_machine} --> {pl_win7}')
                line_output = line_output + 'Yes,'
            else:
                line_output = line_output + 'No,'
        pl_win8 = row.find_all('td')[2].text
        if (pl_win8 != None):
            if (pl_win8 != '-'):
                # print(f'{pl_machine} --> {pl_win8}')
                line_output = line_output + 'Yes,'
            else:
                line_output = line_output + 'No,'
        pl_win10 = row.find_all('td')[3].text
        if (pl_win10 != None):
            if (pl_win10 != '-'):
                line_output = line_output + 'Yes,'
            else:
                line_output = line_output + 'No,'
        if (len(row.find_all('td')) == 4):
            line_output = line_output + 'Yes'
        if (len(row.find_all('td')) == 5):
            try:
                pl_win11 = row.find_all('td')[4].text
                if (pl_win11 != None):
                    if (pl_win11 != '-'):
                        line_output = line_output + 'Yes'
                    else:
                        line_output = line_output + 'No'
            except:
                line_output = line_output + 'Yes'
        with open(output_csv, 'a') as f:
            f.write(line_output)
            f.write('\n')

with open(output_csv, "r") as input:
    with open("temp.txt", "w") as output:
        # iterate all lines from file
        for line in input:
            # if text matches then don't write it
            if line.strip("\n") != "Sub-series,Yes,Yes,Yes,Yes":
                output.write(line)

# replace file with original name
os.replace('temp.txt', output_csv)