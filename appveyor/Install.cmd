@echo off

choco install nasm
choco install unxutils

mkdir \OpenSSL-dev
cd \OpenSSL-dev

echo Downloading https://www.openssl.org/source/openssl-%1.tar.gz
appveyor DownloadFile https://www.openssl.org/source/openssl-%1.tar.gz
tar xvf openssl-%1.tar.gz

echo Downloading https://www.openssl.org/source/openssl-fips-%2.tar.gz
appveyor DownloadFile https://www.openssl.org/source/openssl-fips-%2.tar.gz
tar xvf openssl-fips-%2.tar.gz

