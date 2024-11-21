#!/bin/bash

SOURCE_LOG="/var/log/lora.log"            # Source log file location
DEST_DIR="/home/root/hourly_log"      # Destination directory for hourly logs

mkdir -p "$DEST_DIR"                      # Ensure the destination directory exists

if [ ! -f "$SOURCE_LOG" ]; then
    echo "Source log file $SOURCE_LOG not found. Exiting."
    exit 1
fi

echo "Hourly log record started. Press Ctrl+C to stop."

trap "echo 'Stopping log capture...'; exit" SIGINT                # Handle Ctrl+C

while true; do
    # Set TZ to Asia/Kolkata for IST (UTC+5:30)
    TZ='Asia/Kolkata' date
    TIMESTAMP=$(TZ='Asia/Kolkata' date +"%d_%b:%I%p_%S")  # Generate IST timestamp
    DEST_FILE="$DEST_DIR/$TIMESTAMP"

    echo "Creating log file: $DEST_FILE"   
    tail -f "$SOURCE_LOG" >> "$DEST_FILE" &  # Start appending log content to the new hourly file
    PID=$!

    sleep 3600                            # Wait for one hour before creating the next file
    kill $PID                             # Kill the tail process for the current hour
done


