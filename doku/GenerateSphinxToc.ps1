#Pfade setzen
$BaseDir=Split-Path $script:MyInvocation.MyCommand.Path
$DokuSourceBase=Get-Item($BaseDir+'\source')

function GenTocSubDir() {
    param ( [string] $Dir2Search,
            [string] $SubDir)
    $newDir = get-item(join-path $Dir2Search -ChildPath $SubDir)
    $SubDirs = Get-ChildItem -path $newDir
    foreach ($SDir in $SubDirs) {
        GenToc $SDir
    }
    GenToc($newDir)
}

function GenToc() {
    param ( [Parameter(Mandatory=$True)] $Dir2Search)

    $TocFile = $Dir2Search.Fullname + "\toc.rst"
    ".. toctree::" | Out-File -FilePath $TocFile
    "   :caption: "+$Dir2Search.BaseName | Out-File -FilePath $TocFile -append
    $RstFiles=$Dir2Search.GetFiles("*.rst")
    foreach ($rst in $RstFiles) {
        $base= $rst.BaseName
        write-host $base
        "   $base" | Out-File -FilePath $TocFile -append
    } 
}

GenToc($DokuSourceBase)
GenTocSubDir $DokuSourceBase "\lib"