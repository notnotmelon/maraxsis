import os

suffixes = ['shadow', 'body', 'full-body', 'mask', 'light']
directory = '''C:/Users/zacha/Documents/factorio/mods/maraxsis/graphics/entity/submarine/''' + suffixes[1] + '/'

for filename in os.listdir(directory):
    if filename.endswith('.png'):
        print(filename)
        # Extract the number from the filename
        number = int(filename.replace('-aaa', '').split('-')[-1].split('.')[0])
        
        # Apply the formula to adjust the number
        adjusted_number = (number - 17) % 64 + 1
        
        # Create the new filename with the adjusted number
        new_filename = filename.replace('-'+str(number), '-'+str(adjusted_number)).replace('.png', '-aaa.png')
        
        # Rename the file
        os.rename(os.path.join(directory, filename), os.path.join(directory, new_filename))