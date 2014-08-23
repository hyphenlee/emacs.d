@echo off


@REM add unix-shell-tools
if "%PROGRAMW6432%" == "" goto WIN32_CONFIG

:WIN64_CONFIG
set PATH=C:\Program Files (x86)\Git\bin;%PATH%
goto WIN_CONFIG_END

:WIN32_CONFIG
set PATH=C:\Program Files\Git\bin;%PATH%

:WIN_CONFIG_END


@REM generate file list
set GTAGS_BASE_DIRECTORY=%~dp0
set GTAGS_BASE_DIRECTORY=%GTAGS_BASE_DIRECTORY:\=/%

@REM collect all file list
dir /A:-d /B /S *.h *.cpp *.hpp *.hxx *.c > filelist.txt

@REM change path separator from "\" to "/"
cat filelist.txt | sed -e "s/\\\\/\\//g" > filelist.tmp   && rm filelist.txt && mv filelist.tmp filelist.txt


@REM exclude some directory
cat filelist.txt | grep -i -v "/wolvtest/" > filelist.tmp && rm filelist.txt && mv filelist.tmp filelist.txt
cat filelist.txt | grep -i -v "/release/"  > filelist.tmp && rm filelist.txt && mv filelist.tmp filelist.txt


@REM generate gtags
set GTAGSFORCECPP=1
e:/Tools/Emacs/.emacs.d/extra-bin/gtags/gtags.exe --file filelist.txt




