echo off
cd \OpenSSL-dev\openssl-fips-%2

if "%3"=="x64" goto x64

:x86

if "%vstudio%"=="VS2008" call "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" x86
if "%vstudio%"=="VS2012" call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x86
if "%vstudio%"=="VS2013" call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86
if "%vstudio%"=="VS2015" call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
if "%vstudio%"=="VS2017" call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars32.bat"
where cl
set path=%PATH%;"C:\Program Files\NASM"
set PROCESSOR_ARCHITECTURE=x86
if exist \usr\local\ssl rd \usr\local\ssl /s /q
if exist out32dll rd out32dll /s /q
if exist tmp32dll rd tmp32dll /s /q
perl -pi.bak -e "s/pause//gi" ms\do_fips.bat
if exist ms\do_fips.bat.bak del ms\do_fips.bat.bak
call ms\do_fips.bat

cd \OpenSSL-dev\openssl-%1
if exist out32 rd out32 /s /q
if exist out32dll rd out32dll /s /q
if exist tmp32 rd tmp32 /s /q
if exist tmp32dll rd tmp32dll /s /q
perl Configure VC-WIN32 no-asm fips --with-fipsdir=\usr\local\ssl\fips-2.0
call ms\do_ms.bat
for %%f in (ms\*.mak) do perl -pi.bak -e "s/\/Zi/ /gi" %%f
if exist ms\*.mak.bak del ms\*.mak.bak
for %%f in (ms\*.mak) do perl -pi.bak -e "s/\/Zl //gi" %%f
del ms\*.mak.bak
nmake -f ms\ntdll.mak all
nmake -f ms\nt.mak all && nmake -f ms\nt.mak install
nmake -f ms\ntdll.mak install
nmake -f ms\nt.mak test && nmake -f ms\ntdll.mak test
rem use libeaycompat32.lib as libeay32_a.lib
copy out32\libeaycompat32.lib out32\libeay32_a.lib /y
copy out32\libeaycompat32.lib \usr\local\ssl\lib /y
copy out32\libeay32_a.lib \usr\local\ssl\lib /y
copy out32\ssleay32.lib out32\ssleay32_a.lib /y
copy out32\ssleay32_a.lib \usr\local\ssl\lib /y
copy out32dll\libeay32.pdb \usr\local\ssl\bin /y
copy out32dll\ssleay32.pdb \usr\local\ssl\bin /y
copy out32dll\openssl.pdb \usr\local\ssl\bin /y
cd \usr\local\ssl
7z a \OpenSSL\OpenSSL-%1-%4-%3-fips.zip .

goto done

:x64

if "%vstudio%"=="VS2008" call "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" x86_amd64
if "%vstudio%"=="VS2012" call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x86_amd64
if "%vstudio%"=="VS2013" call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86_amd64
if "%vstudio%"=="VS2015" call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86_amd64
if "%vstudio%"=="VS2017" call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"
where cl
set path=%PATH%;"C:\Program Files\NASM"
set PROCESSOR_ARCHITECTURE=AMD64
if exist \usr\local\ssl rd \usr\local\ssl /s /q
if exist out32dll rd out32dll /s /q
if exist tmp32dll rd tmp32dll /s /q
perl -pi.bak -e "s/pause//gi" ms\do_fips.bat
if exist ms\do_fips.bat.bak del ms\do_fips.bat.bak
call ms\do_fips.bat no-asm

cd \OpenSSL-dev\openssl-%1
if exist out32 rd out32 /s /q
if exist out32dll rd out32dll /s /q
if exist tmp32 rd tmp32 /s /q
if exist tmp32dll rd tmp32dll /s /q
perl Configure VC-WIN64A fips --with-fipsdir=\usr\local\ssl\fips-2.0
call ms\do_win64a.bat
for %%f in (ms\*.mak) do perl -pi.bak -e "s/\/Zi //gi" %%f
del ms\*.mak.bak
for %%f in (ms\*.mak) do perl -pi.bak -e "s/\/Zl //gi" %%f
del ms\*.mak.bak
:build
nmake -f ms\ntdll.mak all
xcopy tmp32dll\applink.obj tmp32\ /y
nmake -f ms\nt.mak all && nmake -f ms\nt.mak install
nmake -f ms\ntdll.mak install
nmake -f ms\ntdll.mak test && nmake -f ms\nt.mak test
rem use libeaycompat32.lib as libeay32_a.lib
copy out32\libeaycompat32.lib out32\libeay32_a.lib /y
copy out32\libeaycompat32.lib \usr\local\ssl\lib /y
copy out32\libeay32_a.lib \usr\local\ssl\lib /y
copy out32\ssleay32.lib out32\ssleay32_a.lib /y
copy out32\ssleay32_a.lib \usr\local\ssl\lib /y
copy out32dll\libeay32.pdb \usr\local\ssl\bin /y
copy out32dll\ssleay32.pdb \usr\local\ssl\bin /y
copy out32dll\openssl.pdb \usr\local\ssl\bin /y
7z a \OpenSSL\OpenSSL-%1-%4-%3-fips.zip .

:done