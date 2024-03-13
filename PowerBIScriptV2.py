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

# Example usage:
path = os.getcwd()
directory_to_search = path
print_xlsx_files(directory_to_search)


def combine_specific_files():
    try:
        # Specify the directory where your Excel files are located
        path = directory_to_search

        # List of specific filenames
        filenames = ['FAM Disables.xlsx', 'SP Disables.xlsx', 'FAM Last Login.xlsx', 'WD Data.xlsx']

        # Initialize an empty DataFrame to store combined data
        combined_df = pd.DataFrame()

        # Read each specific Excel file and concatenate its data to the combined DataFrame
        for filename in filenames:
            file_path = os.path.join(path, filename)
            if os.path.exists(file_path):
                df = pd.read_excel(file_path)
                combined_df = pd.concat([combined_df, df], ignore_index=True)
            else:
                print(f"Warning: File '{filename}' not found.")

        # Process the combined DataFrame (e.g., drop columns, filter data)
        combined_df = combined_df.drop(columns=['Created', 'Actor'])
        # filtered_df = combined_df[combined_df['Status'] == 'PASSED']

        # Ask for the output file name
        output_filename = input("Enter the name for the output Excel file (e.g., output_combined.xlsx): ")

        # Write the filtered DataFrame to the output Excel file
        combined_df.to_excel(output_filename, index=False)
        print(f"Data exported to '{output_filename}' successfully!")

    except Exception as e:
        print(f"Error: {str(e)}")

# Call the function to combine the specified files
combine_specific_files()
