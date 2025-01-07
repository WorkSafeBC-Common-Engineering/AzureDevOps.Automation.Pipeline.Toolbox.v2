*** Settings ***
Variables  CommonGlobalVariables.py
Library    SeleniumLibrary
Library    AutoItLibrary
#Library    CryptoLibrary
Library    OperatingSystem
Library    String
Library    DateTime
Library    Collections

*** Keywords ***
CommonFunction_Launch Application
    [Documentation]
    ...      Description : 	We are trying to launch browser in incognito mode.
	...                     It will take type of execution - LOCAL or PIPELINE
	...                     Based on condition it will select the url - commonglobalVariables.py file
   TRY
     Run Keyword If    '${execution_type}'=='LOCAL'       Opening secific environment URL - Local Machine
     Run Keyword If    '${execution_type}'=='PIPELINE'    Opening secific environment URL - Pipeline Agent
   EXCEPT
      Log    Try block is not working in the kwyword       FAIL
   FINALLY
      Capture Page Screenshot
   END

Opening secific environment URL - Local Machine
    Run Keyword If   '${execution_env_local}'=='STG'
    ...    Run Keyword    Open application in local browser      ${app_stgurl}
    ...  ELSE IF    '${execution_env_local}'=='SYS'
    ...    Run Keyword    Open application in local browser      ${app_sysurl}
    ...  ELSE IF    '${execution_env_local}'=='DEV'
    ...    Run Keyword    Open application in local browser      ${app_devurl}
    ...  ELSE IF    '${execution_env_local}'=='PRD'
    ...    Run Keyword    Open application in local browser      ${app_prdurl}

Open application in local browser
    [Arguments]         ${keywordurl}
    Open Browser    ${keywordurl}    ${browser_local}
    Maximize Browser Window
    Log   Application ${keywordurl} is launched in ${browser_local} browser.    console=yes

Opening secific environment URL - Pipeline Agent
    Run Keyword If   '${execution_env_pipeline}'=='STG'
    ...    Run Keyword    Open application in agent browser      ${app_stgurl}
    ...  ELSE IF    '${execution_env_pipeline}'=='SYS'
    ...    Run Keyword    Open application in agent browser      ${app_sysurl}
    ...  ELSE IF    '${execution_env_pipeline}'=='DEV'
    ...    Run Keyword    Open application in agent browser      ${app_devurl}
    ...  ELSE IF    '${execution_env_pipeline}'=='PRD'
    ...    Run Keyword    Open application in agent browser      ${app_prdurl}

Open application in agent browser
    [Arguments]         ${keywordurl}
    Open Browser    ${keywordurl}    ${browser_pipeline}
    Maximize Browser Window
    Log   Application ${keywordurl} is launched in ${browser_pipeline} browser.    console=yes