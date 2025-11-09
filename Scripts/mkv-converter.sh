#!/usr/bin/env bash

# --- ultimate_plex_converter_v24_overwrite.sh ---
#
# v24: MODIFIED FOR OVERWRITE BEHAVIOR.
#      1. Removed complex "SKIP/VERIFY" logic for existing local MKV files.
#      2. If an MKV file exists, the script now always proceeds to REMUX/TRANSCODE,
#         overwriting the existing MKV file when the FFmpeg command executes.
#      3. Only skips conversion if the ORIGINAL source file is already inside CONVERTED_DIR.
#
# Retains all robustness and failover features (v23).
#
#

# --- Configuration ---
CONVERTED_DIR="CONVERTED"
CORRUPTED_DIR="CORRUPTED"
# Note: Ensure 'hevc_videotoolbox' is correct for your system (e.g., macOS).
TRANSCODE_VIDEO_SETTINGS=("-c:v" "hevc_videotoolbox" "-q:v" "65") 
# --- End Configuration ---

echo "Starting recursive SMART conversion (v24 - Force Overwrite)..."
echo "NOTE: Existing local MKV files will be overwritten."
echo "-----------------------------------------------------"

mkdir -p "$CONVERTED_DIR"
mkdir -p "$CORRUPTED_DIR"

while IFS= read -r -d '' file; do

    # --- Pre-check and Path Sanity ---
    if [ ! -f "$file" ]; then echo "SKIP (Vanished): '$file' no longer exists."; echo "-----------------------------------------------------"; continue; fi
    
    # CRITICAL PATH SANITY CHECK
    if [[ -z "$file" ]]; then
        echo "WARNING: Received an empty file path. Skipping."
        echo "-----------------------------------------------------"
        continue
    fi
    # --- END CRITICAL PATH SANITY CHECK ---

    # --- Define Paths ---
    output_file="${file%.*}.mkv"
    file_rel_path="${file#./}"
    dest_converted_file="$CONVERTED_DIR/$file_rel_path"
    dest_corrupted_file="$CORRUPTED_DIR/$file_rel_path"
    dest_converted_dir=$(dirname "$dest_converted_file")
    dest_corrupted_dir=$(dirname "$dest_corrupted_file")

    # --- Skip Logic (Simplified for Overwrite) ---
    # Only skip if the original file is already inside the CONVERTED directory.
    if [ -f "$dest_converted_file" ]; then
        echo "SKIP: Original '$dest_converted_file' already exists in $CONVERTED_DIR."
        echo "-----------------------------------------------------"
        continue
    fi
    # --- END Skip Logic ---
    
    # --- START CONVERSION (Will overwrite $output_file if it exists) ---
    if [ -f "$output_file" ]; then
        echo "OVERWRITE: Local '$output_file' exists. Proceeding with re-conversion and overwrite."
    fi

    # --- Smart Check (Codec Identification) ---
    codec_name=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file")
    
    # --- Define Base FFmpeg Flags (Common to all attempts) ---
    base_ffmpeg_flags=(
        "ffmpeg"
        "-ignore_unknown" # Input resilience
        "-y"              # ADDED: Force overwrite output files without asking
        "-i" "$file"
        "-map" "0:v"   # Selects first stream of type 'video' (v:0)
        "-map" "0:a"   # Selects first stream of type 'audio' (a:0) -> becomes output a:0
        "-map" "0:a"   # Selects first stream of type 'audio' (a:0) -> becomes output a:1
        "-sn"          # NO subtitle streams
        "-nostdin"     # Prevents dropping into interactive mode
        "-c:a:0" "copy"
        "-c:a:1" "ac3" "-b:a:1" "640k"  # convert a:1 to ac3 for plex compatability as failover, keeping orignal in a:0
        "$output_file"
    )

    # --- Determine Initial Command ---
    if [[ "$codec_name" =~ ^(h264|h265|hevc)$ ]]; then
        # PATH 1A: REMUX COMMAND (Lossless Copy)
        echo "REMUX (Lossless, $codec_name): $file"
        ffmpeg_command=( "${base_ffmpeg_flags[@]}" "-c:v" "copy" )
        attempt_type="REMUX"
    else
        # PATH 2: TRANSCODE (If not H.264/H.265, skip straight to transcode)
        echo "TRANSCODE ($codec_name): $file"
        ffmpeg_command=( "${base_ffmpeg_flags[@]}" "${TRANSCODE_VIDEO_SETTINGS[@]}" )
        attempt_type="TRANSCODE"
    fi

    # --- Execute and Verify (Attempt 1) ---
    "${ffmpeg_command[@]}"

    # --- Failover Logic ---
    if [ $? -ne 0 ] && [ "$attempt_type" == "REMUX" ]; then
        
        # If REMUX failed, clear the bad output file and try TRANSCODE
        echo "FAILURE (REMUX): Remux failed. Attempting TRANSCODE failover..."
        rm -f "$output_file"
        
        # PATH 1B: TRANSCODE FAILOVER COMMAND
        ffmpeg_command=( "${base_ffmpeg_flags[@]}" "${TRANSCODE_VIDEO_SETTINGS[@]}" )
        attempt_type="TRANSCODE_FAILOVER"

        # --- Execute and Verify (Attempt 2: TRANSCODE) ---
        "${ffmpeg_command[@]}"
    fi
    
    # --- Final Result Processing ---
    if [ $? -eq 0 ]; then
        echo "SUCCESS ($attempt_type): Created $output_file. Now verifying..."
        
        ffprobe -v error "$output_file"
        
        if [ $? -eq 0 ]; then
            # FFPROBE SUCCESS
            echo "SUCCESS (FFPROBE): File '$output_file' is valid."
            echo "MOVE (SUCCESS): Moving ORIGINAL '$file' -> '$dest_converted_file'"
            mkdir -p "$dest_converted_dir"
            mv "$file" "$dest_converted_file"
        else
            # FFPROBE FAILURE (Output file is bad)
            echo "FAILURE (FFPROBE): File '$output_file' is corrupted after $attempt_type."
            rm -f "$output_file"
            echo "MOVE (FINAL FAILURE): Moving ORIGINAL '$file' -> '$dest_corrupted_file'"
            mkdir -p "$dest_corrupted_dir"
            mv "$file" "$dest_corrupted_file"
        fi
    else
        # FFMPEG FAILURE (Both REMUX and TRANSCODE failed)
        echo "FAILURE (FFMPEG): FFmpeg failed during $attempt_type for $file"
        rm -f "$output_file"
        echo "MOVE (FINAL FAILURE): Moving ORIGINAL '$file' -> '$dest_corrupted_file'"
        mkdir -p "$dest_corrupted_dir"
        mv "$file" "$dest_corrupted_file"
    fi

    echo "-----------------------------------------------------"

done < <(find . \
    \( -path "./$CONVERTED_DIR" -o -path "./$CORRUPTED_DIR" \) -prune \
    -o \
    \( -type f \( \
        -iname "*.mp4" -o \
        -iname "*.avi" -o \
        -iname "*.mov" -o \
        -iname "*.wmv" -o \
        -iname "*.flv" -o \
        -iname "*.m4v" \
    \) \) -print0)

echo "--- CONVERSION COMPLETE ---"