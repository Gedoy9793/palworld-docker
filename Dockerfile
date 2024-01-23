FROM steamcmd/steamcmd

RUN groupadd --gid 5000 palworld && \
    useradd --home-dir /home/palworld --create-home --uid 5000 --gid 5000 --shell /bin/sh --skel /dev/null palworld

USER palworld

WORKDIR /home/palworld
ENV HOME=/home/palworld
ENV USER=palworld

RUN steamcmd +login anonymous +app_update 2394010 validate +app_update 1007 validate +quit
RUN ln /home/palworld/Steam/steamapps/common/PalServer/Pal/Saved /Saved && \
    mkdir -p /home/palworld/.steam/sdk64 && \
    mkdir -p /home/palworld/.steam/sdk32 && \
    ln -s /home/palworld/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so /home/palworld/.steam/sdk64/ && \
    ln -s /home/palworld/Steam/steamapps/common/Steamworks\ SDK\ Redist/steamclient.so /home/palworld/.steam/sdk32/

EXPOSE 8211

ENTRYPOINT ["/home/palworld/Steam/steamapps/common/PalServer/PalServer.sh"]
CMD ["-useperfthreads", "-NoAsyncLoadingThread", "-UseMultithreadForDS"]
