import requests
from bs4 import BeautifulSoup
import os
import re
import sys

print(f'Running script -> {sys.argv[0]}')

# Dell Latitude
url = 'https://www.dell.com/support/kbdoc/en-au/000109893/dell-command-deploy-driver-packs-for-latitude-models'
r = requests.get(url)
soup = BeautifulSoup(r.text, 'html.parser')
data_table = soup.find('table', class_ = 'table-bordered table-hover table-condensed')

# define Windows 11 Latitude CSV
win11_latitude_csv = os.path.join(os.path.dirname(os.path.realpath(__file__)),'output/win11-dell-latitude.csv')
win11_latitude_csv2 = os.path.join(os.path.dirname(os.path.realpath(__file__)),'output/win11-dell-latitude2.csv')

# remove if file exists
try:
    os.remove(win11_latitude_csv)
    os.remove(win11_latitude_csv2)
except OSError:
    pass

# create header row on CSV
header_row = "Make,Model,Updated"
with open(win11_latitude_csv, 'a') as f:
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
            if (pl_check == 'Not Applicable'):
                pl_date = row.find_all('td')[4].text.strip()
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
                with open(win11_latitude_csv, 'a') as f:
                    f.write(output)
                    f.write('\n')
        if (len(pl_count) == 7):
            # is a win10 and win11 machine
            pl_date = row.find_all('td')[6].text.strip()
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
            with open(win11_latitude_csv, 'a') as f:
                f.write(output)
                f.write('\n')

