from selenium import webdriver
from bs4 import BeautifulSoup
from re import search
import os

# html file variables
html_src = os.path.join(os.path.dirname(os.path.realpath(__file__)),'page_source.html')
output_csv = os.path.join(os.path.dirname(os.path.realpath(__file__)),'hp-all.csv')
tmp_txt = os.path.join(os.path.dirname(os.path.realpath(__file__)),'temp.txt')
csv_header = 'Make,Series,Model,Win7,Win8.1,Win10,Win11'

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

notebook_table = data_table[1]

tables = notebook_table.find_all('tbody')

for row in tables[1].find_all('tr'):
    win11 = "No"
    win10 = "No,"
    if len(row) > 5:
        row_data = row.find_all('td')
        tmp_machine = row_data[0].find_all('p')

        # discover if supports Win11
        win11a = row_data[1].text
        win11b = row_data[3].text
        if (win11a != '-' or win11b != '-'):
            win11 = "Yes"
        
        # discover if supports Win10
        win10a = row_data[2].text
        win10b = row_data[4].text
        win10c = row_data[6].text
        win10d = row_data[7].text
        win10e = row_data[8].text
        win10f = row_data[9].text
        win10g = row_data[10].text
        win10h = row_data[12].text
        win10i = row_data[13].text
        win10j = row_data[14].text
        win10k = row_data[15].text
        if (win10a != '-' or \
            win10b != '-' or \
            win10c != '-' or \
            win10d != '-' or \
            win10e != '-' or \
            win10f != '-' or \
            win10g != '-' or \
            win10h != '-' or \
            win10i != '-' or \
            win10j != '-' or \
            win10k != '-'):
            win10 = "Yes,"

        for t in tmp_machine:
            pl_machine = t.get_text()
            if search('Healthcare', pl_machine):
                pass
            elif search('HP Elite Slice', pl_machine):
                pass
            elif search('HP Collaboration ', pl_machine):
                pass
            elif search('HP Elite Slice ', pl_machine):
                pass
            elif search('Retail System', pl_machine):
                pass
            elif search('Mobile System', pl_machine):
                pass
            elif search('HP Engage', pl_machine):
                pass
            elif search('HP Presence', pl_machine):
                pass
            elif search('Microsoft Team', pl_machine):
                pass
            elif search('HP Pro ', pl_machine):
                pass
            elif search('HP Mini Conferencing', pl_machine):
                pass
            elif search('HP Zhan60', pl_machine):
                pass
            elif search('Backpack', pl_machine):
                pass
            elif search('HP ZHAN', pl_machine):
                pass
            elif search('HP ZCentral', pl_machine):
                pass
            elif search('Sprout', pl_machine):
                pass
            elif search('HP Z1', pl_machine):
                pass
            elif search('HP ZBook Create', pl_machine):
                pass
            # elif search('HP EliteBook Folio 9480m Notebook PC', pl_machine):
            #     pass
            # elif search('HP EliteBook Revolve', pl_machine):
            #     pass
            # elif search('HP EliteBook Folio', pl_machine):
            #     pass
            # elif search('HP EliteBook 840 Aero', pl_machine):
            #     pass
            # elif search('HP EliteBook 835 13.3 inch', pl_machine):
            #     pass
            # elif search('HP EliteBook 845 14 inch', pl_machine):
            #     pass
            # elif search('HP EliteBook 865 16 inch', pl_machine):
            #     pass
            # elif search('HP EliteBook 1040 14 inch', pl_machine):
            #     pass
            # elif search('HP EliteBook 830 13.3 inch', pl_machine):
            #     pass
            # elif search('HP EliteBook 840 14 inch', pl_machine):
            #     pass
            # elif search('HP EliteBook 860 16 inch', pl_machine):
            #     pass
            # elif search('HP EliteBook 630 13 inch', pl_machine):
            #     pass
            # elif search('HP EliteBook 640 14 inch', pl_machine):
            #     pass
            # elif search('HP EliteBook 650 15.6 inch', pl_machine):
            #     pass
            # elif search('HP EliteBook 645 14 inch', pl_machine):
            #     pass
            # elif search('HP EliteBook 655 15.6 inch', pl_machine):
            #     pass
            elif search('HP Dragonfly', pl_machine):
                pass
            elif search('HP Z2 ', pl_machine):
                i = 'HP '
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',Z2,' + pl_m + ',No,No,' + win10 + win11
            elif search('HP Z4 ', pl_machine):
                i = 'HP '
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',Z4,' + pl_m + ',No,No,' + win10 + win11
            elif search('HP Z6 ', pl_machine):
                i = 'HP '
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',Z6,' + pl_m + ',No,No,' + win10 + win11
            elif search('HP Z8 ', pl_machine):
                i = 'HP '
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',Z8,' + pl_m + ',No,No,' + win10 + win11
            elif search('HP EliteBook x360 ', pl_machine):
                i = 'HP EliteBook x360 '
                j = 'HP EliteBook x360'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',' +  j.strip() + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP ProBook x360 ', pl_machine):
                i = 'HP ProBook x360 '
                j = 'HP ProBook x360'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',' +  j.strip() + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP Elite x360 ', pl_machine):
                i = 'HP Elite x360 '
                j = 'HP Elite x360'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',' +  j.strip() + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP EliteBook ', pl_machine):
                i = 'HP EliteBook '
                j = 'HP EliteBook'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',' +  j.strip() + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP EliteDesk ', pl_machine):
                i = 'HP EliteDesk '
                j = 'HP EliteDesk'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',' +  j.strip() + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP EliteOne ', pl_machine):
                i = 'HP EliteOne '
                j = 'HP EliteOne'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',' +  j.strip() + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP ProBook ', pl_machine):
                i = 'HP ProBook '
                j = 'HP ProBook'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',' +  j.strip() + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP ProOne ', pl_machine):
                i = 'HP ProOne '
                j = 'HP ProOne'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',' +  j.strip() + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP Elite ', pl_machine):
                i = 'HP Elite '
                j = 'HP Elite'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',' +  j.strip() + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP ZBook ', pl_machine):
                i = 'HP ZBook '
                j = 'HP ZBook'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',' +  j.strip() + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP ProDesk ', pl_machine):
                i = 'HP ProDesk '
                j = 'HP ProDesk'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP'.strip() + ',' +  j.strip() + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP Z240 ', pl_machine):
                i = 'HP Z240'
                j = 'HP Z240'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP,' + j + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP Z440 ', pl_machine):
                i = 'HP Z440'
                j = 'HP Z440'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP,' + j + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP Z640 ', pl_machine):
                i = 'HP Z640'
                j = 'HP Z640'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP,' + j + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP Z840 ', pl_machine):
                i = 'HP Z840'
                j = 'HP Z840'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP,' + j + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP Z230 ', pl_machine):
                i = 'HP Z230'
                j = 'HP Z230'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP,' + j + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP Z420 ', pl_machine):
                i = 'HP Z420'
                j = 'HP Z420'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP,' + j + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP Z620 ', pl_machine):
                i = 'HP Z620'
                j = 'HP Z620'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP,' + j + ',' + pl_m + ',No,No,' + win10 + win11
            elif search('HP Z820 ', pl_machine):
                i = 'HP Z820'
                j = 'HP Z820'.replace('HP ','')
                pl_m = pl_machine.replace(i,'')
                line_output = 'HP,' + j + ',' + pl_m + ',No,No,' + win10 + win11
            else:
                print(f'Unknown machine --------------> {pl_machine}')
            
            with open(output_csv, 'a') as f:
                f.write(line_output)
                f.write('\n')



