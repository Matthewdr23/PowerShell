# The purpose of this script is to automate the process of creating a body for the email that is to be sent out to people during a recert

def FollowUp_Email():
    #provided paragraph
    Subject = "<Application Name> Semi-Annual Recertification"
    paragraph = '''
    Ref:<Application Name>

Hi ,

ENTER TEXT HERE

Thank you.


    '''
    # User input: Application name and recertification date
    app_name = input("Enter the application name: ")
    recert_date = input("Enter the recertification date (e.g., February 28, 2024): ")

    # Replace placeholders in the paragraph
    formatted_subject =  Subject.replace("<Application Name>", app_name)
    formatted_paragraph = paragraph.replace("<Application Name>", app_name).replace("<DATE>", recert_date)

    # Print the formatted email template
    print("\nEmail Template:\n")
    print("Subject: ", formatted_subject)
    print(formatted_paragraph)

#this is for the SVPs and EXECs
def Exec_Email():
    # Provided paragraph
    paragraph = '''Good Day,

ENTER TEXT HERE

Thank you.'''

    # User input: Application name and recertification date
    app_name = input("Enter the application name: ")
    recert_date = input("Enter the recertification date (e.g., February 28, 2024): ")

    # Replace placeholders in the paragraph
    formatted_paragraph = paragraph.replace("<Application Name>", app_name).replace("<DATE>", recert_date)

    # Print the formatted email template
    print("\nEmail Template:\n")
    print(formatted_paragraph)


def Manager_Email():
    # Provided paragraph
    paragraph = '''Good Day,

ENTER TEXT HERE

Thank you.'''

    # User input: Application name and recertification date
    app_name = input("Enter the application name: ")
    recert_date = input("Enter the recertification date (e.g., February 28, 2024): ")

    # Replace placeholders in the paragraph
    formatted_paragraph = paragraph.replace("<Application Name>", app_name).replace("<DATE>", recert_date)

    # Print the formatted email template
    print("\nEmail Template:\n")
    print(formatted_paragraph)
    #Export Formatted paragraph into a txt file 
    
#Selection  of which function to run based on user's input
Selection = int(input("1) SVP&EXEC Email\n2) Manager Email\n3) Follow-Up Email\nWhat script would you like to use: "))

if(Selection == 1):
    Exec_Email()
elif(Selection == 2):
    Manager_Email()
elif(Selection == 3):
    FollowUp_Email()
else:
    print("Invalid Input")