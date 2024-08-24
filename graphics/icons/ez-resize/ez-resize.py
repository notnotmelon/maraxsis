from PIL import Image
import os

directory = os.getcwd()


for filename in os.listdir(directory):
    if filename.endswith('.png') or filename.endswith('.jpg'):
        image_path = os.path.join(directory, filename)
        image = Image.open(image_path)
        resized_image = image.resize((64, 64))
        resized_image.save(image_path)