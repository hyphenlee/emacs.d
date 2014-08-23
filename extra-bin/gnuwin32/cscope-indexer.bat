@echo off & setlocal enableextensions
REM ******************************************************************
REM Not responsible for any loss resulting from the use of this script
REM ******************************************************************
REM sed and grep should be installed and in PATH
REM those windows version can be installed via MSYS package (http://www.mingw.org/wiki/MSYS)

set n=0
set recursive=0
set listonly=0
set verbose=0

set LIST_FILE=""
set DATABASE_FILE=""
set param="%*%"

:LOOP
if "%~1" == "" goto PROCESS
if "%~1" == "-r" goto RECURSE
if "%~1" == "-i" goto LISTFILE
if "%~1" == "-f" goto CSCOPEOUT
if "%~1" == "-l" goto LISTONLY
if "%~1" == "-v" goto VERBOSE
shift
goto LOOP

:RECURSE
set recursive=1
shift
goto LOOP

:LISTFILE
shift
set LIST_FILE="%~1"
shift
goto LOOP

:CSCOPEOUT
shift
set DATABASE_FILE="%~1"
shift
goto LOOP

:LISTONLY
set listonly=1
shift
goto LOOP

:VERBOSE
set verbose=1
shift
goto LOOP

:PROCESS
IF %verbose%==1 echo cscope-indexer args: %param%
IF %recursive%==1 goto GET_RECURSE_SRC
dir /B > %LIST_FILE%.tmp
goto CSCOPE

:GET_RECURSE_SRC
dir /S /B > %LIST_FILE%.tmp
goto CSCOPE

:CSCOPE
IF %listonly%==1 goto ALMOST_DONE

grep -i -E "\.([chly](xx|pp)*|cc|hh)$" %LIST_FILE%.tmp | sed -e "s/^/\"/;s/$/\"/" > %LIST_FILE%
cscope -b -i %LIST_FILE% -f %DATABASE_FILE%
goto DONE

:ALMOST_DONE
grep -i -E "\.([chly](xx|pp)*|cc|hh)$"  %LIST_FILE%.tmp > %LIST_FILE%
goto DONE

:DONE
del "%LIST_FILE%.tmp"
echo Done                                            