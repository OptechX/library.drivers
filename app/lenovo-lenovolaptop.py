from selenium import webdriver
from bs4 import BeautifulSoup
import os
import sys

print(f'Running script -> {sys.argv[0]}')

# SETUP
from pathlib import Path
OEM = 'Lenovo'
script_root = Path(os.path.realpath(__file__))
current_dir = Path(script_root.parent.absolute())
parent_dir = Path((script_root.parent.absolute()).parent.absolute())
output_dir = os.path.join(current_dir, f'data/{OEM}')
tmp_dir = os.path.join(current_dir, 'tmp')
output_file_dell = os.path.join(output_dir, os.path.basename(__file__).replace(".py", ""))
if not os.path.exists(output_dir):
    os.makedirs(output_dir)
if not os.path.exists(tmp_dir):
    os.makedirs(tmp_dir)

# html file variables
html_src = f'{tmp_dir}/page_source.html'
output_csv = f'{output_dir}/lenovo-lenovolaptop.csv'
tmp_txt = f'{tmp_dir}/temp.txt'
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

# Specify the path to the Chrome binary here
chrome_binary_path = '/usr/bin/google-chrome'  # Replace with the actual path

options = webdriver.ChromeOptions()
options.binary_location = chrome_binary_path
options.add_argument('--headless')

# Create the Chrome WebDriver instance
driver = webdriver.Chrome(options=options)

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
    # print(len(data_table))

# set the target table
lenovolaptop_driver_pack = data_table[6]

with open(output_csv, 'a') as f:
    for machine in lenovolaptop_driver_pack.find_all('tbody'):
        rows = machine.find_all('tr')
        for row in rows:
            # create blank line for CSV
            line_output = ''

            # get the machine name and add to the line, including 2x 'No,' for Win7/8.1
            pl_machine_td = row.find('td')
            if pl_machine_td:
                pl_machine = pl_machine_td.text.replace(',', '')
                line_output = line_output + pl_machine + ',No,No,'
            else:
                # Skip this row as there's no <td> element
                continue

            # Continue processing for Win10 and Win11 columns

            pl_win10 = row.find_all('td')[1].text
            if (pl_win10 != None):
                if (pl_win10 != '-'):
                    line_output = line_output + 'Yes,'
                else:
                    line_output = line_output + 'No,'
            pl_win11 = row.find_all('td')[2].text
            if (pl_win11 != None):
                if (pl_win11 != '-'):
                    line_output = line_output + 'Yes,'
                else:
                    line_output = line_output + 'No,'

            f.write(line_output)
            f.write('\n')

# Remove the header line from the CSV
with open(output_csv, "r") as input:
    with open(tmp_txt, "w") as output:
        header_line = next(input)  # Read and discard the header line
        for line in input:
            output.write(line)

# Replace the CSV with the modified version
os.replace(tmp_txt, output_csv)
