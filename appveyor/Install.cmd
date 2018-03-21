@echo off

choco install nasm
choco install unxutils > nul

mkdir \OpenSSL-dev
cd \OpenSSL-dev

echo Downloading https://www.openssl.org/source/openssl-%1.tar.gz
appveyor DownloadFile https://www.openssl.org/source/openssl-%1.tar.gz
dir openssl-%1.tar.gz
echo Extracting openssl-%1 in \OpenSSL-dev\openssl-%1
C:\cygwin\bin\tar.exe xf openssl-%1.tar.gz

echo Downloading https://www.openssl.org/source/openssl-fips-%2.tar.gz
appveyor DownloadFile https://www.openssl.org/source/openssl-fips-%2.tar.gz
dir openssl-fips-%2.tar.gz
echo Extracting openssl-fips-%2 in \OpenSSL-dev\openssl-fips-%2
C:\cygwin\bin\tar.exe xf openssl-fips-%2.tar.gz
