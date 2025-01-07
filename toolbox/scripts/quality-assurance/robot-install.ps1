# Upgrade pip and install required packages
[Net.ServicePointManager]::SecurityProtocol = "tls12"
python -m pip install --upgrade pip --trusted-host pypi.org --trusted-host files.pythonhosted.org 
pip install robotframework==5.0.1  --trusted-host pypi.org --trusted-host files.pythonhosted.org 
pip install robotframework-seleniumlibrary==6.0.0 --trusted-host pypi.org --trusted-host files.pythonhosted.org

#Install Chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#Install browsers
choco install firefox -y --force
choco install googlechrome -y --force
choco install microsoft-edge -y --force

Write-Output "Firefox Version" (Get-Item "C:\Program Files\Mozilla Firefox\firefox.exe").VersionInfo.ProductVersion
Write-Output "Chrome Version" (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion

#Install webdrivers
choco install selenium-all-drivers -y --force
choco install selenium-chromium-edge-driver -y --force
choco install selenium-chrome-driver -y --force

geckodriver.exe --version
chromedriver.exe --version
msedgedriver.exe --version