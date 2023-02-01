import requests
from bs4 import BeautifulSoup
import os
import re
import sys

print(f'Running script -> {sys.argv[0]}')

# SETUP
from pathlib import Path
OEM = 'Dell'
script_root = Path(os.path.realpath(__file__))
current_dir = Path(script_root.parent.absolute())
parent_dir = Path((script_root.parent.absolute()).parent.absolute())
output_dir = os.path.join(current_dir,f'data/{OEM}')
output_file_dell = os.path.join(output_dir,os.path.basename(__file__).replace(".py",""))
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Dell Latitude Win10
url = 'https://www.dell.com/support/kbdoc/en-au/000109893/dell-command-deploy-driver-packs-for-latitude-models'
r = requests.get(url)
soup = BeautifulSoup(r.text, 'html.parser')
data_table = soup.find('table', class_ = 'table-bordered table-hover table-condensed')

# define Windows CSVs
win10_latitude_csv = f'{output_file_dell}.csv'
win10_latitude_csv2 = f'{output_file_dell}-2.csv'

# remove if file exists
try:
    os.remove(win10_latitude_csv)
    os.remove(win10_latitude_csv2)
except OSError:
    pass

# create header row on CSV
header_row = "Make,Model,Updated"
with open(win10_latitude_csv, 'a') as f:
            f.write(header_row)
            f.write('\n')

# extract data
for machine in data_table.find_all('tbody'):
    rows = machine.find_all('tr')
    for row in rows:
        # set count of columns for row
        pl_count = row.find_all('td')

        # 5 items means it's Win10 or Win11 ONLY
        if (len(pl_count) == 5):
            # get the text of cell 2, index 1, if it is "Not Applicable", it's a Win11 only machine
            pl_check = row.find_all('td')[1].text.strip()
            if (pl_check != 'Not Applicable'):
                pl_date = row.find_all('td')[3].text.strip()
                # get the machine name
                pl_machine = row.find('td').text\
                    .replace('\n','')\
                    .replace('        ','')\
                    .replace(u"\u00A0"," ")\
                    .replace('Latitude ','Latitude,')\
                    .replace('0(','0 (')\
                    .replace('1(','1 (')\
                    .replace('2(','2 (')\
                    .replace('3(','3 (')\
                    .replace('4(','4 (')\
                    .replace('5(','5 (')\
                    .replace('6(','6 (')\
                    .replace('7(','7 (')\
                    .replace('8(','8 (')\
                    .replace('9(','9 (')\
                    .strip()
                # pl_machine = re.sub('2.*in.*1','2-in-1', pl_machine)
                # print(f'{pl_machine} --> {pl_date}')
                output = pl_machine + "," + pl_date
                with open(win10_latitude_csv, 'a') as f:
                    f.write(output)
                    f.write('\n')
        if (len(pl_count) == 7):
            # is a win10 and win10 machine
            pl_date = row.find_all('td')[3].text.strip()
            # get the machine name
            pl_machine = row.find('td').text\
                .replace('\n','')\
                .replace('        ','')\
                .replace(u"\u00A0"," ")\
                .replace('Latitude ','Latitude,')\
                .replace('0(','0 (')\
                .replace('1(','1 (')\
                .replace('2(','2 (')\
                .replace('3(','3 (')\
                .replace('4(','4 (')\
                .replace('5(','5 (')\
                .replace('6(','6 (')\
                .replace('7(','7 (')\
                .replace('8(','8 (')\
                .replace('9(','9 (')\
                .strip()
            pl_machine = re.sub('2.*in.*1','2-in-1', pl_machine)
            # print(f'{pl_machine} --> {pl_date}')
            output = pl_machine + "," + pl_date
            with open(win10_latitude_csv, 'a') as f:
                f.write(output)
                f.write('\n')



# remove the broken line
bad_lines = ['3330,11/08/2016']
with open(win10_latitude_csv) as oldfile, open(win10_latitude_csv2, 'w') as newfile:
    for line in oldfile:
        if not any(bad_line in line for bad_line in bad_lines):
            newfile.write(line)


# swap files around
try:
    os.remove(win10_latitude_csv)
    os.rename(win10_latitude_csv2, win10_latitude_csv)
except OSError:
    pass