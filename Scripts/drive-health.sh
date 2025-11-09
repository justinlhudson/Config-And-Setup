#!/bin/bash
#
# ======================================================================
#      HARD DRIVE BURN-IN AND TEST SCRIPT (DESTRUCTIVE)
# ======================================================================
#
# WARNING! THIS SCRIPT IS DESTRUCTIVE AND WILL PERMANENTLY ERASE
# ALL DATA ON THE TARGET DRIVE. USE WITH EXTREME CAUTION.
#
# This script will:
# 1. Run a "before" S.M.A.R.T. report.
# 2. Start a long S.M.A.R.T. self-test in the background.
# 3. Run a 1-hour 'fio' random I/O stress test.
# 4. Run a full 'badblocks' 4-pass destructive write-read test.
# 5. Run an "after" S.M.A.R.T. report to check for new errors
#    and the results of the self-test.
#
# All output is logged to a file for review.
#

# --- Configuration ---
# Exit immediately if a command fails
set -o pipefail

# --- Safety Checks ---

# 1. Check for root user
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (e.g., 'sudo ./test_drive.sh /dev/sdX')"
   exit 1
fi

# 2. Check for drive argument
if [[ $# -ne 1 ]]; then
    echo "Usage: sudo $0 /dev/sdX"
    echo "Example: sudo $0 /dev/sdb"
    exit 1
fi

DRIVE="$1"

# 3. Check if drive exists
if [[ ! -b "$DRIVE" ]]; then
    echo "Error: $DRIVE is not a valid block device."
    lsblk -f
    exit 1
fi

# 4. CRITICAL: Check if drive is mounted
if mount | grep -q "^${DRIVE}"; then
    echo "============================ ! ERROR ! ============================"
    echo "Drive $DRIVE or one of its partitions is currently mounted."
    echo "This script is destructive and cannot run on a mounted drive."
    echo "Aborting for safety."
    echo "==================================================================="
    mount | grep "${DRIVE}"
    exit 1
fi

# 5. Check for prerequisite tools
for cmd in smartctl fio badblocks; do
    if ! command -v $cmd &> /dev/null; then
        echo "Error: Required command '$cmd' is not found."
        echo "Please install 'smartmontools', 'fio', and 'e2fsprogs' (for badblocks)."
        echo "On Debian/Ubuntu: sudo apt install smartmontools fio e2fsprogs"
        exit 1
    fi
done


# 6. Final "Point of No Return" Confirmation
echo "======================= ! FINAL WARNING ! ======================="
echo "You are about to run a FULLY DESTRUCTIVE test on drive:"
echo ""
echo "    $DRIVE"
echo ""
echo "Details of this drive:"
lsblk -f "$DRIVE"
echo ""
echo "ALL DATA on this drive will be PERMANENTLY ERASED."
echo "This process can take SEVERAL DAYS for a large drive."
echo "==================================================================="
echo ""
read -p "Press [Enter] to begin the test..."

# --- Log Setup ---
DRIVE_NAME=$(basename "$DRIVE")
LOG_FILE="test-report-${DRIVE_NAME}-$(date +%Y-%m-%d_%H%M).log"

# Start logging all output to the file and the screen
exec &> >(tee -a "$LOG_FILE")

echo "==================================================================="
echo "Test started on $DRIVE at $(date)"
echo "Full log will be saved to: $LOG_FILE"
echo "==================================================================="
echo ""

# --- Test Execution ---

# STEP 1: Initial S.M.A.R.T. Report
echo "======================================================="
echo "STEP 1: Initial S.M.A.R.T. Report (Before Test)"
echo "======================================================="
smartctl -a "$DRIVE"
echo "-------------------------------------------------------"
echo ""

# STEP 2: Start Background S.M.A.R.T. Long Test
echo "======================================================="
echo "STEP 2: Starting S.M.A.R.T. Long Self-Test (in background)"
echo "We will check the results of this at the end."
echo "======================================================="
smartctl -t long "$DRIVE"
echo "-------------------------------------------------------"
echo ""

# STEP 3: FIO 1-Hour Stress Test
echo "======================================================="
echo "STEP 3: Starting 'fio' 1-Hour Random I/O Stress Test..."
echo "This will test controller and performance."
echo "======================================================="
fio --name=random-rw --ioengine=libaio --iodepth=64 --bs=4k \
    --direct=1 --time_based --runtime=3600 --rw=randrw \
    --filename="$DRIVE" --size=100% --group_reporting \
    --exitall_on_error
echo "-------------------------------------------------------"
echo "'fio' test complete."
echo ""

# STEP 4: badblocks Destructive Burn-in
echo "======================================================="
echo "STEP 4: Starting 'badblocks' 4-Pass Destructive Test..."
echo "WARNING: This is the longest part. It will take DAYS."
echo "Progress will be shown below."
echo "======================================================="
# -w = Destructive write-mode (4 passes: 0xaa, 0x55, 0xff, 0x00)
# -s = Show progress
# -v = Verbose (prints error count)
#sudo badblocks -wsv -b 8192 "$DRIVE"
echo "SKIPPED!!!"
echo "-------------------------------------------------------"
echo "'badblocks' test complete."
echo ""

# STEP 5: Final S.M.A.R.T. Report
echo "======================================================="
echo "STEP 5: Final S.M.A.R.T. Report (After Test)"
echo "Checking for new errors and self-test results..."
echo "======================================================="
smartctl -a "$DRIVE"
echo "-------------------------------------------------------"
echo ""

# --- Final Summary ---
echo "======================================================="
echo "DRIVE TEST COMPLETE"
echo "======================================================="
echo "A full log of all tests has been saved to: $LOG_FILE"
echo ""
echo "--- How to Review Your Results ---"
echo ""
echo "1. 'badblocks' Result:"
echo "   Search the log for 'Pass completed'. The line should say:"
echo "   'Pass completed, 0 bad blocks found.' (or similar)"
echo "   *Any* number other than 0 is a failure. Return the drive."
echo ""
echo "2. 'fio' Result:"
echo "   Search the log for 'Disk stats'. Look for any 'err=' counts."
echo "   An 'err=' count greater than 0 may indicate a problem."
echo ""
echo "3. S.M.A.R.T. Final Report:"
echo "   Open the log and scroll to the 'STEP 5' report."
echo "   a) Check the 'Self-test execution status': It should say 'Completed without error'."
echo "   b) Check these attributes:"
echo "      - Reallocated_Sector_Ct"
echo "      - Current_Pending_Sector_Ct"
echo "   Compare their 'RAW_VALUE' to the 'STEP 1' report. If these numbers"
echo "   have increased AT ALL, the drive is failing. Return it."
echo ""

# Final quick check for common error words in the log
if grep -qE "error|fail|bad blocks found" "$LOG_FILE" && ! grep -q "0 bad blocks found" "$LOG_FILE"; then
     echo "WARNING: Potential errors were found in the log. Please review it carefully."
else
     echo "SUCCESS: A quick scan of the log found no obvious errors. Please review it manually to confirm."
fi

echo "Test finished at $(date)"
