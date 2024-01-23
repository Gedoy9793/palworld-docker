FROM steamcmd/steamcmd AS build

RUN steamcmd +login anonymous +app_update 2394010 validate +quit

RUN rm /root/Steam/steamapps/common/PalServer/Pal/Binaries/Linux/PalServer-Linux-Test.debug
RUN rm /root/Steam/steamapps/common/PalServer/Pal/Binaries/Linux/PalServer-Linux-Test.sym
RUN rm /root/Steam/steamapps/common/PalServer/Engine/Binaries/Linux/CrashReportClient.debug
RUN rm /root/Steam/steamapps/common/PalServer/Engine/Binaries/Linux/CrashReportClient.sym

RUN groupadd --gid 5000 palworld && \
    useradd --uid 5000 --gid 5000 palworld

RUN chown -R 5000:5000 /root/Steam/steamapps/common/PalServer

RUN mkdir -p /root/steam/sdk32 && \
    mkdir -p /root/steam/sdk64 && \
    cp /root/.local/share/Steam/steamcmd/linux32/steamclient.so /root/steam/sdk32/ && \
    cp /root/.local/share/Steam/steamcmd/linux64/steamclient.so /root/steam/sdk64/ && \
    chown -R 5000:5000 /root/steam

FROM ubuntu:20.04

RUN groupadd --gid 5000 palworld && \
    useradd --home-dir /home/palworld --create-home --uid 5000 --gid 5000 palworld

USER palworld

COPY --from=build /root/Steam/steamapps/common/PalServer /PalServer
COPY --from=build /root/steam /home/palworld/.steam

EXPOSE 8211/udp

ENTRYPOINT ["/PalServer/PalServer.sh"]

CMD ["-useperfthreads", "-NoAsyncLoadingThread", "-UseMultithreadForDS"]
