@echo off
echo.
echo  ------------------ 前端环境一键部署 ------------------
echo.

echo **请确保使用管理员权限运行，按任意键开始**
echo.
pause>nul

rem 解决管理员权限运行时路径问题
cd "%~dp0"

rem 需要安装的nodejs版本，所有版本可以在这里查看：https://registry.npmmirror.com/binary.html?path=node/
set nodejsVersion=14.19.0
rem 需要安装的nodejs 是64或32位，填32或64
set nodejsBit=64
rem 基础目录
set baseDir=D:\ProgramFiles
rem nodejs目录
set nodeDir=%baseDir%\nodejs
rem nodejs global目录
set nodeGlobalDir=%nodeDir%\node_global
rem nodejs 缓存目录
set nodeCacheDir=%nodeDir%\node_cache
rem 解压工具7z
set zipFile=7za.exe
rem 7z的下载地址
set zipUrl=http://tjn.oss-cn-beijing.aliyuncs.com/7za.exe
rem 刷新环境变量脚本
set refreshenvFile=refreshenv.bat
rem 刷新环境变量脚本下载地址
set refreshenvUrl=http://tjn.oss-cn-beijing.aliyuncs.com/refreshenv.bat

rem git安装目录
set gitDir=%baseDir%\Git
rem git的文件名
set gitExe=git-setup.exe
rem git的下载地址，v2.35.1-x64版本
set gitUrl=https://registry.npmmirror.com/-/binary/git-for-windows/v2.35.1.windows.2/Git-2.35.1.2-64-bit.exe


rem 检测解压工具7z是否存在
echo - 开始检查%zipFile%是否存在
if not exist %zipFile% (
  echo # 缺少%zipFile%
  echo - 开始下载%zipFile%
  
  rem 调用powershell命令，下载7z
  powershell -Command "Invoke-WebRequest %zipUrl% -OutFile %zipFile%"
  
  echo √ %zipFile%下载完成
) else (
  echo # %zipFile%已存在，无需下载
)

rem 检测刷新环境变量脚本是否存在
echo - 开始检查%refreshenvFile%是否存在
if not exist %refreshenvFile% (
  echo # 缺少%refreshenvFile%
  echo - 开始下载%refreshenvFile%
  
  rem 调用powershell命令，下载refreshenv.bat
  powershell -Command "Invoke-WebRequest %refreshenvUrl% -OutFile %refreshenvFile%"
  
  echo √ %refreshenvFile%下载完成
) else (
  echo # %refreshenvFile%已存在，无需下载
)

echo - 开始检查NodeJs是否安装
echo # node -v
call node -v && goto vuecli || goto startNode

:startNode
rem 创建nodejs文件夹
echo - 开始检查nodejs目录[%nodeDir%]是否存在
if exist %nodeDir% (
  echo # 目录[%nodeDir%]已存在，无需创建
) else (
  mkdir %nodeDir%
  echo √ 创建[%nodeDir%]目录完成
)

rem 创建nodejs global 目录
echo - 开始检查nodejs global目录[%nodeGlobalDir%]是否存在
if exist %nodeGlobalDir% (
  echo # 目录[%nodeGlobalDir%]已存在，无需创建
) else (
  mkdir %nodeGlobalDir%
  echo √ 创建[%nodeGlobalDir%]目录完成
)

rem 创建nodejs 缓存目录
echo - 开始检查nodejs 缓存目录[%nodeCacheDir%]是否存在
if exist %nodeCacheDir% (
  echo # 目录[%nodeCacheDir%]已存在，无需创建
) else (
  mkdir %nodeCacheDir%
  echo √ 创建[%nodeCacheDir%]目录完成
)

rem 如果输入的是32那么要替换成下载链接中需要的86。否则都是下载64位版本
if %nodejsBit% == 32 (
  set nodejsBit=86
) else (
  set nodejsBit=64
)
set nodeJsName=node-v%nodejsVersion%-win-x%nodejsBit%
echo - 开始检查%nodeJsName%.zip是否存在
if exist %nodeJsName%.zip (
  echo # %nodeJsName%.zip已存在，无需下载
  rem 直接去解压
  goto :zip
)
echo - 开始下载nodejs, 本次下载%nodeJsName%版本
rem nodejs的下载地址，从淘宝npm镜像网站上下载
set nodejsUrl=https://registry.npmmirror.com/-/binary/node/v%nodejsVersion%/node-v%nodejsVersion%-win-x%nodejsBit%.zip
echo # %nodeJsName%下载地址为：%nodejsUrl%
rem 调用powershell命令，下载nodejs zip
powershell -Command "Invoke-WebRequest %nodejsUrl% -OutFile %nodeJsName%.zip"
echo √ %nodeJsName%下载完成

:zip
echo - 开始检查%nodeJsName%文件夹是否存在
if exist %nodeJsName% (
  echo # %nodeJsName%文件夹已存在，无需解压
  rem 直接去复制
  goto :copy
)
echo - 开始解压%nodeJsName%.zip
rem 调用7z命令，解压zip包
7za x %nodeJsName%.zip -y
echo √ %nodeJsName%.zip解压完成

:copy
echo - 开始复制 [%nodeJsName%] =======》 [%nodeDir%]
rem 把当前目录下的nodejs复制到nodejs目标目录。/q：拷贝时不显示文件名
xcopy %nodeJsName%\*.* %nodeDir% /s /e /c /y /h /r /q
echo √ [%nodeJsName%]复制完成

rem 系统path路径
set remain=%path%
rem 环境变量path中有nodejs配置吗
set hasNode=false
rem 环境变量path中有nodejs global配置吗
set hasNodeGlobal=false

rem 环境变量中是否有node和node global
echo - 开始检查nodejs环境变量是否存在
:loop
for /f "tokens=1* delims=;" %%a in ("%remain%") do (
  if "%nodeDir%"=="%%a" (
    set hasNode=true
    echo # %nodeDir% 已存在Path中
  ) 
   
  if "%nodeGlobalDir%"=="%%a" (
    set hasNodeGlobal=true
    echo # %nodeGlobalDir% 已存在Path中
  )
  
  set remain=%%b
)

rem 一直循环
if defined remain goto :loop

rem 根据不同的情况，拼接需要加入到path中的路径
set resPath=
if "%hasNode%"=="false" (
  if "%hasNodeGlobal%"=="false" (
    set resPath=%path%;%nodeDir%;%nodeGlobalDir%
  )
  if "%hasNodeGlobal%"=="true" (
    set resPath=%path%;%nodeDir%
  )
)

if "%hasNode%"=="true" (
  if "%hasNodeGlobal%"=="false" (
    set resPath=%path%;%nodeGlobalDir%
  )
  if "%hasNodeGlobal%"=="true" (
    set resPath=
  )
)

rem 如果有值才继续写入环境变量path
if defined resPath (
  echo - 开始写入环境变量
  setx /m "path" "%resPath%"
  
  rem 下面这句提示不用了，setx会返回成功或失败的提示
  rem echo √ 写入环境变量完成
  
  echo - 开始刷新环境变量
  rem 调用外部脚本，刷新环境变量
  call refreshenv.bat
  echo √ 刷新环境变量完成
) else (
  echo # nodejs环境变量已存在，无需添加
)

echo # 查看node版本
echo # node -v
call node -v

echo # 查看npm版本
echo # npm -v
call npm -v

echo - 开始检查nodejs全局目录设置
for /F %%i in ('npm config get prefix') do (set prefixInfo=%%i)
if not %prefixInfo% == %nodeGlobalDir% (
  rem 设置nodejs全局目录
  call npm config set prefix "%nodeGlobalDir%"
  echo # npm config set prefix "%nodeGlobalDir%"
  
  call npm config get prefix
  echo √ nodejs全局目录设置完成
) else (
  echo # nodejs全局目录已设置，无需再设
)

echo - 开始检查nodejs缓存目录设置
for /F %%i in ('npm config get cache') do (set cacheInfo=%%i)
if not %cacheInfo% == %nodeCacheDir% (
  rem 设置nodejs缓存目录
  call npm config set cache "%nodeCacheDir%"
  echo # npm config set cache "%nodeCacheDir%"
  
  call npm config get cache
  echo √ nodejs缓存目录设置完成
) else (
  echo # nodejs缓存目录已设置，无需再设
)

echo - 开始检查npm国内镜像设置
set taobaoNpmUrl=https://registry.npmmirror.com/
for /F %%i in ('npm config get registry') do (set registryInfo=%%i)
if not %registryInfo% == %taobaoNpmUrl% (
  rem 设置国内镜像源
  call npm config set registry %taobaoNpmUrl%
  echo # npm config set registry %taobaoNpmUrl%
  
  call npm config get registry
  echo √ npm国内镜像设置完成
) else (
  echo # npm国内镜像已设置，无需再设
)

:vuecli
echo - 开始检查是否安装过vue-cli
echo # vue -V
call vue -V
if %errorlevel% == 0 (
  echo # vue-cli已安装过，无需安装
  goto :git
)

echo - 开始安装vue-cli
rem 安装vue/cli
call npm i -g @vue/cli
echo √ vue-cli 安装完成

echo # 查看vue-cli版本
echo vue -V
call vue -V

if not %errorlevel% == 0 (
  echo # vue-cli安装失败，你可以重新运行本脚本或复制下方命令手动安装
  echo # npm i -g @vue/cli
)

:git
echo.
echo # 要安装Git吗？(1：安装，2：不了)
set /p installGit=
echo 你选择了：%installGit%

rem 开始安装git
if "%installGit%" == "1" (

  echo - 开始检查是否安装过Git
  echo # git --version
  call git --version && goto gitInstalled || goto startInstallGit
  
  rem 已经安装过git了，直接跳出
  :gitInstalled
  echo # Git已安装过，无需安装
  goto :done
  
  rem 没有安装过，先生成git配置文件，再判断有安装包吗
  :startInstallGit
  rem 写入git配置文件
  (
    echo [Setup]
    echo Lang=default
    echo Dir=%gitDir%
    echo Group=Git
    echo NoIcons=0
    echo SetupType=default
    echo Components=icons,ext\reg\shellhere,assoc,assoc_sh
    echo Tasks=
    echo PathOption=Cmd
    echo SSHOption=OpenSSH
    echo CRLFOption=CRLFAlways
    echo BashTerminalOption=ConHost
    echo PerformanceTweaksFSCache=Enabled
    echo UseCredentialManager=Enabled
    echo EnableSymlinks=Disabled
    echo EnableBuiltinDifftool=Disabled
  ) > config.inf
  
  if not exist %gitExe% (
    echo - %gitExe%文件不存在，开始下载Git...
	rem 调用powershell命令，下载nodejs zip
    powershell -Command "Invoke-WebRequest %gitUrl% -OutFile %gitExe%"
	echo √ Git下载完成
  )
  
  echo - 开始安装Git...
  rem 使用配置文件安装git
  call %gitExe% /VERYSILENT /LOADINF="config.inf" && goto gitInstallSuccess || goto gitInstallError
  
  rem git安装失败，直接退出
  :gitInstallError
  echo × Git安装失败，你可以重新运行本脚本尝试重新安装或点击当前目录下%gitExe%手动安装Git
  goto done
  
  rem git成功才继续
  :gitInstallSuccess
  echo √ Git安装成功
 
  echo - 开始刷新环境变量
  rem 调用外部脚本，刷新环境变量
  call refreshenv.bat
  echo √ 刷新环境变量完成

  echo - 查看Git版本
  echo # git --version
  call git --version
  
  
  rem 不删了，可以留下了看看
  rem del config.inf
)


:done
echo.
echo  -------------- 全部设置成功，按任意键退出 ------------
pause>nul