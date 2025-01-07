# This file is for your refernce to execute health check in pipeline for given application based on Reusable Robot Framework.
*** Settings ***
Library                 SeleniumLibrary
Resource                RobotFrameworkListener.robot
Resource                CommonWebElementFunctions.robot
Resource                CommonWebPageFunctions.robot
Suite Setup             Launching Web Application
Suite Teardown          Closing All Opened Browsers

*** Variables ***
${header}                              //*[contains(text(),'Email us')]
${radio_optionRegistration}            //*[contains(text(),'Registration, coverage, Personal Optional Protection')]

*** Test Cases ***
Test Case 1
    [Setup]                         Log       ******** Name of the Test Case : ${TEST NAME} *******
    Set Test Documentation          This is sample automation script for automation pipeline implmentation.
    Set Test Documentation          Test Scenario : open GEMS url in systest and check the application is avaialble to end user.
    [Tags]                          Smoke
    Verify Label using xPath        ${header}
    Click WebElement using xPath    ${radio_optionRegistration}
