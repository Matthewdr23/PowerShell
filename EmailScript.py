# The purpose of this script is to automate the process of creating a body for the email that is to be sent out to people during a recert

def FollowUp_Email():
    #provided paragraph
    Subject = "<Application Name> Semi-Annual Recertification"
    paragraph = '''
    Ref:<Application Name>

Hi ,

We are currently conducting an access recertification of the <Application Name> application, and have not received a reply from you for users listed above.   Can you please access SailPoint using the link below and certify the users’ who report directly to you?

Everest’s security policy would be to revoke access, which can be disruptive.

I would greatly appreciate if this can be processed today.  The recert can not close until we hear from you or the end user’s access is removed.

Please follow the below steps to complete your review.
1.	Here’s the link  https://everestre.identitynow.com/
2.	Login to SailPoint and navigate to Certification’s tab
3.	Under Active tab, click on the campaign name.

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

The purpose of this message is to ask for your prompt assistance in the semi-annual recertification of the <Application Name> application. The access recertification process is an important security control for Everest, as it is a key metric used to demonstrate Sarbanes-Oxley (SOX) compliance in the Financial Industry.

In the coming days, we will be asking managers in your area to review the accounts and permissions that their direct reports currently have in the <Application Name> application. We have also identified one or more active users of this application that report directly to you.

If you do not believe that you are the appropriate reviewer for this application, we can make arrangements to delegate the review to someone in your group who would be better able to complete it. Please let us know who you would like to certify access for your direct reports and we will direct the request appropriately.

If you are comfortable proceeding as the reviewer, you will receive an e-mail from _Security and Access Recertification_ (recert@EverestGlobal.com) with instructions on how to complete the review. For each of your reports, we will ask you to approve or revoke continued access in this application.

Due to the SOX reporting and auditing timeline requirements, we need to complete this recertification by <DATE>, and will need to revoke access in the case of a lack of response by the end date.  _Please do not rely on an employees’ access being removed due to non-response.  Several follow up emails are sent before access is removed this way which can be very time consuming._

We would like to make this process as efficient and easy for you as possible and we’re ready to help in the case of any confusion or difficulty. Please do not hesitate to contact me using via e-mail or phone should you need any assistance. Thank you in advance for your participation in this important process.

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

The purpose of this message is to ask for your prompt assistance in the semi-annual recertification of the <Application Name> application. The access recertification process is an important security control for Everest, as it is a key metric used to demonstrate Sarbanes-Oxley (SOX) compliance in the Financial Industry.

In the coming days, we will be asking you to review the accounts and permissions that your direct reports currently have in the <Application Name> application. You will receive an e-mail from Security and Access Recertification ([recert@EverestGlobal.com](mailto:recert@EverestGlobal.com)) with instructions on how to complete the review. For each of your reports, we will ask you to approve or revoke continued access in this application.

Due to the SOX reporting and auditing timeline requirements, we need to complete this recertification by <DATE>, and will need to revoke access in the case of a lack of response by the end date. Please do not rely on an employees’ access being removed due to non-response. Several follow up emails are sent before access is removed this way which can be very time consuming.

We would like to make this process as efficient and easy for you as possible and we’re ready to help in the case of any confusion or difficulty. Please do not hesitate to contact me using via e-mail or phone should you need any assistance. Thank you in advance for your participation in this important process.

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