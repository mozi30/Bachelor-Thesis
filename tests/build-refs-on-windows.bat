rem Copyright (C) 2014-2025 by Thomas Auzinger <thomas@auzinger.name>

rem This file generates all references for compiled document files on Windows.
rem This file is used for convenience and is not part of CI or final usage.

@echo off
set CLASS=vutinfth
set OUTPUT_SUFFIX=-ref
@echo on

copy ..\%CLASS%.dtx .
copy ..\%CLASS%.ins .
copy ..\intro.tex .
copy ..\intro.bib .
xcopy ..\graphics .\graphics /E /I /Y

rem Build vutinfth documentation
pdflatex %CLASS%.dtx
pdflatex %CLASS%.dtx
makeindex -s gglo.ist -o %CLASS%.gls %CLASS%.glo
makeindex -s gind.ist -o %CLASS%.ind %CLASS%.idx
pdflatex %CLASS%.dtx
pdflatex %CLASS%.dtx

rem Build the vutinfth class file
pdflatex ..\%CLASS%.ins

rem Loop through all files matching example-*.tex in the current directory
for %%f in (example-*.tex) do (
    call :BUILD_DOC "%%~nf"
)
goto :END_LOOP

:BUILD_DOC
    setlocal enabledelayedexpansion
    
    set "SOURCE_BASE=%~1"
    set "SOURCE=!SOURCE_BASE!"
    
    echo.
    echo ----------------------------------------------------
    echo Compiling: !SOURCE!.tex
    
    rem Build the test document
    pdflatex !SOURCE!
    bibtex   !SOURCE!
    pdflatex !SOURCE!
    pdflatex !SOURCE!
    makeindex -t !SOURCE!.glg -s !SOURCE!.ist -o !SOURCE!.gls !SOURCE!.glo
    makeindex -t !SOURCE!.alg -s !SOURCE!.ist -o !SOURCE!.acr !SOURCE!.acn
    makeindex -t !SOURCE!.ilg -o !SOURCE!.ind !SOURCE!.idx
    pdflatex !SOURCE!
    pdflatex !SOURCE!
    
    rem Rename the final PDF output
    move /Y "!SOURCE!.pdf" "!SOURCE!!OUTPUT_SUFFIX!.pdf"
    
    endlocal
    goto :eof

:END_LOOP

@echo off
echo.
echo.
echo Class file and all example documents compiled.
pause
