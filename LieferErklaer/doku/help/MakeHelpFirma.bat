echo make
call make htmlhelp
echo compile
"C:\Program Files (x86)\HTML Help Workshop\hhc.exe" build\htmlhelp\digilekdoc.hhp
echo moving
rem move /Y build\htmlhelp\digilekdoc.chm ..\..\win32\Access
pause