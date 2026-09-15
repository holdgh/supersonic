setlocal
@REM for /f "delims=" %%i in ('node -v') do set "node_version=%%i"
@REM for /f "tokens=2 delims=v." %%i in ("%node_version%") do set "major_version=%%i"
@REM if %major_version% GEQ 17 (
@REM   set "NODE_OPTIONS=--openssl-legacy-provider"
@REM   echo Node.js version is greater than or equal to 17. NODE_OPTIONS has been set to --openssl-legacy-provider.
@REM )
@REM where /q pnpm
@REM if errorlevel 1 (
@REM   echo pnpm is not installed. Installing...
@REM   npm install -g pnpm
@REM   if errorlevel 1 (
@REM     echo Failed to install pnpm. Please check if npm is installed and the network connection is working.
@REM   ) else (
@REM     echo pnpm installed successfully.
@REM   )
@REM ) else (
@REM   echo pnpm is already installed.
@REM )
@REM
@REM rmdir /S /Q .\packages\supersonic-fe\src\.umi
@REM rmdir /S /Q .\packages\supersonic-fe\src\.umi-production
cd ./packages/chat-sdk
@REM call pnpm i
@REM call pnpm run build
@REM call pnpm link --global
cd ../supersonic-fe
@REM call pnpm link ../chat-sdk
call pnpm i
set NODE_OPTIONS=--openssl-legacy-provider
call pnpm run build:os-local
tar -zcvf supersonic-webapp.tar.gz supersonic-webapp
move supersonic-webapp.tar.gz ..\..\
cd ..
endlocal