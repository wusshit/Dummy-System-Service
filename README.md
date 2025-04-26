# Dummy Systemd Service
## Overview

This project demonstrates how to create a simple background script (`dummy.sh`) and manage it using a systemd service (`dummy.service`) on a Linux system. The script simulates a long-running application by logging a message to a file and the systemd journal every 10 seconds.

The systemd service is configured to:
*   Start the script automatically on system boot.
*   Keep the script running in the background.
*   Automatically restart the script if it fails unexpectedly.
*   Integrate with standard `systemctl` commands for management.
*   Log output to the systemd journal (`journalctl`).

## Prerequisites

*   A Linux system using `systemd` (common in modern distributions like Ubuntu, Debian, CentOS, Fedora, Arch Linux, etc.).
*   Root or `sudo` privileges to create files in system directories and manage systemd services.

## Files

1.  **`dummy.sh`**: The background script that runs indefinitely.
    *   **Location:** `/usr/local/bin/dummy.sh` (or adjust path in service file if placed elsewhere)
    *   **Function:** Writes a timestamped "Dummy service is running..." message to `/var/log/dummy-service.log` every 10 seconds.
2.  **`dummy.service`**: The systemd unit file that defines how to manage `dummy.sh`.
    *   **Location:** `/etc/systemd/system/dummy.service`

## Setup

1.  **clone/download the Script and Systemd Service File:**
    ```bash
    git clone https://github.com/wusshit/Dummy-System-Service.git
    ```
2.  **Make it executablee:**
    ```bash
    chomod +x dummy.service
    ```

## Usage

Use standard `systemctl` commands to manage the `dummy` service:

*   **Start the service:**
    ```bash
    sudo systemctl start dummy
    ```
*   **Stop the service:**
    ```bash
    sudo systemctl stop dummy
    ```
*   **Restart the service:**
    ```bash
    sudo systemctl restart dummy
    ```
*   **Check the service status:**
    ```bash
    sudo systemctl status dummy
    ```
*   **Enable automatic start on boot:**
    ```bash
    sudo systemctl enable dummy
    ```
*   **Disable automatic start on boot:**
    ```bash
    sudo systemctl disable dummy
    ```

## Logging

You can monitor the service's output in two ways:

1.  **Systemd Journal (Recommended):**
    View the logs captured by systemd (includes stdout/stderr from the script if `StandardOutput=journal` and `StandardError=journal` are set in the service file).
    ```bash
    # View all logs for the service
    sudo journalctl -u dummy

    # Follow logs in real-time
    sudo journalctl -u dummy -f

    # View logs since the last boot
    sudo journalctl -u dummy -b
    ```

2.  **Custom Log File:**
    View the log file explicitly written to by the `dummy.sh` script.
    ```bash
    # View the end of the log file
    tail /var/log/dummy-service.log

    # Follow the log file in real-time
    tail -f /var/log/dummy-service.log
    ```

## Configuration

*   **Script Logic/Interval:** Modify `/usr/local/bin/dummy.sh`.
*   **Log File Path:** Change the `LOG_FILE` variable in `/usr/local/bin/dummy.sh`. Remember to ensure the service user has write permissions to the new location.
*   **Service Behavior (Restart, User, etc.):** Modify `/etc/systemd/system/dummy.service` and run `sudo systemctl daemon-reload` afterwards.
*   **Script Path:** If you place `dummy.sh` somewhere else, update the `ExecStart=` line in `/etc/systemd/system/dummy.service` accordingly.
