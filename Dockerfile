FROM spritsail/alpine:3.15

ARG MC_VER=1.18.1
ARG FABRIC_VER=0.10.2
LABEL maintainer="Spritsail <minecraft@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Minecraft server" \
      org.label-schema.url="https://minecraft.net/en-us/download/server/" \
      org.label-schema.description="Minecraft server" \
      org.label-schema.version=${MC_VER}

WORKDIR /usr/lib/minecraft
RUN apk --no-cache add openjdk17-jre-headless nss curl && \
    \
    curl -fsSLO https://maven.fabricmc.net/net/fabricmc/fabric-installer/$FABRIC_VER/fabric-installer-$FABRIC_VER.jar && \
    java -jar fabric-installer-$FABRIC_VER.jar server -mcversion $MC_VER -downloadMinecraft && \
    rm -f fabric-installer-$FABRIC_VER.jar && \
    \
    apk --no-cache del curl

WORKDIR /mc

ENV INIT_MEM=1G \
    MAX_MEM=4G \
    SERVER_JAR=/usr/lib/minecraft/server.jar \
    LAUNCH_JAR=/usr/lib/minecraft/fabric-server-launch.jar

CMD exec java \
        -Xms"$INIT_MEM" \
        -Xmx"$MAX_MEM" \
        -Dfabric.gameJarPath="$SERVER_JAR" \
        -jar "$LAUNCH_JAR" \
        nogui
