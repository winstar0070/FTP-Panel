@echo off
set domain=LocalUser
rem �� ������ �����ڰ� ������ �����ϰų� �����ϴ� ���α׷��Դϴ�.

color 1f
net session>nul
if ERRORLEVEL 2 (
 echo ������ ������ �ʿ��մϴ�.
 pause>nul
 exit /b 1
)
pushd %~dp0
echo �� ���α׷��� ������ ������ ���ÿ� �� �� �ֽ��ϴ�.
echo.
echo ���! �� �г��� ������ġ�� ������ ��������� ����Ǿ����ϴ�.
echo ���! �ٸ� ������ ���̴� ��й�ȣ�� �Է��Ͻø� ���� �ȵ˴ϴ�. ��й�ȣ�� ������ ����˴ϴ�.
echo.
set /p id=��ȸ�� ������ ���̵� �Է� : 
if "%id%"=="config" (
echo ��?
pause>nul
exit /b 1
)
if exist %id%.cmd goto delete
:create
set /p pw=������ ������ ��й�ȣ�� �Է� : 
set mem=1500
set /p mem=%id%�� ����� �޸� �Ҵ� ũ��(MB����) : 
set /p port=%id%�� ����� ��Ʈ : 
set /p rport=%id%�� ����� RCON ��Ʈ : 
if not exist %domain% md %domain%
md %domain%\%id%
if not exist config md config
if not exist config\memory md config\memory
if not exist config\port md config\port
if not exist config\rport md config\rport
if not exist config\pw md config\pw
echo %mem%>config\memory\%id%.txt
echo %port%>config\port\%id%.txt
echo %rport%>config\rport\%id%.txt
echo %pw%>config\pw\%id%.txt
md %domain%\%id%\�г�
copy �о��ּ���!(����).txt %domain%\%id%\�о��ּ���!(����).txt
echo.>%domain%\%id%\�г�\��������.txt
echo.>%domain%\%id%\�г�\����.txt
echo.>%domain%\%id%\�г�\�����.txt
echo.>%domain%\%id%\�г�\�⺻����.txt
echo @echo off>%id%.cmd
echo set usrname=%id%>>%id%.cmd
echo master_exec>>%id%.cmd
net user %id% %pw% /add
net localgroup IIS_IUSRS %id% /add
net localgroup Users %id% /delete
echo ���� �Ϸ�!
echo %id%.cmd�� �������ּ���.
pause
exit /b 0
:delete
echo �ƹ� Ű�� ������ %id%�� �����մϴ�.
pause
net user %id% /delete
del /s %domain%\%id% /q
rmdir /s %domain%\%id% /q
del %id%.cmd
del config\port\%id%.txt
del config\memory\%id%.txt
del config\rport\%id%.txt
del config\pw\%id%.txt
cls
echo �����Ϸ�!
pause
:exit