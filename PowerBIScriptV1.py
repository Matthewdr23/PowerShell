def data_xlsx():
    try:
        filename = input("Please enter the name of the Excel file you want to read: ")

        # Read the Excel file into a Pandas DataFrame
        df = pd.read_excel(filename)
        df = df.drop(columns=['Created', 'Actor'])
        filtered_df = df[(df['Status'] == 'PASSED')]

        # Ask the user for the output file name
        output_filename = input("Enter the name for the output Excel file (e.g., output.xlsx): ")

        # Write the DataFrame to the output Excel file
        filtered_df.to_excel(output_filename, index=False)
        print(f"Data exported to '{output_filename}' successfully!")

    except FileNotFoundError:
        print(f"Error: File '{filename}' not found.")

data_xlsx()