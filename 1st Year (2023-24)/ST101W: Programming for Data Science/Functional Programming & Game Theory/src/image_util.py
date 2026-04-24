'''
This module loads and displays images
'''

from PIL import Image
import numpy as np
import matplotlib.pyplot as plt

def load(path):
    '''
    Get an image in the form of 3d numpy array from the given path
    path: string
        file directory location of the image

    return: 3d numpy ndarray with dtype np.uint8
        image
    '''
    img = Image.open(path, 'r')
    img = np.asarray(img, dtype=np.uint8)[:,:,:3].copy()
    return img

def show(img):
    '''
    Show the given image
    img: non-empty 3d numpy ndarray with dtype np.uint8
        image to show
    return: None
    '''
    plt.close()
    dpi = 120
    height, width, _ = img.shape
    figsize = (width/dpi, height/dpi)
    fig = plt.figure(figsize=figsize)
    plt.axis('off')
    plt.imshow(img)