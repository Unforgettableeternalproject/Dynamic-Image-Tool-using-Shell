import sys
import os
import subprocess

def split_gif_mp4(input_file, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    command = ["ffmpeg", "-i", input_file, f"{output_dir}/frame_%04d.png"]
    subprocess.run(command, check=True)
    print(f"Frames extracted from {input_file} and saved in {output_dir}")

def split_sprite_sheet(input_file, rows, cols, output_dir):
    from PIL import Image
    os.makedirs(output_dir, exist_ok=True)
    img = Image.open(input_file)
    width, height = img.size
    frame_width = width // int(cols)
    frame_height = height // int(rows)
    for row in range(int(rows)):
        for col in range(int(cols)):
            frame = img.crop((col * frame_width, row * frame_height,
                              (col + 1) * frame_width, (row + 1) * frame_height))
            frame.save(f"{output_dir}/frame_{row}_{col}.png")
    print(f"Sprite sheet {input_file} split into {rows}x{cols} and saved in {output_dir}")

def create_animation(input_dir, output_file, frame_rate):
    command = ["ffmpeg", "-framerate", str(frame_rate), "-i",
               f"{input_dir}/frame_%04d.png", "-c:v", "libx264", "-pix_fmt", "yuv420p", output_file]
    subprocess.run(command, check=True)
    print(f"Animation created from {input_dir} and saved as {output_file}")

def apply_filter(input_dir, filter_type):
    from PIL import Image, ImageEnhance
    filter_mapping = {
        "grayscale": lambda img: img.convert("L"),
        "invert": lambda img: Image.eval(img, lambda x: 255 - x),
    }
    if filter_type not in filter_mapping:
        print(f"Unsupported filter type: {filter_type}")
        sys.exit(1)

    for frame in os.listdir(input_dir):
        frame_path = os.path.join(input_dir, frame)
        if not frame_path.endswith(".png"):
            continue
        img = Image.open(frame_path)
        filtered_img = filter_mapping[filter_type](img)
        filtered_img.save(frame_path)
    print(f"Filter {filter_type} applied to frames in {input_dir}")

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 video_processor.py [operation] [parameters]")
        sys.exit(1)
    
    operation = sys.argv[1]
    if operation == "split_gif_mp4":
        split_gif_mp4(sys.argv[2], sys.argv[3])
    elif operation == "split_sprite_sheet":
        split_sprite_sheet(sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])
    elif operation == "create_animation":
        create_animation(sys.argv[2], sys.argv[3], sys.argv[4])
    elif operation == "apply_filter":
        apply_filter(sys.argv[2], sys.argv[3])
    else:
        print(f"Unknown operation: {operation}")
        sys.exit(1)

if __name__ == "__main__":
    main()
