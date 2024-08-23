filenames = ['entrance', 'inner', 'outer', 'sides']
filenames = ['inner']

import PIL.Image
import PIL

color_wheel = [
    (0, 0, 255, 255),
    (0, 255, 0, 255),
    (255, 0, 0, 255),
]

for filename in filenames:
    image = PIL.Image.open(f'hr-cliff-{filename}.png').convert('RGBA')
    j = 0
    for i in range(image.width):
        if i % 256 == 0:
            j += 1
        k = 0
        for y in range(image.height):
            if y % 256 == 0:
                k += 1
            if image.getpixel((i, y))[3] != 0:
                image.putpixel((i, y), color_wheel[(j+k) % 3])
    image.save(f'hr-cliff-{filename}-mask.png', 'PNG')