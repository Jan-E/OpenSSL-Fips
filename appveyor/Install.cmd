@echo off

choco install nasm

mkdir \OpenSSL
cd \OpenSSL

echo Downloading https://www.openssl.org/source/openssl-%1.tar.gz
appveyor DownloadFile https://www.openssl.org/source/openssl-%1.tar.gz

echo Downloading https://www.openssl.org/source/openssl-fips-%2.tar.gz
appveyor DownloadFile https://www.openssl.org/source/openssl-fips-%2.tar.gz

