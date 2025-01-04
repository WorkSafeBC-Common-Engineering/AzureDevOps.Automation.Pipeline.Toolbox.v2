# import os

# Below are the configuration settings for running automation scripts in
# different TESTING environments ( DEV ,SYS , STG , PRD ) and in different BROWSERS ( gc , ff )
# either in LOCAL MACHINE or AGENT PIPELINE

# Please update the variable value to 'PIPELINE' in case of check-in the code in your QA Agent pipeline
execution_type = 'LOCAL'
# Please update the variable value to 'gc' in case of running automation scripts in Google Chrome browser in local
# machine
browser_local = 'gc'
# Please update the variable value to 'STG' , 'DEV'  in case of running automation scripts in
# local machine
execution_env_local = 'SYS'
# Please update the variable value to timeout seconds in case of running automation scripts in
# local machine
timeoutSeconds = '7s'
implicitWait = '10s'
# Please update the variable value in QA pipeline in case of running automation scripts in
# Agent machine and also uncomment the variable
# execution_env_pipeline = os.environ["MY_EXECUTIONENV"]
# Please update the variable value in QA pipeline in case of running automation scripts in
# Agent machine and also uncomment the variable
# browser_pipeline = os.environ["MY_BROWSER"]

# Please change the values based on your application.
sysurl = ''
stgurl = ''
prdurl = ''
devurl = ''