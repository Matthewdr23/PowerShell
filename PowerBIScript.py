
import os
import glob
import csv
# from xlsxwriter.workbook import Workbook
# from openpyxl import Workbook
import pandas as pd

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
        
path = os.getcwd()
directory_to_search = path
print_xlsx_files(directory_to_search)

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