#!/bin/bash

OUTPUT="all_dart_code.txt"
COUNT=0

# Clear the output file
> "$OUTPUT"

echo "Scanning for Dart files..."

# find . -name "*.dart" : finds dart files
# grep -v : excludes hidden paths, build folders, and the output file itself
find . -maxdepth 5 -name "*.dart" -type f | grep -v "/\." | grep -v "/build/" | grep -v "/.dart_tool/" | while read -r file; do
    
    # Check if file exists and is not the output file
    [[ "$file" == *"$OUTPUT"* ]] && continue
    
    # Increment counter
    ((COUNT++))

    # Get file details
    FILE_NAME=$(basename "$file")
    FULL_PATH=$(readlink -f "$file")

    # Append to text file
    {
        echo "----------------------------------------------------------------"
        echo "FILE: $FILE_NAME"
        echo "LOCATION: $FULL_PATH"
        echo "----------------------------------------------------------------"
        cat "$file"
        echo -e "\n\n"
    } >> "$OUTPUT"

    # Print progress to terminal
    echo "[$COUNT] Added: $file"
done

echo "------------------------------------------------"
if [ "$COUNT" -eq 0 ]; then
    echo "No files found! Check your directory or filters."
else
    echo "Done! Total files processed: $COUNT"
    echo "Content saved to: $OUTPUT"
fi