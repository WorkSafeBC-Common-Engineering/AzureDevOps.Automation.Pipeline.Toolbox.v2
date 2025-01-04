# This file is for your refernce to understand reusable keyword usage.
*** Settings ***
Library                 SeleniumLibrary
Resource                RobotFrameworkListener.robot
Resource                CommonWebElementFunctions.robot
Resource                CommonWebPageFunctions.robot
Suite Setup             Launching Web Application
Suite Teardown          Closing All Opened Browsers

*** Variables ***
${input_EmployerID}             search-employer-id
${testdata_EmplID}              200786894
${button_Search}                //*[@name='btnGoToEmployerEM']
${icon_EditEmployer}            //*[@title='Edit Employer Information']
${tab_Location}                 EmployerInformationTabStrip-tab-2
${icon_EditEmployerLocation}    //*[@title='Edit Employer Location']
${button_EditMailingAddress}    //*[@id='btnEditMailingAddress']
${input_Line1}                  //*[@id='Line1']
${testdata_AddressLine1}        6800 westminster hwy
${testdata_AddressLine1_New}    6800 Westminster hwy
${input_City}                   //*[@name='City']
${testdata_City}                Richmond
${input_PostalCode}             PostalCode
${testdata_PostalCode}          V7C1C5
${testdata_PostalCode_New}      V7C 1C5
${button_Save}                  btnSave
${button_Cancel}                btnCancel

*** Keywords ***
# This is the example of Keyword to show - Creation of On demand Keyword incase you would like to create one based on your need.
Switching mouse foucs to New Opened Window
    Switch Window        NEW
    ${TITLE}=      Get Title
    Log To Console    ${TITLE}

*** Test Cases ***
Test Case 1
    [Setup]                         Log       ******** Name of the Test Case : ${TEST NAME} *******
    Set Test Documentation          This is sample automation script for automation guideline implmentation.
    Set Test Documentation          Test Scenario : Search Employer and edit mailing address first time
    [Tags]                          Smoke
    Send input in WebElement        ${input_EmployerID}      ${testdata_EmplID}
    Click WebElement using xPath    ${button_Search}
    Click WebElement using xPath    ${icon_EditEmployer}
    Switching mouse foucs to New Opened Window
    Click WebElement using HTML Id  ${tab_Location}
    Click WebElement using xPath    ${icon_EditEmployerLocation}
    Click WebElement using xPath    ${button_EditMailingAddress}
    Click WebElement using xPath    ${input_Line1}
    Send input in WebElement        ${input_Line1}           ${testdata_AddressLine1}
    Send input in WebElement        ${input_City}            ${testdata_City}
    Send input in WebElement        ${input_PostalCode}      ${testdata_PostalCode}
    Click WebElement using HTML Id  ${button_Save}
    Click WebElement using HTML Id  ${button_Cancel}

Test Case 2
    [Setup]                         Log       ******** Name of the Test Case : ${TEST NAME} *******
    Set Test Documentation          This is sample automation script for automation guideline implmentation.
    Set Test Documentation          Test Scenario : edit mailing address second time
    [Tags]                          Regression
    Send input in WebElement        ${input_Line1}           ${testdata_AddressLine1_New}
    Send input in WebElement        ${input_PostalCode}      ${testdata_PostalCode_New}
    Click WebElement using HTML Id  ${button_Save}

Test3
   Implicit Wait