*** Settings ***
Library     SeleniumLibrary
Library     AutoItLibrary
Library     OperatingSystem
Library     Collections
Library     XML
Variables   CommonGlobalVariables.py

*** Variables ***
#${timeoutSeconds}        7s   # Currently it is being set in CommonGlobalVariable file.

#WARN
#..Used to display warnings. They shown also in the console and in the Test Execution Errors section in log files,
#..but they do not affect the test case status.

*** Keywords ***
Click WebElement using xPath
   [Documentation]
    ...      Description : 	The custom keyword is useful to CLICK on the web element
    ...      Input      :   It needs xPath to detect WebElement.
   [Arguments]     ${XPath}
   TRY
       Wait Until Page Contains Element    ${XPath}      ${timeoutSeconds}     Pre-requisite is not met : UnAble to find WebElement in given timelimit on the Page, using xPath - ${XPath}
       Click element        ${XPath}
       Log     Able to click WebElement, using xPath - ${XPath}
   EXCEPT
       Click WebElement using Java script       ${XPath}
   FINALLY
       Capture Page Screenshot
   END

Click WebElement using HTML Id
    [Documentation]
    ...      Description : 	The custom keyword is useful to CLICK on the web element
    ...      Input      :   It needs HTML ID to detect WebElement.
   [Arguments]     ${id}
   TRY
       Wait Until Page Contains Element    ${id}      ${timeoutSeconds}        Pre-requisite is not met : UnAble to find WebElement in given timelimit on the Page, using html id - ${id}
       Click element        ${id}
       Log          Able to click WebElement, using ID of WebElement - ${id}
   EXCEPT
       Log          HTML ID of WebElement - ${id} is not correct        WARN
   FINALLY
       Capture Page Screenshot
   END

Click WebElement using Java script
   [Documentation]
    ...      Description : 	The custom keyword is useful to CLICK on the web element via JavaScript
    ...      Input      :   It needs xPath to detect WebElement.
   [Arguments]     ${XPath}
   TRY
      Execute Javascript      document.evaluate("${XPath}",document,null,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue.click();
      Log    WebElement - ${XPath} is visible and Javascript is executed successfully.
   EXCEPT
      Log    Javascript execution - unsuccessfull       WARN
   END

Send input in WebElement
   [Documentation]
    ...      Description : 	The custom keyword is useful to INPUT the TESTDATA
    ...                     using HTML ID / XPATH of web element
    ...      Input      :   It needs HTML ID / XPATH to detect WebElement and testData as INPUT
   [Arguments]     ${webElement}     ${testData}
   TRY
        Wait Until Page Contains Element    ${webElement}      ${timeoutSeconds}        Pre-requisite is not met : UnAble to find WebElement in given timelimit on the Page, using ${webElement}
        Input Text    ${webElement}     ${testData}
        Log    Report Message : Successfully entered value ${testData} into Web Element having ${webElement}
   EXCEPT
        Log    WebElement - ${webElement} is not correct        WARN
   FINALLY
        Capture Page Screenshot
   END

# need to fix below keyword - feedback
Select Drop Down
   [Documentation]
   ...    Description : The custom keyword is useful to scroll to element and click on it.
   ...                  It will retry for maximum 8 times for failed attempts.
   ...                  It is based on drop down Index or Value with 7 times retries
   ...    Input : It needs dropDownType as Input for detecting either 'Index' or 'Value' and drop down xpath
   ...    Input : It needs dropDownTypeValue as Input for keeping value of 'Index' or 'Value'
   [Arguments]     ${dropDownType}       ${dropDownXPath}          ${dropDownTypeValue}
   ${i}=  Set Variable    0
   Wait Until Page Contains Element    ${dropDownXPath}      ${timeoutSeconds}        Pre-requisite is not met : UnAble to find WebElement in given timelimit on the Page, using xPath - ${dropDownXPath}
   FOR    ${i}    IN RANGE    0    8    1
       TRY
            Run Keyword If    '${dropDownType}'=='Index'
            ...    Run Keywords    Select From List By Index   ${dropDownXPath}       ${dropDownTypeValue}  AND   Log    Drop Down Index value is correct
            ...  ELSE IF    '${dropDownType}'=='Value'
            ...    Run Keywords    Select From List By Value   ${dropDownXPath}       ${dropDownTypeValue}  AND   Log    Drop Down List value is correct
            Exit For Loop
       EXCEPT
         Log       Exception caught and looping again ${i} to selct value from drop down        WARN
       FINALLY
         Capture Page Screenshot
       END
   END

ClickWebElement_XPath_7retries
   [Documentation]
   ...    Description   : The custom keyword is useful to scroll to element and click on it.
   ...                    It will retry for maximum 8 times for failed attempts.
   ...    Input         : It needs xPath as Input for detecting the web element
   [Arguments]     ${XPath}
   ${i}=    Set Variable      0
   Wait Until Page Contains Element    ${XPath}      ${timeoutSeconds}        Pre-requisite is not met : UnAble to find WebElement in given timelimit on the Page, using XPath - ${XPath}
   FOR    ${i}    IN RANGE    0    8    1
       TRY
           Scroll Element Into View    ${XPath}
           Click Element    ${XPath}
           Exit For Loop
       EXCEPT
           Log          Exception caught and looping again ${i} to click            WARN
       FINALLY
           Capture Page Screenshot
       END
   END

Typing keys from keyboard
   [Documentation]
    ...      Description : 	The custom keyword is useful to SEND the TESTDATA to simulates the user pressing key(s)
    ...                     using HTML ID of web element
    ...      Input      :   It needs xPath to detect WebElement and testData which is representation of keys as Input
   [Arguments]     ${xPath}     ${testData}
   TRY
       Wait Until Page Contains Element    ${xPath}      ${timeoutSeconds}        Pre-requisite is not met : UnAble to find WebElement in given timelimit on the Page, using html id - ${xPath}
       Press Keys    ${xPath}     ${testData}     # Sends string ${testData} to element having xPath.
       Log    Report Message : Successfully simulated keys having value ${testData} into Web Element having html xpath ${xPath}
   EXCEPT
       Log    XPath of WebElement - ${xPath} is not correct         WARN
   FINALLY
       Capture Page Screenshot
   END

Typing keys from keyboard using WebElement HTML id
   [Documentation]
    ...      Description : 	The custom keyword is useful to SEND the TESTDATA to simulates the user pressing key(s)
    ...                     using HTML ID of web element
    ...      Input      :   It needs HTML ID to detect WebElement and testData which is representation of keys as Input
   [Arguments]     ${id}     ${testData}
   TRY
        Wait Until Page Contains Element    ${id}      ${timeoutSeconds}        Pre-requisite is not met : UnAble to find WebElement in given timelimit on the Page, using html id - ${id}
        Press Keys    ${id}     ${testData}
        Log    Report Message : Successfully simulated keys having value ${testData} into Web Element having html id ${id}
   EXCEPT
        Log    HTML ID of WebElement - ${id} is not correct        WARN
   FINALLY
        Capture Page Screenshot
   END

Send input from keyboard Keys
   [Documentation]
    ...      Description : 	The custom keyword is useful to SEND the TESTDATA using KEYBOARD
    ...                     without knowing the XPATH or HTML ID of web element
    ...      Input      :   It needs testData which is representation of keys as Input
   [Arguments]     ${testData}
   TRY
      Send    ${testData}
   EXCEPT
      Log     Send key is not working in given page.     WARN
   FINALLY
      Capture Page Screenshot
   END

Explicit wait for Web Element to be visible using xpath
   [Documentation]
    ...      Description : 	The custom keyword is useful to wait for the web element to be present on the page
    ...      Input      :   It needs web element locator
   [Arguments]     ${xPath}
   TRY
      Wait Until Page Contains Element    ${xPath}
   EXCEPT
      Wait Until Element Is Visible       ${xPath}
   FINALLY
      Capture Page Screenshot
   END

Explicit wait for Web Element to be visible using HTML Id
   [Documentation]
    ...      Description : 	The custom keyword is useful to wait for the web element to be present on the page
    ...      Input      :   It needs web element locator
   [Arguments]     ${id}
  TRY
       Wait Until Page Contains Element    ${id}
  EXCEPT
       Wait Until Element Is Visible       ${id}
  FINALLY
       Capture Page Screenshot
  END

Verify Label using xPath
   [Documentation]
    ...      Description : 	The custom keyword is useful to verify the text/label to be present on the page
    ...      Input      :   It needs web element locator
   [Arguments]     ${xPath}
  TRY
       Wait Until Page Contains Element    ${XPath}      ${timeoutSeconds}     Pre-requisite is not met : UnAble to find TEXT in given timelimit on the Page, using xPath - ${XPath}
       Page Should Contain Element        ${XPath}
       Log     Able to find TEXT, using xPath - ${XPath}
  EXCEPT
       Wait Until Element Is Visible       ${XPath}     ${timeoutSeconds}
       Log     Able to find TEXT, using xPath - ${XPath}
  FINALLY
       Capture Page Screenshot
  END