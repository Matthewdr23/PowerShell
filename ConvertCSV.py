import os
import glob
import csv
from xlsxwriter.workbook import Workbook
from openpyxl import Workbook
import pandas as pd

'''
The purpose of this scriptn is to change a directory of CSV files in xlsx files for easier use of pasrsing data in other scripts.
The reason for it's creation is because SailPoint allows the users to download reports but only as a CSV file. This became an issue when trying to automate 
the Testing process with attestation as data in a CSV file does not correlate with data in a XLSX file so the conversion made things easier.
'''

def csv_conversion():
    for csvfile in glob.glob(os.path.join('.', '*.csv')):
        workbook = Workbook(csvfile[:-4] + '.xlsx')
        worksheet = workbook.add_worksheet()

        with open(csvfile, 'rt', encoding='utf8') as f:
            reader = csv.reader(f)
            for r, row in enumerate(reader):
                for c, col in enumerate(row):
                    worksheet.write(r, c, col)

        workbook.close()

csv_conversion()