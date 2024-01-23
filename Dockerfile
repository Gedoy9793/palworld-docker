FROM steamcmd/steamcmd AS build

RUN steamcmd +login anonymous +app_update 2394010 validate +quit
# RUN steamcmd +login anonymous +app_update 1007    validate +quit

RUN rm /root/Steam/steamapps/common/PalServer/Pal/Binaries/Linux/PalServer-Linux-Test.debug
RUN rm /root/Steam/steamapps/common/PalServer/Pal/Binaries/Linux/PalServer-Linux-Test.sym
RUN rm /root/Steam/steamapps/common/PalServer/Engine/Binaries/Linux/CrashReportClient.debug
RUN rm /root/Steam/steamapps/common/PalServer/Engine/Binaries/Linux/CrashReportClient.sym

RUN groupadd --gid 5000 palworld && \
    useradd --uid 5000 --gid 5000 palworld
RUN chown -R 5000:5000 /root/Steam/steamapps/common/PalServer
RUN chown -R 5000:5000 /root/.local/share/Steam/steamcmd

FROM ubuntu:20.04

RUN groupadd --gid 5000 palworld && \
    useradd --home-dir /home/palworld --create-home --uid 5000 --gid 5000 palworld

#RUN addgroup -g 5000 palworld && \
#    adduser -u 5000 -D -G palworld palworld

USER palworld

COPY --from=build /root/Steam/steamapps/common/PalServer /PalServer
COPY --from=build /root/.steam /home/palworld/.steam
COPY --from=build /root/.local/share/Steam/steamcmd /home/palworld/.local/share/Steam/steamcmd

RUN mkdir -p /home/palworld/.steam && \
    ln -s /home/palworld/.local/share/Steam/steamcmd/linux32 /home/palworld/.steam/sdk32 && \
    ln -s /home/palworld/.local/share/Steam/steamcmd/linux64 /home/palworld/.steam/sdk64

EXPOSE 8211/udp

ENTRYPOINT ["/PalServer/PalServer.sh"]

CMD ["-useperfthreads", "-NoAsyncLoadingThread", "-UseMultithreadForDS"]
