FROM steamcmd/steamcmd AS build

RUN steamcmd +login anonymous +app_update 2394010 validate +quit

RUN rm /root/Steam/steamapps/common/PalServer/Pal/Binaries/Linux/PalServer-Linux-Test.debug
RUN rm /root/Steam/steamapps/common/PalServer/Engine/Binaries/Linux/CrashReportClient.debug
RUN rm /root/Steam/steamapps/common/PalServer/Manifest*

RUN groupadd --gid 5000 palworld && \
    useradd --uid 5000 --gid 5000 palworld

RUN echo "#!/bin/bash" > /root/Steam/steamapps/common/PalServer/run.sh && \
    echo "chmod -R 777 /PalServer/Pal/Saved" >> /root/Steam/steamapps/common/PalServer/run.sh && \
    echo "su palworld -c /PalServer/PalServer.sh $@" >> /root/Steam/steamapps/common/PalServer/run.sh && \
    chmod +x /root/Steam/steamapps/common/PalServer/run.sh

RUN chown -R 5000:5000 /root/Steam/steamapps/common/PalServer

RUN mkdir -p /root/steam/sdk32 && \
    mkdir -p /root/steam/sdk64 && \
    mv /root/Steam/steamapps/common/PalServer/steamclient.so /root/steam/sdk32/ && \
    mv /root/Steam/steamapps/common/PalServer/linux64/steamclient.so /root/steam/sdk64/ && \
    rm -r /root/Steam/steamapps/common/PalServer/linux64


FROM ubuntu:20.04

RUN groupadd --gid 5000 palworld && \
    useradd --home-dir /home/palworld --create-home --uid 5000 --gid 5000 palworld

COPY --from=build /root/Steam/steamapps/common/PalServer /PalServer
COPY --from=build /root/steam /home/palworld/.steam

EXPOSE 8211/udp

ENTRYPOINT ["/PalServer/run.sh"]

CMD ["-useperfthreads", "-NoAsyncLoadingThread", "-UseMultithreadForDS"]
