from PIL import Image

target_shade = (144, 165, 58)
negative_interference = (196, 124, 61)
output_shade = (96, 174, 193)

def blend(a, b, percent):
    percent = max(0, min(1, percent))
    return (
        int(a[0] * (1 - percent) + b[0] * percent),
        int(a[1] * (1 - percent) + b[1] * percent),
        int(a[2] * (1 - percent) + b[2] * percent),
    )

def convert_green_to_blue(image_path, output_path):
    # Open the image
    image = Image.open(image_path)
    image = image.convert("RGBA")
    pixels = image.load()

    # Iterate through the pixels
    for y in range(image.height):
        for x in range(image.width):
            r, g, b, a = pixels[x, y]
            g_norm = g
            r_norm = r
            if target_shade[1] < g: g_norm = target_shade[1]
            if target_shade[0] < r: r_norm = target_shade[0]
            distance = sum(abs(a - b) for a, b in zip((r_norm, g_norm, b), target_shade))
            distance_decrement = sum(abs(a - b) for a, b in zip((r, g, b), negative_interference))
            distance += (((distance_decrement / 255) ** 0.33) * 255) / 3
            if distance < 90:
                percent = distance / 90
                blended = blend(output_shade, (r, g, b), percent)
                pixels[x, y] = (*blended, a)

    # Save the modified image
    image.save(output_path)

path = r"C:\Users\zacha\Documents\factorio\1.2\mods\maraxsis\graphics\entity\fish-farm\\"
# Example usage
convert_green_to_blue(path + 'agricultural-tower-base.png', path + 'output.png')