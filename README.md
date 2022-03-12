# 前端环境一键搭建批处理脚本

脚本会帮助你在新机上安装nodejs，npm，并配置好nodejs的全局目录、缓存目录，以及npm的国内镜像源。同时也会帮助你一键安装好git环境

## 如何使用

将`install.bat`下载至本地，右键以管理员身份运行即可。

## 工具说明

| 工具           | 说明                                                         |
| -------------- | ------------------------------------------------------------ |
| 7za.exe        | 7z用于解压zip包                                              |
| refreshenv.bat | 用于刷新环境变量，刚设好环境变量不能立马在当前窗口生效，需要用这个脚本刷新下，[来自这里](https://github.com/chocolatey/choco/blob/master/src/chocolatey.resources/redirects/RefreshEnv.cmd) |

以上两个工具均从官方下载，为了在脚本中下载方便我把它们上传到了OSS中，仓库的[util](./util)中可以看到这两个工具。  

脚本运行时会检测`install.bat`同级目录下有无这两个工具，没有再去OSS中下载。运行时，可以将这两个工具放在和`install.bat`同级目录，这样可以省去脚本去下载的过程，当然为了方便，无论在哪，你只要运行`install.bat`，脚本都会帮你一键配置好环境。

## 可配置变量

| 变量          | 说明                                                         |
| ------------- | ------------------------------------------------------------ |
| nodejsVersion | 待安装的nodejs版本，默认14.19.0                              |
| nodejsBit     | 待安装的nodejs 是64或32位，填32或64，默认64位                |
| baseDir       | 基础目录，可以修改成自己的，默认D:\ProgramFiles              |
| nodeDir       | nodejs安装到的目录，默认%baseDir%\nodejs                     |
| nodeGlobalDir | npm全局目录，默认%nodeDir%\node_global                       |
| nodeCacheDir  | npm缓存目录，默认%nodeDir%\node_cache                        |
| gitDir        | git安装目录，默认%baseDir%\Git                               |
| gitUrl        | git安装包的下载地址，默认从npmmirror.com上下载v2.35.1-x64版本 |

## License

[MIT](./LICENSE)