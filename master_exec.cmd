@echo off

rem ȣ���� �гε��� �����ϴ� ���Դϴ�. �� ������ ���������� �������� ���ñ� �ٶ��ϴ�.
rem :dset �κ��� ���� ���� �ٿ�ε� ��ġ�� ������ �ٸ��ֽñ� �ٶ��ϴ�.

set domain=LocalUser
rem �������� ������� �ʴ´ٸ� �״�� �νñ� �ٶ��ϴ�.
set hosting=Crong Cloud
title %hosting% �г�
set pid=unknown
color 1f
:req
if not exist %domain%\%usrname%\�г� goto pc
ping -n 1 127.0.0.1>nul
title %usrname%
if not exist %domain%\%usrname%\�г�\����.txt goto svstart
if not exist %domain%\%usrname%\�г�\��������.txt goto svstop
if not exist %domain%\%usrname%\�г�\�����.txt goto svreboot
if not exist %domain%\%usrname%\�г�\�⺻����.txt goto dset
ping -n 1 127.0.0.1>nul
goto req

:svstart
if not "%pid%"=="unknown" echo �̹� �������Դϴ�! & echo. > %domain%\%usrname%\�г�\����.txt & goto req
if not exist %domain%\%usrname%\bukkit.jar echo ��Ŷ ���� ������ �����ϴ�! & echo. > %domain%\%usrname%\�г�\����.txt & goto req
if not exist %domain%\%usrname%\server.properties echo.>%domain%\%usrname%\server.properties & echo server.properties ���� �����մϴ�.
set /p pw=<config\pw\%usrname%.txt
rem ��Ʈ ��������
set /p port=<config\port\%usrname%.txt
echo ���� ��Ʈ�� %port%�� �����Ǿ� �ֽ��ϴ�.
set /p rport=<config\rport\%usrname%.txt
echo ���� RCON ��Ʈ�� %rport%�� �����Ǿ� �ֽ��ϴ�.
set /p mem=<config\memory\%usrname%.txt
echo ���� �޸𸮴� %mem%M�� �Ҵ��մϴ�.
if not exist %domain%\%usrname%\eula.txt echo eula=true>%domain%\%usrname%\eula.txt & echo EULA�� ���� ó���߽��ϴ�.
if not exist %domain%\%usrname%\pserver.properties goto crcon
echo ������ �����մϴ�.
set usrhome=%~dp0%domain%\%usrname%
set runcmd=cmd /c pushd %usrhome% ^& java -Xmx%mem%M -jar bukkit.jar --config pserver.properties -p %port%
rem set runcmd=cmd /c pushd %usrhome% ^& java -Xmx%mem%M -jar bukkit.jar --config pserver.properties -p %port%
rem PID ���ϱ� ����
for /f "tokens=2 delims==; " %%a in (' wmic process call create "%runcmd%" ^| find "ProcessId" ') do set pid=%%a
echo "%PID%"
rem PID ���ϱ� ��
echo ������ �Ϸ�Ǿ����ϴ�.
echo. > %domain%\%usrname%\�г�\����.txt
goto req

:svstop
echo ������ ���������մϴ�.
taskkill /pid %pid%
echo.>%domain%\%usrname%\�г�\��������.txt
set pid=unknown
goto req

:svreboot
echo ������ ������մϴ�.
taskkill /pid %pid%
echo.>%domain%\%usrname%\�г�\�����.txt
set pid=unknown
goto svstart

:dset
taskkill /pid %pid%
set pid=unknown
echo ������ �����մϴ�.
wget https://path/to/download/spigot.jar --no-check-certificate -O %domain%\%usrname%\bukkit.jar
wget https://path/to/download/server.properties --no-check-certificate -O %domain%\%usrname%\server.properties
echo.>%domain%\%usrname%\�г�\�⺻����.txt
set pid=unknown
goto req

:pc
md %domain%\%usrname%\�г�\
echo. > %domain%\%usrname%\�г�\��������.txt
echo. > %domain%\%usrname%\�г�\����.txt
echo. > %domain%\%usrname%\�г�\�����.txt
echo. > %domain%\%usrname%\�г�\�⺻����.txt
goto req

:crcon
cd %domain%\%usrname%
copy server.properties pserver.properties
echo enable-rcon=true>>pserver.properties
echo rcon.port=%rport%>>pserver.properties
echo rcon.password=%pw%>>pserver.properties
echo RCON ���� ������ ����ϴ�.
cd ..\..
goto svstart