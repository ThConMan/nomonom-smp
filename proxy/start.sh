#!/bin/bash

MIN_RAM=1G
MAX_RAM=2G
JAR_NAME="velo.jar"

# JVM Performance Flags
JVM_FLAGS="-Dfile.encoding=UTF-8 \
-Djava.net.preferIPv4Stack=true \
-DGeyser.ListenCount=4 \
-XX:+UseG1GC \
-XX:+ParallelRefProcEnabled \
-XX:+AlwaysPreTouch \
-XX:+DisableExplicitGC \
-XX:+UseStringDeduplication \
-XX:MaxGCPauseMillis=100 \
-XX:G1ReservePercent=20 \
-XX:G1MixedGCCountTarget=4 \
-XX:InitiatingHeapOccupancyPercent=30 \
-XX:+HeapDumpOnOutOfMemoryError \
-XX:HeapDumpPath=./oom-velocity.hprof"

while true; do
  echo "Starting Velocity proxy..."
  java $JVM_FLAGS -Xms$MIN_RAM -Xmx$MAX_RAM -jar "$JAR_NAME" nogui
  echo "$(date '+%F %T') - Velocity proxy stopped. Restarting in 5 seconds..."
  sleep 5
done
