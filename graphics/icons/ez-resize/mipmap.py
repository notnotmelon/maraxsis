import os
from PIL import Image

# creates factoro mipmap images by merging 3 images at different sizes into one image
def generate_mipmaps(input_path, output_dir, colors):
    for i in range(3):
        big_color = colors[(0+i)%3][i]
        medium_color = colors[(1+i)%3][i]
        small_color = colors[(2+i)%3][i]

        # open the input images
        big_color = Image.open(input_path + big_color)
        medium_color = Image.open(input_path + medium_color)
        small_color = Image.open(input_path + small_color)

        image = big_color

        # create the output image
        output_height = image.height
        output_width = image.width + image.width // 2 + image.width // 4
        output_image = Image.new("RGBA", (output_width, output_height), (0, 0, 0, 0))
        
        # paste the original image into the output image
        output_image.paste(big_color, (0, 0))
        # paste the 1/2 size image into the output image
        medium_color = medium_color.resize((image.width // 2, image.height // 2))
        output_image.paste(medium_color, (image.width, 0))
        # paste the 1/4 size image into the output image
        small_color = small_color.resize((image.width // 4, image.height // 4))
        output_image.paste(small_color, (image.width + image.width // 2, 0))

        # save the output image
        output_image.save(output_dir + "heart-of-the-sea-" + str(i + 1) + ".png")

        print("Mipmaps generated successfully!")

# Example usage
blue = [
    "heart-of-the-sea-1-blue.png",
    "heart-of-the-sea-2-blue.png",
    "heart-of-the-sea-3-blue.png",
]
green = [
    "heart-of-the-sea-1-green.png",
    "heart-of-the-sea-2-green.png",
    "heart-of-the-sea-3-green.png",
]
red = [
    "heart-of-the-sea-1-red.png",
    "heart-of-the-sea-2-red.png",
    "heart-of-the-sea-3-red.png",
]

colors = [blue, green, red]

input_path = "C:/Users/zacha/Documents/factorio/mods/dihydrogen-monoxide/graphics/icons/"
output_dir = "C:/Users/zacha/Documents/factorio/mods/dihydrogen-monoxide/graphics/icons/"
generate_mipmaps(input_path, output_dir, colors)