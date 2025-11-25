#!/bin/bash

# Loop through all arguments passed to the script
for file in "$@"; do
    # 1. Check if file exists
    if [ ! -e "$file" ]; then
        echo "Warning: '$file' not found. Skipping."
        continue
    fi

    # 2. Get the file's modification time
    # Format: YYMMDD-hhmmss
    # logic: date -r reads the file's time, +format formats the output string
    timestamp=$(date -r "$file" "+%y%m%d-%H%M%S")

    # 3. Extract parts of the path
    dir=$(dirname "$file")
    filename=$(basename "$file")

    # 4. Extract extension
    # If filename contains a dot, extract extension, otherwise empty
    if [[ "$filename" == *.* ]]; then
        ext=".${filename##*.}"
    else
        ext=""
    fi

    # 5. Construct the new filename base
    new_name="${timestamp}${ext}"
    target_path="${dir}/${new_name}"

    # 6. Skip if the file is already named correctly
    if [ "$file" == "$target_path" ]; then
        echo "Skipping '$file': Already named correctly."
        continue
    fi

    # 7. Handle Collisions
    # If a file with the new name already exists, append a counter (-1, -2, etc.)
    counter=1
    while [ -e "$target_path" ]; do
        new_name="${timestamp}-${counter}${ext}"
        target_path="${dir}/${new_name}"
        ((counter++))
    done

    # 8. Rename the file
    mv "$file" "$target_path"
    echo "Renamed: '$file' -> '$target_path'"

done
