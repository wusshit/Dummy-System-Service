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

*   A Linux system using `systemd`
*   `sudo` privilege granted

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
2.  **Make it executable:**
    ```bash
    chmod +x dummy.sh
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
*   **Reload systemd unit files:**
    ```bash
    sudo systemctl daemon-reload
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

*   **Script Logic:** Modify `/usr/local/bin/dummy.sh`.
*   **Log File Path:** Change the `LOG_FILE` variable in `/usr/local/bin/dummy.sh`. Remember to ensure the service user has write permissions to the new location.
*   **Service Behavior (Restart, User, etc.):** Modify `/etc/systemd/system/dummy.service` and run `sudo systemctl daemon-reload` afterwards.
*   **Script Path:** If you place `dummy.sh` somewhere else, update the `ExecStart=` line in `/etc/systemd/system/dummy.service` accordingly.

## SELinux issue
If you encounter an issue with SELinux, most likely your files do not have the proper lables that are allowed to be excuted by SELinux policy

The steps to slove it generally are:

1.   **Fix the Basics:** Ensure correct standard Linux permissions and place files in conventional, standard paths.
   
     As in this dummy.sh, neither user nor group is specified, by default, the files are excuted as root by systemd, then strongly recommended:
     
     **Ownership:** root:root for both dummy.sh and dummy-service.log
     
     **Permission:** 775 for dummt.sh, 664 for dummy-service.log
     
     **Path:** /usr/local/bin/dummy.sh and /var/log/dummy-service.log
     
3.   **Fix Contexts:** If you moved files from a location with a different context (like your home directory), use `restorecon` to apply the correct default context based on the standard path you moved them to.
4.   **Test the Service:** See if it works now.
5.   **Adjust SELinux Policy (if Step 3 fails due to SELinux):** If standard permissions, paths, and default contexts are correct, but the action is still denied, check audit.log for SELinux denials (AVC denied). Use `audit2allow` or check relevant booleans (`getsebool -a | grep <something_relevant>`) to explicitly allow the required interaction between the contexts involved.

## Removal
1.   **Stop the Service:** Ensure the process is no longer running.
2.   **Disable the Service:** Remove the link that makes it start on boot.
3.   **Remove the Service Unit File:** Delete the systemd configuration.
4.   **Reload Systemd:** Tell systemd to forget about the removed unit file.
5.   **Remove the Script File:** Delete the actual script being run.
6.   **(Optional) Remove the Log File:** Clean up the logs generated by the script.
7.   **(Optional) Remove Custom SELinux Policy:** If you created one, remove it.
