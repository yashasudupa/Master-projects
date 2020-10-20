@echo off
Setlocal EnableDelayedExpansion

:: test if git is in path
:native
set git=c:\progra~1\git\bin\git
::echo testing whether git: %git%
%git% --version >nul || GOTO git32on64
goto gitset

:git32on64
set git=c:\progra~2\git\bin\git
::echo testing whether git: %git%
%git% --version >nul || GOTO jenkins
goto gitset

:jenkins
set git=D:\tools\Git\bin\git
echo testing whether git: %git%
%git% --version >nul || GOTO gitnotfound
goto gitset

:gitset

for /f "delims=" %%a in ('%git% desc') do set hash=%%a
echo \gdef\GITAbrHash{%hash%}
%git% log -1 --format="format:\gdef\GITShortDate{%%ad}" --date=short
echo.
%git% log -1 --format="format:\gdef\GITAuthorDate{%%ad}" --date=rfc2822
echo.
%git% log -1 --format="format:\gdef\GITAuthorName{%%an}"
echo.
echo \gdef\versionInfo{Git version \GITAbrHash{} last change \GITAuthorDate{} by \GITAuthorName{}}

goto end

:gitnotfound
::	>&2	-> redirect to stderr
echo Git not found >&2
echo \gdef\versionInfo{Git program not found in system path}

:end
