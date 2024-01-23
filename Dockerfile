FROM steamcmd/steamcmd

RUN groupadd --gid 5000 palworld && \
    useradd --home-dir /home/palworld --create-home --uid 5000 --gid 5000 --shell /bin/sh --skel /dev/null palworld

RUN steamcmd +force_install_dir /home/palworld/runtime   +login anonymous +app_update 1007    validate +quit
RUN steamcmd +force_install_dir /home/palworld/palserver +login anonymous +app_update 2394010 validate +quit

RUN mkdir -p /home/palworld/palserver/Pal/Saved && \
    ln /home/palworld/palserver/Pal/Saved /Saved && \
    mkdir -p /home/palworld/.steam/sdk64 && \
    mkdir -p /home/palworld/.steam/sdk32 && \
    ln -s /home/palworld/runtime/linux64/steamclient.so /home/palworld/.steam/sdk64/ && \
    ln -s /home/palworld/runtime/steamclient.so /home/palworld/.steam/sdk32/

RUN chowm -R palworld /home/palworld && \
    chgrp -R palworld /home/palworld

USER palworld

EXPOSE 8211

ENTRYPOINT ["/home/palworld/Steam/steamapps/common/PalServer/PalServer.sh"]

CMD ["-useperfthreads", "-NoAsyncLoadingThread", "-UseMultithreadForDS"]
