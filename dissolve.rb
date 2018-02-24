# frozen_string_literal: true

require 'vips'
require 'pry'
require 'tty-progressbar'

image = Vips::Image.new_from_file('samples/red-circle/a.jpg')

# the colour we search for as a CIELAB coordinate
# match = [54.64, 61.16, 51.76]
# match = [100, 0, 0]

# # calculate dE 1976 colour difference
# distance = image.dE76(image.new_from_image(match))

# # swap pixels more than 50 away for white
# image = (distance > 10).ifthenelse([255, 255, 255], image)

# Preprocess: remove white noise from scanning
distance = Vips::Image.sum(((image - [255, 255, 255]) ** 2).bandsplit) ** 0.5

# swap pixels more than 50 away for white
image = (distance < 50).ifthenelse([255, 255, 255], image)

# the colour we search for as a CIELAB coordinate
match = [54.64, 61.16, 51.76]
distance = image.dE76(image.new_from_image(match))
image = (distance > 55).ifthenelse([255, 255, 255], image)

image.write_to_file('output/a.jpg')
