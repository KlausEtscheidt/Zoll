echo make
call make htmlhelp
echo compile
rem Name digilekdoc entsteht aus conf.py project = 'DigiLek' durch anhängen von doc
rem aus make htmlhelp entsteht digilekdoc.hhp als Eingabe für hhc.exe

"C:\Program Files (x86)\HTML Help Workshop\hhc.exe" build\htmlhelp\digilekdoc.hhp
echo moving
rem hhc.exe erzeugt digilekdoc.chm
copy /Y build\htmlhelp\digilekdoc.chm ..\..\Hilfe
rem move /Y build\htmlhelp\digilekdoc.chm ..\..\Hilfe
pause