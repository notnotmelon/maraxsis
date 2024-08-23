filenames = ['entrance', 'inner', 'outer', 'sides']
filenames = [f'hr-cliff-{filename}-mask.png' for filename in filenames]

import PIL
from PIL import Image

tuples = [
    ('sand-1', Image.open('hr-sand-1.png'), filenames, 320, 256),
    ('sand-3', Image.open('hr-sand-3.png'), filenames, 320, 256),
    ('dirt-5', Image.open('hr-dirt-5.png'), filenames, 320, 256),
]

for suffix, sand, filenames, offset, mod in tuples:
    for filename in filenames:
        image = PIL.Image.open(filename).convert('RGBA')
        for i in range(image.width):
            for y in range(image.height):
                if image.getpixel((i, y)) == (255, 255, 255, 255):
                    sand_pixel = sand.getpixel((i % sand.width, y % mod + offset))
                    image.putpixel((i, y), sand_pixel)
        filename = filename.replace('.png', '')
        filename = filename.replace('-mask', '')
        image.save(filename + '-' + suffix + '.png', 'PNG')
        image = image.resize((int(image.width * 0.5), int(image.height * 0.5)))
        filename = filename.replace('hr-', '')
        image.save(filename + '-' + suffix + '.png', 'PNG')