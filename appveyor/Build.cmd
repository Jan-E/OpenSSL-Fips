@echo off
call "%vs120comntools%vsvars32.bat"
cd \OpenSSL-dev\openssl-fips-%2

:x64

set PROCESSOR_ARCHITECTURE=AMD64
if exist \usr\local\ssl rd \usr\local\ssl /s /q
if exist out32dll rd out32dll /s /q
if exist tmp32dll rd tmp32dll /s /q
perl -pi.bak -e "s/pause//gi" ms\do_fips.bat
if exist ms\do_fips.bat.bak del ms\do_fips.bat.bak
call ms\do_fips.bat
for %%f in (ms\*.mak) do perl -pi.bak -e "s/\/Zi //gi" %%f
if exist ms\*.mak.bak del ms\*.mak.bak
rd out32dll /s /q
rd tmp32dll /s /q
nmake -f ms\ntdll.mak install
