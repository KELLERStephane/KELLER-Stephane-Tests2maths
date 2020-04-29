#! /usr/bin/python3
# -*- coding: utf-8 -*-

import glob
from PIL import Image

#Test validité des images jpg
img_jpg = glob.glob('*.jpg')
for i in img_jpg:
    try:
        img = Image.open(i)
        print('%s : OK' % i)
    except Exception as why:
        print('%s raise: %s' % (i, why))

#Test validité des images png
img_png = glob.glob('*.png')
for i in img_png:
    try:
        img = Image.open(i)
        print('%s : OK' % i)
    except Exception as why:
        print('%s raise: %s' % (i, why))

