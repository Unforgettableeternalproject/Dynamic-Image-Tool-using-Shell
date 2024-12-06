import sys
import os
from PIL import Image

def convert_image(input_file, output_file):
    try:
        img = Image.open(input_file)

        if img.mode in ("RGBA", "LA"):
            background = Image.new("RGB", img.size, (255, 255, 255))
            background.paste(img, mask=img.split()[3])
            img = background

        output_format = output_file.split(".")[-1].upper()

        if output_format == "JPG":
            output_format = "JPEG"

        img.save(output_file, format=output_format, quality=95, optimize=True)
        print(f"Converted {input_file} to {output_file}")

    except Exception as e:
        print(f"Failed to convert {input_file} to {output_file}: {e}")
        sys.exit(1)

def resize_image(input_file, output_file, width, height):
    try:
        img = Image.open(input_file)
        img = img.resize((int(width), int(height)))
        img.save(output_file)
        print(f"Resized {input_file} to {width}x{height}, saved as {output_file}")

    except Exception as e:
        print(f"Failed to resize {input_file}: {e}")
        sys.exit(1)

def rotate_image(input_file, output_file, angle):
    try:
        img = Image.open(input_file)
        img = img.rotate(int(angle), expand=True)
        img.save(output_file)
        print(f"Rotated {input_file} by {angle} degrees, saved as {output_file}")

    except Exception as e:
        print(f"Failed to rotate {input_file}: {e}")
        sys.exit(1)

def crop_image(input_file, output_file, x, y, width, height):
    try:
        img = Image.open(input_file)
        cropped = img.crop((int(x), int(y), int(x) + int(width), int(y) + int(height)))
        cropped.save(output_file)
        print(f"Cropped {input_file} to {width}x{height} at ({x}, {y}), saved as {output_file}")

    except Exception as e:
        print(f"Failed to crop {input_file}: {e}")
        sys.exit(1)

def merge_images(input_file1, input_file2, output_file):
    try:
        img1 = Image.open(input_file1)
        img2 = Image.open(input_file2)
        merged = Image.new("RGB", (img1.width + img2.width, max(img1.height, img2.height)))
        merged.paste(img1, (0, 0))
        merged.paste(img2, (img1.width, 0))
        merged.save(output_file)
        print(f"Merged {input_file1} and {input_file2}, saved as {output_file}")

    except Exception as e:
        print(f"Failed to merge {input_file1} and {input_file2}: {e}")
        sys.exit(1)

def batch_resize(input_dir, output_dir, width, height):
    os.makedirs(output_dir, exist_ok=True)

    for filename in os.listdir(input_dir):
        input_file = os.path.join(input_dir, filename)
        output_file = os.path.join(output_dir, filename)

        try:
            resize_image(input_file, output_file, width, height)

        except Exception as e:
            print(f"Failed to resize {input_file}: {e}")

def apply_filter(input_file, output_file, filter_type):
    try:
        from PIL import Image, ImageFilter
        filter_mapping = {
            "1": lambda img: img.convert("L"),
            "2": lambda img: Image.eval(img, lambda x: 255 - x),
            "3": lambda img: img.filter(ImageFilter.BLUR),
            "4": lambda img: img.filter(ImageFilter.EDGE_ENHANCE),
            "5": lambda img: img.filter(ImageFilter.EMBOSS),
            "6": lambda img: img.filter(ImageFilter.SMOOTH),
            "7": lambda img: img.filter(ImageFilter.SHARPEN)
        }
        if filter_type not in filter_mapping:
            print(f"Unsupported filter type: {filter_type}")
            sys.exit(1)

        img = Image.open(input_file)
        filtered_img = filter_mapping[filter_type](img)
        filtered_img.save(output_file)

        print(f"Filter {filter_type} applied to {input_file}")
    except Exception as e:
        print(f"Failed to apply filter {filter_type} to {input_file}: {e}")
        sys.exit(1)

def batch_apply_filter(input_dir, output_dir, filter_type):
    try:
        from PIL import Image, ImageFilter
        filter_mapping = {
            "1": lambda img: img.convert("L"),
            "2": lambda img: Image.eval(img, lambda x: 255 - x),
            "3": lambda img: img.filter(ImageFilter.BLUR),
            "4": lambda img: img.filter(ImageFilter.EDGE_ENHANCE),
            "5": lambda img: img.filter(ImageFilter.EMBOSS),
            "6": lambda img: img.filter(ImageFilter.SMOOTH),
            "7": lambda img: img.filter(ImageFilter.SHARPEN)
        }
        if filter_type not in filter_mapping:
            print(f"Unsupported filter type: {filter_type}")
            sys.exit(1)

        os.makedirs(output_dir, exist_ok=True)
        for filename in os.listdir(input_dir):
            input_file = os.path.join(input_dir, filename)
            output_file = os.path.join(output_dir, filename)
            img = Image.open(input_file)
            filtered_img = filter_mapping[filter_type](img)
            filtered_img.save(output_file)

        print(f"Filter {filter_type} applied to frames in {input_dir}")
    except Exception as e:
        print(f"Failed to apply filter {filter_type} to frames in {input_dir}: {e}")
        sys.exit(1)

def check_file(file_path):
    if file_path.endswith((".gif", ".mp4")):
        print(f"{file_path} is a video or animation. You can use the split operation.")

    elif file_path.endswith((".png", ".jpg", ".jpeg")):
        print(f"{file_path} is an image. You can resize, convert, crop, or rotate it.")

    else:
        print(f"Unsupported file type for {file_path}.")

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 image_processor.py [operation] [parameters]")
        sys.exit(1)
    
    operation = sys.argv[1]
    if operation == "convert":
        convert_image(sys.argv[2], sys.argv[3])

    elif operation == "resize":
        resize_image(sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])

    elif operation == "rotate":
        rotate_image(sys.argv[2], sys.argv[3], sys.argv[4])

    elif operation == "crop":
        crop_image(sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6], sys.argv[7])

    elif operation == "merge":
        merge_images(sys.argv[2], sys.argv[3], sys.argv[4])

    elif operation == "batch_resize":
        batch_resize(sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])

    elif operation == "process_file":
        check_file(sys.argv[2])

    elif operation == "apply_filter":
        apply_filter(sys.argv[2], sys.argv[3], sys.argv[4])

    elif operation == "batch_apply_filter":
        batch_apply_filter(sys.argv[2], sys.argv[3], sys.argv[4])

    else:
        print(f"Unknown operation: {operation}")
        sys.exit(1)

if __name__ == "__main__":
    main()
