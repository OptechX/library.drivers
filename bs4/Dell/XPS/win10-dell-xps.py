import requests
from bs4 import BeautifulSoup
import os
import re

# Dell XPS
url = 'https://www.dell.com/support/kbdoc/en-au/000109959/dell-command-deploy-driver-packs-for-xps-models'
r = requests.get(url)
soup = BeautifulSoup(r.text, 'html.parser')
data_table = soup.find('table', class_ = 'table-bordered table-hover table-condensed')

# define Windows 10 XPS CSV
win10_xps_csv = 'bs4/Dell/output/win10_dell_xps.csv'
win10_xps_csv2 = 'bs4/Dell/output/win10_dell_xps2.csv'

# remove if file exists
try:
    os.remove(win10_xps_csv)
    os.remove(win10_xps_csv2)
except OSError:
    pass

# create header row on CSV
header_row = "Make,Model,Updated"
with open(win10_xps_csv, 'a') as f:
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
                    .replace('XPS ','XPS,')\
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
                with open(win10_xps_csv, 'a') as f:
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
                .replace('XPS ','XPS,')\
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
            with open(win10_xps_csv, 'a') as f:
                f.write(output)
                f.write('\n')



# remove the broken line
# bad_lines = ['9720','9520','9315']
# with open(win10_xps_csv) as oldfile, open(win10_xps_csv2, 'w') as newfile:
#     for line in oldfile:
#         if not any(bad_line in line for bad_line in bad_lines):
#             newfile.write(line)


# swap files around
# try:
#     os.remove(win10_xps_csv)
#     os.rename(win10_xps_csv2, win10_xps_csv)
# except OSError:
#     pass