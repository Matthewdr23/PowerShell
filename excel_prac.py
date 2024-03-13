import os
import glob
import csv
# from xlsxwriter.workbook import Workbook
# from openpyxl import Workbook
import pandas as pd


# def csv_conversion():
#     for csvfile in glob.glob(os.path.join('.', '*.csv')):
#         workbook = Workbook(csvfile[:-4] + '.xlsx')
#         worksheet = workbook.add_worksheet()

#         with open(csvfile, 'rt', encoding='utf8') as f:
#             reader = csv.reader(f)
#             for r, row in enumerate(reader):
#                 for c, col in enumerate(row):
#                     worksheet.write(r, c, col)

#         workbook.close()

# csv_conversion()

def print_xlsx_files(directory_path):
    """
    Prints the filenames of all XLSX files in the specified directory.

    Args:
        directory_path (str): Path to the directory containing XLSX files.

    Returns:
        None
    """
    xlsx_files = glob.glob(os.path.join(directory_path, '*.xlsx'))
    for file in xlsx_files:
        print(file)

# Example usage:
path = os.getcwd()
directory_to_search = path
print_xlsx_files(directory_to_search)




:
#     try:
#         # Specify the directory where your Excel files are located
#         path = directory_to_search  # Replace with the actual directory

#         # List of specific filenames and their corresponding sheet names (if multiple sheets)
#         file_sheet_mapping = {
#             'WD Data.xlsx': None,
#             'FAM Disables.xlsx': 'Raw Data',
#             'SP Disables.xlsx': None,  # No specific sheet name needed
#             'FAM Last Login.xlsx': 'Raw Data'
            
#         }

#         # Initialize an empty DataFrame to store combined data
#         combined_df = pd.DataFrame()

#         # Read specific sheets from each Excel file and concatenate their data
#         for filename, sheet_name in file_sheet_mapping.items():
#             file_path = os.path.join(path, filename)
#             if os.path.exists(file_path):
#                 if sheet_name is None:
#                     # Read all sheets if no specific sheet name provided
#                     df = pd.read_excel(file_path, sheet_name=None, engine='openpyxl')
#                     for sheet_df in df.values():
#                         combined_df = pd.concat([combined_df, sheet_df], ignore_index=True)
#                 else:
#                     df = pd.read_excel(file_path, sheet_name=sheet_name, engine='openpyxl')
#                     combined_df = pd.concat([combined_df, df], ignore_index=True)
#             else:
#                 print(f"Warning: File '{filename}' not found.")

#         # Process the combined DataFrame (e.g., drop columns, filter data)
#         combined_df = combined_df.drop(columns=['FIRST_NAME', 'LAST_NAME','ADDRESS_WORK', 'CLASS','DEPARTMENT', 'JOBTITLE', 'LOCATION', 'COST_CENTER_HIERARCHY', 'FULLPARTTIME', 'TEAM', 'DIVISION', 'POSTAL_CODE', 'COUNTRY', 'CITY', 'ON_LEAVE', 'LEGAL_MIDDLE_NAME', 'MIDDLE_NAME', 'WORKER_NAME', 'ORGANIZATION_NAME' ])

#         # Ask for the output file name
#         output_filename = input("Enter the name for the output Excel file (e.g., output_combined.xlsx): ")

#         # Write the filtered DataFrame to the output Excel file
#         combined_df.to_excel(output_filename, index=False)
#         print(f"Data exported to '{output_filename}' successfully!")

#     except Exception as e:
#         print(f"Error: {str(e)}")

# # Call the function to combine the specified files
# combine_specific_files()

# def combine_specific_files(directory_to_search):
#     try:
        
#         path = directory_to_search

#         # List of specific filenames and their corresponding sheet names (if multiple sheets)
#         file_sheet_mapping = {
#             'WD Data.xlsx': None,
#             'FAM Disables.xlsx': 'Raw Data',
#             'SP Disables.xlsx': None,  # No specific sheet name needed
#             'FAM Last Login.xlsx': 'Raw Data'
#         }

#         # Initialize an empty DataFrame to store combined data
#         combined_df = pd.DataFrame()

#         # Read specific columns from each Excel file and concatenate their data
#         for filename, sheet_name in file_sheet_mapping.items():
#             file_path = os.path.join(path, filename)
#             if os.path.exists(file_path):
#                 if sheet_name is None:
#                     # Read all sheets if no specific sheet name provided
#                     df = pd.read_excel(file_path, sheet_name=None, engine='openpyxl')
#                     for sheet_df in df.values():
#                         combined_df = pd.concat([combined_df, sheet_df], ignore_index=True)
#                 else:
#                     df = pd.read_excel(file_path, sheet_name=sheet_name, engine='openpyxl')
#                     combined_df = pd.concat([combined_df, df], ignore_index=True)
#             else:
#                 print(f"Warning: File '{filename}' not found.")

#         # Select specific named columns (modify this list as needed)
#         selected_columns = ['WORKER_NAME', 'USERID', 'FILENUMBER', 'MANAGER_ID', 'EMAIL_ADDRESS_WORK', 'HIREDATE', 'TERMINATION_DATE', 'CONTRACT_END_DATE', 'LAST_DAY_OF_WORK', 'Created', 'Target']
#         combined_df = combined_df[selected_columns]

#         # Ask for the output file name
#         output_filename = input("Enter the name for the output file (e.g., 'combined_data.xlsx'): ")
#         combined_df.to_excel(output_filename, index=False)
#         print(f"Combined data saved to '{output_filename}'.")

#     except Exception as e:
#         print(f"Error: {str(e)}")

# combine_specific_files(directory_to_search)

def combine_specific_files(directory_to_search):
    try:
        # Specify the directory where your Excel files are located
        path = directory_to_search

        # List of specific filenames and their corresponding sheet names (if multiple sheets)
        file_sheet_mapping = {
            'WD Data.xlsx': None,
            'FAM Disables.xlsx': 'Raw Data',
            'SP Disables.xlsx': None,  # No specific sheet name needed
            'FAM Last Login.xlsx': 'Raw Data'
        }

        # Initialize an empty DataFrame to store combined data
        combined_df = pd.DataFrame()

        # Read specific columns from each Excel file and concatenate their data
        for filename, sheet_name in file_sheet_mapping.items():
            file_path = os.path.join(path, filename)
            if os.path.exists(file_path):
                if sheet_name is None:
                    # Read all sheets if no specific sheet name provided
                    df = pd.read_excel(file_path, sheet_name=None, engine='openpyxl')
                    for sheet_df in df.values():
                        combined_df = pd.concat([combined_df, sheet_df], ignore_index=True)
                else:
                    df = pd.read_excel(file_path, sheet_name=sheet_name, engine='openpyxl')
                    combined_df = pd.concat([combined_df, df], ignore_index=True)
            else:
                print(f"Warning: File '{filename}' not found.")

        # Select specific named columns (modify this list as needed)
        selected_columns = ['WORKER_NAME', 'USERID', 'FILENUMBER', 'MANAGER_ID',
                            'EMAIL_ADDRESS_WORK', 'HIREDATE', 'TERMINATION_DATE',
                            'CONTRACT_END_DATE', 'LAST_DAY_OF_WORK', 'Created', 'Target']
        combined_df = combined_df[selected_columns]

        # Ask for the output file name
        output_filename = input("Enter the name for the output file (e.g., 'combined_data.xlsx'): ")
        combined_df.to_excel(output_filename, index=False)
        print(f"Combined data saved to '{output_filename}'.")

    except Exception as e:
        print(f"Error: {str(e)}")

# Example usage
combine_specific_files(directory_to_search)