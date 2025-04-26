#!/bin/bash
# dummy.sh - Simple script that prints a message periodically to stdout

echo "Dummy service script starting..." # Log startup

while true; do
  # Print a timestamped message to standard output
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Dummy service is running..." >> "/usr/local/bin/dummy-service.log" 


  # Wait for 10 seconds
  sleep 10
done

echo "Dummy service script exiting..." # Log shutdown (won't be reached)
exit 0
