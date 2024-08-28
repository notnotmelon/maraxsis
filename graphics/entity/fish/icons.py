import os
from PIL import Image

directory = 'C://Users/zacha/Documents/factorio/mods/maraxsis/graphics/entity/fish/'
line_length = 16


q = 0
for filename in os.listdir(directory):
    if filename.endswith('.png'):
        image_path = os.path.join(directory, filename)
        image = Image.open(image_path)
        width, height = image.size

        line_length = 'q'
        lines_per_file = 'q'
        widthb = 0
        heightb = 0

        if width % 20 == 0:
            line_length = 20
        else:
            for i in range(16, 22)[::-1]:
                if width % i == 0:
                    line_length = i
                    break

        if height % 20 == 0:
            lines_per_file = 20
        else:
            for i in range(16, 22)[::-1]:
                if height % i == 0:
                    lines_per_file = i
                    break

        widthb = width // line_length
        heightb = height // lines_per_file

        print(f'{filename} width: {width}, height: {height}, line_length: {line_length}, lines_per_file: {lines_per_file}')

        n = 264
        q += 1
        x = (n % line_length) * widthb
        y = (n // line_length) * heightb

        z=4
        icon = image.crop((x+z, y+z, x-z + widthb, y-z + heightb))
        icon = icon.resize((64, 64))
        icon.save(f'{directory}icons/{filename}')