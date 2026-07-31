#!/bin/bash

# Server config
JAR_NAME="server.jar"
RAM="16G"

# JVM Performance Flags (Aikar's flags for 12GB+ heap)
JVM_FLAGS="-Dfile.encoding=UTF-8 \
-Djava.net.preferIPv4Stack=true \
-XX:+UseG1GC \
-XX:+ParallelRefProcEnabled \
-XX:MaxGCPauseMillis=200 \
-XX:+UnlockExperimentalVMOptions \
-XX:+DisableExplicitGC \
-XX:+AlwaysPreTouch \
-XX:G1NewSizePercent=30 \
-XX:G1MaxNewSizePercent=40 \
-XX:G1HeapRegionSize=8M \
-XX:G1ReservePercent=20 \
-XX:G1HeapWastePercent=5 \
-XX:G1MixedGCCountTarget=4 \
-XX:InitiatingHeapOccupancyPercent=15 \
-XX:G1MixedGCLiveThresholdPercent=90 \
-XX:G1RSetUpdatingPauseTimePercent=5 \
-XX:SurvivorRatio=32 \
-XX:+PerfDisableSharedMem \
-XX:MaxTenuringThreshold=1 \
-XX:+HeapDumpOnOutOfMemoryError \
-XX:HeapDumpPath=./oom-backend.hprof \
-Dusing.aikars.flags=https://mcflags.emc.gs \
-Daikars.new.flags=true"

# Start server loop
while true; do
    echo "Starting Minecraft server..."
    java $JVM_FLAGS -Xms$RAM -Xmx$RAM -jar "$JAR_NAME" nogui

    echo "$(date '+%Y-%m-%d %H:%M:%S') - Server stopped or crashed. Restarting in 5 seconds..."
    sleep 5
done
