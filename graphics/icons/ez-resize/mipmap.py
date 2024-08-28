import os
from PIL import Image

# creates factoro mipmap images by merging 6 images at different sizes into one image
def generate_mipmaps(input_path, output_dir, colors):
    for i in range(3):
        big_color = colors[(0+i)%3][i]
        medium_color = colors[(1+i)%3][i]
        small_color = colors[(2+i)%3][i]

        # open the input images
        big_color = Image.open(input_path + big_color)
        medium_color = Image.open(input_path + medium_color)
        small_color = Image.open(input_path + small_color)

        width = 256//2
        height = 256//2

        # create the output image
        output_height = height
        output_width = width + width // 2 + width // 4 + width // 8 + width // 16 + width // 32
        output_image = Image.new("RGBA", (output_width, output_height), (0, 0, 0, 0))
        
        # paste the original image into the output image
        big_color = big_color.resize((width, height))
        output_image.paste(big_color, (0, 0))
        # paste the 1/2 size image into the output image
        medium_color = medium_color.resize((width // 2, height // 2))
        output_image.paste(medium_color, (width, 0))
        # paste the 1/4 size image into the output image
        small_color = small_color.resize((width // 4, height // 4))
        output_image.paste(small_color, (width + width // 2, 0))
        # paste the 1/8 size image into the output image
        big_color = big_color.resize((width // 8, height // 8))
        output_image.paste(big_color, (width + width // 2 + width // 4, 0))
        # paste the 1/16 size image into the output image
        medium_color = medium_color.resize((width // 16, height // 16))
        output_image.paste(medium_color, (width + width // 2 + width // 4 + width // 8, 0))
        # paste the 1/32 size image into the output image
        small_color = small_color.resize((width // 32, height // 32))
        output_image.paste(small_color, (width + width // 2 + width // 4 + width // 8 + width // 16, 0))

        # save the output image
        output_image.save(output_dir + "heart-of-the-sea-" + str(i + 1) + ".png")

        print("Mipmaps generated successfully!")

# Example usage
blue = [
    "blue1.png",
    "blue2.png",
    "blue3.png",
]
green = [
    "green1.png",
    "green2.png",
    "green3.png",
]
red = [
    "red1.png",
    "red2.png",
    "red3.png",
]

colors = [blue, green, red]

input_path = "C:/Users/zacha/Documents/factorio/mods/maraxsis/graphics/icons/ez-resize/"
output_dir = "C:/Users/zacha/Documents/factorio/mods/maraxsis/graphics/icons/"
generate_mipmaps(input_path, output_dir, colors)