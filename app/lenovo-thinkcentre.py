from selenium import webdriver
from bs4 import BeautifulSoup
from re import search
import os
import sys

print(f'Running script -> {sys.argv[0]}')

# SETUP
from pathlib import Path
OEM = 'Lenovo'
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

# html file variables
html_src = f'{tmp_dir}/page_source.html'
output_csv = f'{output_dir}/lenovo-thinkcentre.csv'
tmp_txt = f'{tmp_dir}/temp.txt'
csv_header = 'Model,Win7,Win8.1,Win10,Win11'
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
    # print(len(data_table))  issue-5

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