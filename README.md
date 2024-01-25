# palworld-docker
幻兽帕鲁docker镜像

## 关于版本

[在这里看版本通知](https://github.com/Gedoy9793/palworld-docker/discussions/2)

可以自行下载Dockerfile并构建，但需要构建环境可以从steam登录并下载游戏，且游戏下载体积相对大一点

也可以来上面的讨论区拍我

## 介绍

幻兽帕鲁docker镜像，上传在国内（阿里云）

镜像包括服务端本体，不需要额外下载，体积只有1.69G

## 使用

### 需要提前安装docker

- ubuntu
  ```shell
  apt install docker.io
  ```

别的系统 ~~懒得找了，~~ 请自行搜索安装docker（不难）

### 启动

```shell
$ docker run -itd -p <映射端口号>:8211/udp \
     -v <存档目录映射路径>:/PalServer/Pal/Saved \
     registry.cn-hangzhou.aliyuncs.com/gedoy-public/palworld
```

启动时，脚本会给存档目录赋777权限。

如果需要默认配置文件，可以在本仓库拿。
