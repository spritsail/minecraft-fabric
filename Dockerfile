FROM spritsail/alpine:3.20

ARG MC_VER=1.21.1
ARG JRE_VER=21
ARG FABRIC_VER=0.16.3
ARG FABRIC_INST=1.0.1

LABEL maintainer="Spritsail <minecraft@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Minecraft server" \
      org.label-schema.url="https://minecraft.net/en-us/download/server/" \
      org.label-schema.description="Minecraft server" \
      org.label-schema.version=${MC_VER}-${FABRIC_VER}

WORKDIR /usr/lib/minecraft
RUN apk --no-cache add openjdk${JRE_VER}-jre-headless nss curl && \
    \
    curl -fsSLO https://maven.fabricmc.net/net/fabricmc/fabric-installer/${FABRIC_INST}/fabric-installer-${FABRIC_INST}.jar && \
    java -jar fabric-installer-${FABRIC_INST}.jar server -loader ${FABRIC_VER} -mcversion ${MC_VER} -downloadMinecraft && \
    rm -f fabric-installer-${FABRIC_INST}.jar && \
    \
    apk --no-cache del curl

WORKDIR /mc

ENV INIT_MEM=1G \
    MAX_MEM=4G \
    SERVER_JAR=/usr/lib/minecraft/server.jar \
    LAUNCH_JAR=/usr/lib/minecraft/fabric-server-launch.jar

CMD exec java \
        -Xms"${INIT_MEM}" \
        -Xmx"${MAX_MEM}" \
        -Dfabric.gameJarPath="${SERVER_JAR}" \
        -jar "${LAUNCH_JAR}" \
        nogui
