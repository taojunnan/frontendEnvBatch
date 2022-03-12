# 前端环境一键搭建批处理脚本

脚本会帮助你在新机上安装`nodejs`，`npm`，并配置好`nodejs`的全局目录、缓存目录，以及`npm`的国内镜像源。同时也会帮助你一键安装好`git`环境

## 依赖环境

在`win10`专业版下测试没问题，其他系统还未做测试，可以自行尝试

由于脚本用到了`powershell`命令去下载网络资源，如果系统没有`powershell`则无法正常运行

## 如何使用

将`install.bat`[下载](https://github.com/taojunnan/frontendEnvBatch/releases)至本地，右键以管理员身份运行即可。  

如果运行时发现闪退，一闪而过的现象，请先确认是否以管理员权限运行，其次脚本由于会从网络下载资源，会出现不稳定的情况，可以多尝试运行几次

## 工具说明

| 工具             | 说明                                                         |
| ---------------- | ------------------------------------------------------------ |
| `7za.exe`        | `7z`用于解压zip包                                            |
| `refreshenv.bat` | 用于刷新环境变量，刚设好环境变量不能立马在当前窗口生效，需要用这个脚本刷新下，[来自这里](https://github.com/chocolatey/choco/blob/master/src/chocolatey.resources/redirects/RefreshEnv.cmd) |

以上两个工具均从官方下载，为了在脚本中下载方便我把它们上传到了`OSS`中，仓库的[`util`目录](./util)可以看到这两个工具。  

脚本运行时会检测`install.bat`同级目录下有无这两个工具，没有再去`OSS`中下载。运行时，可以将这两个工具放在和`install.bat`同级目录，这样可以省去脚本去下载的过程，当然为了方便，无论在哪，你只要运行`install.bat`，脚本都会帮你一键配置好环境。

## 可配置变量

| 变量            | 说明                                                         |
| --------------- | ------------------------------------------------------------ |
| `nodejsVersion` | 待安装的`nodejs`版本，默认`14.19.0`                          |
| `nodejsBit`     | 待安装的`nodejs` 是`64`或`32`位，填`32`或`64`，默认`64`位    |
| `baseDir`       | 基础目录，可以修改成自己的，默认`D:\ProgramFiles`            |
| `nodeDir`       | `nodejs`安装到的目录，默认`%baseDir%\nodejs`                 |
| `nodeGlobalDir` | `npm`全局目录，默认`%nodeDir%\node_global`                   |
| `nodeCacheDir`  | `npm`缓存目录，默认`%nodeDir%\node_cache`                    |
| `gitDir`        | `git`安装目录，默认`%baseDir%\Git`                           |
| `gitUrl`        | `git`安装包的下载地址，默认从`npmmirror.com`上下载`v2.35.1-x64`版本 |

## 另外

脚本运行时生成(`config.inf`)或下载的文件(`7za.exe`，`refreshEnv.bat`，`nodejs.zip`，`git-setup.exe`等)都可以删除，没有任何影响。不过，建议留着它们，脚本再次运行时会减少去下载它们的耗时。

## License

[MIT](./LICENSE)