#Config
#Nur wenn hier "action" steht wird konvertiert, sonst nur eine Liste der Files erzeugt
$action="action"
#Wenn hier nicht "WithPrivate" steht, sondern sonst was, werden nur Public-Elemente expotiert
$WithPrivate="xWithPrivate"

#Pfade setzen
#$myDokupath = Get-Item "C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\Zoll\doku"
#$myDokupath = Get-Item "C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\Zoll\doku"
$myDokupath=Split-Path $script:MyInvocation.MyCommand.Path
$myProjectPath = Get-Item ((get-item $myDokupath).parent.FullName )
$myProjectLibPath = Get-Item (join-path $myProjectPath -ChildPath "lib")
$myXmlFilesPath = Get-Item (join-path $myDokupath -ChildPath "xml")
$myRstFilesPath = Get-Item (join-path $myDokupath -ChildPath "source")
$myXMLConverter = Get-Item (join-path $myProjectPath -ChildPath "DevTools\Win32\Debug\XML2RST.exe")
$xsl = join-path $myDokupath -childpath  "ToCPP.xslt"


function AllRstFromXml () {

    $myXmlFiles = $myXmlFilesPath.GetFiles("*.xml")
    foreach ($xml in $myXmlFiles) {
        $base= $xml.BaseName
        SingleRstFromXml($base)
    } 

}

function SingleRstFromXml () {
    param ( [Parameter(Mandatory=$True)] [String]$xml)

    $myUnit = FindUnitForXML($xml)
    $len = $myProjectPath.FullName.Length

    $UnitParentdirPath = $myUnit.Directory.FullName
    $PathOfffset  = $UnitParentdirPath.Substring($len)

    $base= $xml
    $xml = join-path $myXmlFilesPath -childpath  ($xml + ".xml")    

    $output = join-path $myRstFilesPath -childpath $PathOfffset

    #Verzeichnis anlegen, wenn nicht vorhanden
    If(!(test-path -PathType container $output)) {
        New-Item -Path $output -ItemType Directory
    }
    $output = join-path $output -childpath  ($base.ToString() + ".rst")
    & "$myXMLConverter" $action $WithPrivate ""$xml"" ""$output""
    
}

function FindUnitForXML() {
    param ( [Parameter(Mandatory=$True)] [String]$Xml)

    #$nakedName = (Get-Item $Xml).BaseName
    $Anzahl=0    
    foreach ($Unit in $AllUnits) {
        if ($Xml -eq $Unit.BaseName) {
            $Anzahl=$Anzahl+1
            $GefundeneUnit=$Unit    
            if ($Anzahl -gt 1) {
                throw "Mehrere Units passen zu $Xml"
            }
        }
    } 

    return $GefundeneUnit
}


function GetAllUnits () {  
    $myUnits = $myProjectPath.GetFiles("*.pas")
    $myLibUnits = Get-ChildItem -Path $myProjectLibPath -Filter *.pas -Recurse
    $AllUnits = $myUnits + $myLibUnits
    return $AllUnits
}


$AllUnits = GetAllUnits

# AllRstFromXml

# SingleRstFromXml("Logger")
SingleRstFromXml("UnippsStueliPos")