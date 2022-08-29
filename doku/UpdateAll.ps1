param (
    $Unit='all'
)


#Pfade setzen
$BaseDir=Split-Path $script:MyInvocation.MyCommand.Path
$Index=$BaseDir+'\build\html\index.html'

. .\DelphiXML2RST.ps1 $Unit

. .\RunSphinx.ps1

. "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"  "$Index"
 