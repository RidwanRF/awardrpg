@echo on>meta.xml
@echo off
break > meta.xml
echo ^<meta^> >> meta.xml
echo 	^<oop^>true^</oop^> >> meta.xml
echo. >> meta.xml
echo 	^<script src="client.lua" type="client"/^> >> meta.xml
echo. >> meta.xml
setlocal enabledelayedexpansion
set "parentfolder=%CD%\"
for /r . %%g in (*.png) do (
  set "var=%%g"
  set var=!var:%parentfolder%=!
  echo 	^<file src=^"!var!^" download=^"false^" /^> >> meta.xml
)
echo ^</meta^> >> meta.xml
pause