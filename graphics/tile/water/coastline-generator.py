from PIL import Image

water = Image.open('water-combined.png').convert('RGBA')
waterhsv = water.convert('HSV')
mask = Image.open('hr-coastline-mask-nopremul.png').convert('RGBA')

result = Image.new('RGBA', mask.size)

for x in range(mask.width):
    for y in range(mask.height):
        h, s, v, a = mask.getpixel((x, y))
        r2, g2, b2, a2 = water.getpixel(((x // 2) % 32, (y // 2) % 32))
        final_a = (255-v)/255 * a2/255
        final_a = int(final_a * 255)
        result.putpixel((x, y), (r2, g2, b2, final_a))

result.save('water-coastline.png', 'PNG')