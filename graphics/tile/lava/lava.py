import random
import math
from PIL import Image

def getseed():
    perm = list(range(256))
    random.shuffle(perm)
    perm *= 32
    dirs = [(math.cos(a * 2.0 * math.pi / 256),
             math.sin(a * 2.0 * math.pi / 256))
             for a in range(256)]
    return perm, dirs

perm,dirs=getseed()
freq = 1/64.0

def noise(x, y, per):
        def surflet(gridX, gridY):
            distX, distY = abs(x-gridX), abs(y-gridY)
            polyX = 1 - 6*distX**5 + 15*distX**4 - 10*distX**3
            polyY = 1 - 6*distY**5 + 15*distY**4 - 10*distY**3
            hashed = perm[perm[int(gridX)%per] + int(gridY)%per]
            grad = (x-gridX)*dirs[hashed][0] + (y-gridY)*dirs[hashed][1]
            return polyX * polyY * grad
        intX, intY = int(x), int(y)
        return (surflet(intX+0, intY+0) + surflet(intX+1, intY+0) +
                surflet(intX+0, intY+1) + surflet(intX+1, intY+1))

def fBm(x, y, per, octs):
    val = 0
    for o in range(octs):
        val += 0.5**o * noise(x*2**o, y*2**o, per*2**o)
    return val
    
cache = [None] * 64
cache2 = [None] * 64
for x in range(64):
    cache[x] = [None] * 64
    cache2[x] = [None] * 64
    for y in range(64):
        cache[x][y] = fBm(x*freq, y*freq, 1, 3)
        cache2[x][y] = fBm(x/8, y/8, 4, 3)
        
def make_image(filename, size, freq2, buffer):
    print('generating image: ' +filename+'...')
    copies = 8
    octs = 3
    im = Image.new('RGB', (size*copies,size))

    perm2,dirs2=getseed()
    def noise2(x, y):
        def surflet(gridX, gridY):
            distX, distY = abs(x-gridX), abs(y-gridY)
            polyX = 1 - 6*distX**5 + 15*distX**4 - 10*distX**3
            polyY = 1 - 6*distY**5 + 15*distY**4 - 10*distY**3
            hashed = perm2[perm2[int(gridX)] + int(gridY)]
            grad = (x-gridX)*dirs2[hashed][0] + (y-gridY)*dirs2[hashed][1]
            return polyX * polyY * grad
        intX, intY = int(x), int(y)
        return (surflet(intX+0, intY+0) + surflet(intX+1, intY+0) +
                surflet(intX+0, intY+1) + surflet(intX+1, intY+1))

    def fBm2(x, y, octs):
        val = 0
        for o in range(octs):
            val += 0.5**o * noise2(x*2**o, y*2**o)
        return val

    highlight = (245,252,20)
    lava = (196,19,1)
    rock = (10,0,20)
    def gradient(color1, color2, d):
        d = math.sqrt(d)
        dd = 1 - d
        return (math.floor(color1[0] * d + color2[0] * dd), math.floor(color1[1] * d + color2[1] * dd), math.floor(color1[2] * d + color2[2] * dd))

    midpoint = int(size/2)

    for x in range(size*copies):
        print(f'{x+1}/{size*copies}')
        for y in range(size):
            xx = x % size
            yy = y % size
            distance = max(abs(xx-midpoint),abs(yy-midpoint))
            n1 = cache[x%64][y%64]
            n2 = fBm2(x*freq2, y*freq2, octs)
            weight1 = distance
            weight2 = max(0, (midpoint - distance))**2
            n = (n1 * weight1 + n2 * weight2)/(weight1+weight2)
            if -0.25 < n < 0.25:
                n = max(0.2,abs(n)*4)
                if n < 0.7:
                    n+= cache2[x%64][y%64]/3
                im.putpixel((x,y),gradient(lava, highlight, max(0,n)))
            else:
                im.putpixel((x,y),gradient(rock, lava, (abs(n)-0.25)*1.333))

    im.save('hr-'+filename)
    im.resize((math.floor(size*copies/2),math.floor(size/2))).save(filename)
    
make_image('lava-1.png', 64, 1.0/64, 0)
make_image('lava-2.png', 128, 1.0/64, 0)
make_image('lava-4.png', 256, 1.0/64, 0)