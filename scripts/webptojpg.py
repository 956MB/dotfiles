#!/usr/bin/env python3
import os
import sys
from PIL import Image

def convert_webp_to_jpg(folder_path):
    # Check if the folder exists
    if not os.path.isdir(folder_path):
        print("Folder does not exist!")
        return

    # Convert .webp to .jpg
    for file_name in os.listdir(folder_path):
        if file_name.endswith(".webp") or file_name.endswith(".jfif") or file_name.endswith(".avif"):
            webp_file_path = os.path.join(folder_path, file_name)
            jpg_file_path = os.path.splitext(webp_file_path)[0] + ".jpg"
            try:
                # Open .webp file and save it as .jpg
                Image.open(webp_file_path).convert("RGB").save(jpg_file_path, "JPEG")
                print(f"Converted {file_name} to {os.path.basename(jpg_file_path)}")
                # Delete the original .webp file
                os.remove(webp_file_path)
                print(f"Deleted {file_name}")
            except Exception as e:
                print(f"Failed to convert {file_name}: {e}")

def main():
    # Check if the folder path argument is provided
    if len(sys.argv) != 2:
        print("Usage: {} <folder_path>".format(sys.argv[0]))
        sys.exit(1)

    folder_path = sys.argv[1]
    convert_webp_to_jpg(folder_path)

if __name__ == "__main__":
    main()

