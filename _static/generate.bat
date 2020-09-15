@echo off
echo Initiate Conversion
cls
set curfldr=%cd%
echo.
echo.
echo Removing old generated files
echo ============================
rd /S /Q ..\Output\xml
rd /S /Q ..\Output\html
rd /S /Q ..\Output\dita
rd /S /Q ..\Output\latex
echo Removing old generated files - Done!
echo ====================================




echo Clone Libraries from the Xilinx GitEnterprise Server - Done!
echo ============================================================



echo.
echo.
echo Execute Doxygen - Initiate
echo ===========================
doxygen Doxyfile
echo Execute Doxygen - Done!
echo ===========================



echo.
echo.
echo Merging Doxygen output files into one. Initiating...
echo ====================================================
copy combine.xsl ..\Output\xml\combine.xslt
transform.exe -s:..\Output\xml\index.xml -xsl:..\Output\xml\combine.xslt -o:..\Output\xml\all.xml
echo Merging Doxygen output files into one. Completed!
echo ==================================================

echo Creating DITA Map and Topics. Initiating...
echo ============================================
mkdir ..\Output\dita
copy autoapi.xsl ..\Output\dita\autoapi.xsl 
cd ..\Output\dita
Transform.exe -s:..\xml\all.xml -xsl:autoapi.xsl 
del autoapi.xsl
cd ..\..\Generate
echo Creating DITA Map and Topics. Completed!
echo =========================================

@echo off
echo Conversion Done!
@echo on
