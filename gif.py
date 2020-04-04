# -*- coding: utf-8 -*-
import natsort, os, imageio

IMAGES_PATH = 'src/images'

images = os.listdir(IMAGES_PATH)[1:]
images = natsort.natsorted(images,reverse=False)
images = [imageio.imread(os.path.join(IMAGES_PATH, image)) for image in images]

imageio.mimsave('model.gif', images, format = 'gif', duration = 0.2)
