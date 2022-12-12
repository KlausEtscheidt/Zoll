echo make
call make htmlhelp
echo compile
"C:\Program Files (x86)\HTML Help Workshop\hhc.exe" build\htmlhelp\digilekdoc.hhp
echo moving
move /Y build\htmlhelp\digilekdoc.chm ..\..\win32\sqlite
pause