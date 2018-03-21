@echo off
call "%vs120comntools%vsvars32.bat"
cd \OpenSSL-dev\openssl-fips-%2

:x64

set PROCESSOR_ARCHITECTURE=AMD64
rd \usr\local\ssl /s /q
rd out32dll /s /q
rd tmp32dll /s /q
call ms\do_fips.bat %1
for %%f in (ms\*.mak) do perl -pi.bak -e "s/\/Zi //gi" %%f
if exist ms\*.mak.bak del ms\*.mak.bak
rd out32dll /s /q
rd tmp32dll /s /q
nmake -f ms\ntdll.mak install
