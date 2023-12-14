echo make
call make htmlhelp
echo compile
rem Name digilek_datenbankdoc entsteht aus conf.py project = 'DigiLek_Datenbank' durch anhängen von doc
rem aus make htmlhelp entsteht digilek_datenbankdoc.hhp als Eingabe für hhc.exe
"C:\Program Files (x86)\HTML Help Workshop\hhc.exe" build\htmlhelp\digilek_datenbankdoc.hhp
echo moving
rem hhc.exe erzeugt digilek_datenbankdoc.chm
copy /Y build\htmlhelp\digilek_datenbankdoc.chm .
rem move /Y build\htmlhelp\digilekdoc.chm ..\..\Hilfe
pause