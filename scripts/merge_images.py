#!/Users/bays/miniforge3/bin/python3

from PIL import Image
import sys

def merge_images(direction, image_files):
    images = [Image.open(image) for image in image_files]

    if direction == "horizontal":
        widths, heights = zip(*(i.size for i in images))
        total_width = sum(widths)
        max_height = max(heights)
        
        new_image = Image.new("RGB", (total_width, max_height))
        
        x_offset = 0
        for image in images:
            new_image.paste(image, (x_offset, 0))
            x_offset += image.width
    elif direction == "vertical":
        widths, heights = zip(*(i.size for i in images))
        max_width = max(widths)
        total_height = sum(heights)
        
        new_image = Image.new("RGB", (max_width, total_height))
        
        y_offset = 0
        for image in images:
            new_image.paste(image, (0, y_offset))
            y_offset += image.height
    else:
        print("Invalid direction. Use 'horizontal' or 'vertical'.")
        return
    
    new_image.save("merged_image.png")
    print("Images merged successfully.")

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: merge_images.py <direction> <image1> <image2> ...")
        sys.exit(1)

    direction = sys.argv[1]
    image_files = sys.argv[2:]

    merge_images(direction, image_files)

