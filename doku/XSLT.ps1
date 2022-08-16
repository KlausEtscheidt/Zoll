#Pfade setzen
#$myDokupath = Get-Item "C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\Zoll\doku"
#$myDokupath = Get-Item "C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\Zoll\doku"
$myDokupath=Split-Path $script:MyInvocation.MyCommand.Path
$myXmlFilesPath = Get-Item (join-path $myDokupath -ChildPath "xml")
$myCppFilesPath = Get-Item (join-path $myDokupath -ChildPath "cpp")
$xsl = join-path $myDokupath -childpath  "ToCPP.xslt"

#$outbasename='Unipps_Pumpen_FA'
#$default_n_days=7

############################################################################
# XSLT: Konvertiert xml+xsl nach HTML 
function xml_to_cpp () {
    param ( [Parameter(Mandatory=$True)] [String]$xml,
            [Parameter(Mandatory=$True)] [String]$xsl,
            [Parameter(Mandatory=$True)] [String]$output)

    try {
        $xslt = New-Object System.Xml.Xsl.XslCompiledTransform;
        $xslt.Load($xsl);
        $xslt.Transform($xml, $output);
       
    }
    catch {
        Write-Host "Fehler beim Transformieren von: $xml"
        Write-Host "Fehler: $($error[0].Exception.Message)"
    }

}


function AllCppFromXml () {

    $myXmlFiles = $myXmlFilesPath.GetFiles("*.xml")
    foreach ($xml in $myXmlFiles) {
        $base= $xml.BaseName
        $output = join-path $myCppFilesPath -childpath  ($base.ToString() + ".cpp")
        xml_to_cpp  $xml.fullname $xsl $output
    } 

}

function SingleCppFromXml () {
    param ( [Parameter(Mandatory=$True)] [String]$xml)

    $base= $xml
    $xml = join-path $myXmlFilesPath -childpath  ($xml + ".xml")    
    $output = join-path $myCppFilesPath -childpath  ($base.ToString() + ".cpp")
    xml_to_cpp  $xml $xsl $output

}


AllCppFromXml
# SingleCppFromXml("Logger")
# SingleCppFromXml("ADOQuery")