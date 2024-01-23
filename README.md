# palworld-docker
幻兽帕鲁docker镜像

精简容量，镜像总共只有1.693G

下载：
```shell
$ docker pull registry.cn-hangzhou.aliyuncs.com/gedoy-public/palworld
```

启动：
```shell
$ docker run -itd -p <映射端口号>:2811/udp -v <存档目录映射路径>:/PalServer/Pal/Saved registry.cn-hangzhou.aliyuncs.com/gedoy-public/palworld
```
