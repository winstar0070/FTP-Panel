@echo off
set domain=LocalUser
rem 이 파일은 관리자가 유저를 생성하거나 삭제하는 프로그램입니다.

color 1f
net session>nul
if ERRORLEVEL 2 (
 echo 관리자 권한이 필요합니다.
 pause>nul
 exit /b 1
)
pushd %~dp0
echo 이 프로그램은 생성과 삭제를 동시에 할 수 있습니다.
echo.
echo 경고! 이 패널은 버그패치를 제외한 기술지원이 종료되었습니다.
echo 경고! 다른 곳에서 쓰이는 비밀번호를 입력하시면 절대 안됩니다. 비밀번호는 평문으로 저장됩니다.
echo.
set /p id=조회할 유저의 아이디를 입력 : 
if "%id%"=="config" (
echo 네?
pause>nul
exit /b 1
)
if exist %id%.cmd goto delete
:create
set /p pw=생성할 유저의 비밀번호를 입력 : 
set mem=1500
set /p mem=%id%가 사용할 메모리 할당 크기(MB단위) : 
set /p port=%id%가 사용할 포트 : 
set /p rport=%id%가 사용할 RCON 포트 : 
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
md %domain%\%id%\패널
copy 읽어주세요!(고객용).txt %domain%\%id%\읽어주세요!(고객용).txt
echo.>%domain%\%id%\패널\강제종료.txt
echo.>%domain%\%id%\패널\시작.txt
echo.>%domain%\%id%\패널\재시작.txt
echo.>%domain%\%id%\패널\기본세팅.txt
echo @echo off>%id%.cmd
echo set usrname=%id%>>%id%.cmd
echo master_exec>>%id%.cmd
net user %id% %pw% /add
net localgroup IIS_IUSRS %id% /add
net localgroup Users %id% /delete
echo 생성 완료!
echo %id%.cmd를 실행해주세요.
pause
exit /b 0
:delete
echo 아무 키나 누르면 %id%를 삭제합니다.
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
echo 삭제완료!
pause
:exit