#Pfade setzen
$BaseDir=Split-Path $script:MyInvocation.MyCommand.Path
$Index=$BaseDir+'\build\html\index.html'

Start-Process make.bat html -Wait -NoNewWindow   
#. "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"  "$Index"