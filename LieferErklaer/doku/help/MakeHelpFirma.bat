echo make
call make htmlhelp
echo compile
"C:\Program Files (x86)\HTML Help Workshop\hhc.exe" build\htmlhelp\digilekdoc.hhp
echo moving
copy /Y build\htmlhelp\digilekdoc.chm ..\..\Hilfe
rem move /Y build\htmlhelp\digilekdoc.chm ..\..\Hilfe
pause