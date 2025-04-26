#!/bin/bash
# dummy.sh - Simple script that prints a message periodically to stdout
LOG_FILE="/var/log/dummy-service.log"

echo "Dummy service script starting..." # Log startup

while true; do
  # Print a timestamped message to standard output
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Dummy service is running..." >> "${LOG_FILE}" 


  # Wait for 10 seconds
  sleep 10
done

echo "Dummy service script exiting..." # Log shutdown (won't be reached)
exit 0
