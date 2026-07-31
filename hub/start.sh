#!/bin/bash

# Server config
JAR_NAME="hub.jar"
MIN_RAM="2G"
MAX_RAM="4G"

# Prevent multiple instances
if pgrep -f "java.*$JAR_NAME" > /dev/null; then
  echo "Minecraft server is already running. Aborting."
  exit 1
fi

# Optional: delete old logs
# rm -f logs/latest.log

# Start/restart loop (always restarts, even on clean stop)
while true; do
    echo "Starting Minecraft server..."
    java -Djava.net.preferIPv4Stack=true -Xms$MIN_RAM -Xmx$MAX_RAM -jar $JAR_NAME nogui
    echo "Server stopped. Restarting in 5 seconds..."
    sleep 5
done
