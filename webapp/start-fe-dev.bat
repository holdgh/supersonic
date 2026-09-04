@echo off

for /f "delims=" %%i in ('node -v') do set "node_version=%%i"

for /f "tokens=2 delims=v." %%i in ("%node_version%") do set "major_version=%%i"

if %major_version% GEQ 17 (
  set "NODE_OPTIONS=--openssl-legacy-provider"
  echo Node.js version is greater than or equal to 17. NODE_OPTIONS has been set to --openssl-legacy-provider.
)
where /q pnpm
if errorlevel 1 (
  echo pnpm is not installed. Installing...
  npm install -g pnpm
  if errorlevel 1 (
    echo Failed to install pnpm. Please check if npm is installed and the network connection is working.
  ) else (
    echo pnpm installed successfully.
  )
) else (
  echo pnpm is already installed.
)

rmdir /s /q ".\packages\supersonic-fe\src\.umi"
rmdir /s /q ".\packages\supersonic-fe\src\.umi-production"

@REM echo Approve build dependencies ...
@REM call pnpm approve-builds esbuild core-js core-js-pure es5-ext puppeteer-core --all
@REM IF %ERRORLEVEL% NEQ 0 (
@REM     echo approve-builds failed
@REM     pause
@REM     exit /b %ERRORLEVEL%
@REM )

cd ./packages/chat-sdk

call pnpm i

IF %ERRORLEVEL% NEQ 0 (echo chat-sdk install fail & pause & exit /b %ERRORLEVEL%)

call pnpm run build

IF %ERRORLEVEL% NEQ 0 (echo chat-sdk build fail & pause & exit /b %ERRORLEVEL%)

cd ../supersonic-fe

call pnpm i

IF %ERRORLEVEL% NEQ 0 (echo supersonic-fe install fail & pause & exit /b %ERRORLEVEL%)

call pnpm start
