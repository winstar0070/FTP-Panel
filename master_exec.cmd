@echo off

rem 호스팅 패널들이 참조하는 곳입니다. 이 파일을 직접적으로 실행하지 마시기 바랍니다.
rem :dset 부분의 서버 파일 다운로드 위치는 적당히 꾸며주시기 바랍니다.

set domain=LocalUser
rem 도메인을 사용하지 않는다면 그대로 두시기 바랍니다.
set hosting=Crong Cloud
title %hosting% 패널
set pid=unknown
color 1f
:req
if not exist %domain%\%usrname%\패널 goto pc
ping -n 1 127.0.0.1>nul
title %usrname%
if not exist %domain%\%usrname%\패널\시작.txt goto svstart
if not exist %domain%\%usrname%\패널\강제종료.txt goto svstop
if not exist %domain%\%usrname%\패널\재시작.txt goto svreboot
if not exist %domain%\%usrname%\패널\기본세팅.txt goto dset
ping -n 1 127.0.0.1>nul
goto req

:svstart
if not "%pid%"=="unknown" echo 이미 실행중입니다! & echo. > %domain%\%usrname%\패널\시작.txt & goto req
if not exist %domain%\%usrname%\bukkit.jar echo 버킷 실행 파일이 없습니다! & echo. > %domain%\%usrname%\패널\시작.txt & goto req
if not exist %domain%\%usrname%\server.properties echo.>%domain%\%usrname%\server.properties & echo server.properties 강제 생성합니다.
set /p pw=<config\pw\%usrname%.txt
rem 포트 가져오기
set /p port=<config\port\%usrname%.txt
echo 현재 포트는 %port%로 설정되어 있습니다.
set /p rport=<config\rport\%usrname%.txt
echo 현재 RCON 포트는 %rport%로 설정되어 있습니다.
set /p mem=<config\memory\%usrname%.txt
echo 현재 메모리는 %mem%M을 할당합니다.
if not exist %domain%\%usrname%\eula.txt echo eula=true>%domain%\%usrname%\eula.txt & echo EULA에 동의 처리했습니다.
if not exist %domain%\%usrname%\pserver.properties goto crcon
echo 서버를 시작합니다.
set usrhome=%~dp0%domain%\%usrname%
set runcmd=cmd /c pushd %usrhome% ^& java -Xmx%mem%M -jar bukkit.jar --config pserver.properties -p %port%
rem set runcmd=cmd /c pushd %usrhome% ^& java -Xmx%mem%M -jar bukkit.jar --config pserver.properties -p %port%
rem PID 구하기 시작
for /f "tokens=2 delims==; " %%a in (' wmic process call create "%runcmd%" ^| find "ProcessId" ') do set pid=%%a
echo "%PID%"
rem PID 구하기 끝
echo 시작이 완료되었습니다.
echo. > %domain%\%usrname%\패널\시작.txt
goto req

:svstop
echo 서버를 강제종료합니다.
taskkill /pid %pid%
echo.>%domain%\%usrname%\패널\강제종료.txt
set pid=unknown
goto req

:svreboot
echo 서버를 재시작합니다.
taskkill /pid %pid%
echo.>%domain%\%usrname%\패널\재시작.txt
set pid=unknown
goto svstart

:dset
taskkill /pid %pid%
set pid=unknown
echo 서버를 세팅합니다.
wget https://path/to/download/spigot.jar --no-check-certificate -O %domain%\%usrname%\bukkit.jar
wget https://path/to/download/server.properties --no-check-certificate -O %domain%\%usrname%\server.properties
echo.>%domain%\%usrname%\패널\기본세팅.txt
set pid=unknown
goto req

:pc
md %domain%\%usrname%\패널\
echo. > %domain%\%usrname%\패널\강제종료.txt
echo. > %domain%\%usrname%\패널\시작.txt
echo. > %domain%\%usrname%\패널\재시작.txt
echo. > %domain%\%usrname%\패널\기본세팅.txt
goto req

:crcon
cd %domain%\%usrname%
copy server.properties pserver.properties
echo enable-rcon=true>>pserver.properties
echo rcon.port=%rport%>>pserver.properties
echo rcon.password=%pw%>>pserver.properties
echo RCON 설정 파일을 만듭니다.
cd ..\..
goto svstart