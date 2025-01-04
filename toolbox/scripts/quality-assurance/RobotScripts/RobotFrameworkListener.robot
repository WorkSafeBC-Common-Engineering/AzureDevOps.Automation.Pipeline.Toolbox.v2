*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Resource   CommonWebPageFunctions.robot

*** Keywords ***
Closing All Opened Browsers
    Close All Browsers

Launching Web Application
    CommonFunction_Launch Application

Implicit Wait
    ${implicitWaitBySel}=         Get Selenium Implicit Wait      #will give default value
    Log To Console                Selenium set implicit wait is ${implicitWaitBySel}
    Set Selenium Implicit Wait    ${implicitWait}
    Log To Console                Automationscript is setting implicit wait is ${implicitWait}
