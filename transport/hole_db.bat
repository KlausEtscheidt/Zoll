c:
cd "C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\Zoll"
del data\db\lekl_bck.db
rename data\db\lekl.db lekl_bck.db
copy transport\lekl.db data\db\
pause