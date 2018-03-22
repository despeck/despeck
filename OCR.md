# OCR with Despeck

To make OCR work, you need to install the following tools:

* Tesseract (version 3.x)
* ImageMagick (version 6.x)

## Installation

### MacOS

To install tesseract itself:

```sh
$ brew install tesseract --all-languages
$ brew install imagemagick
```

Or you can install tesseract with some languages manually:

```sh
$ brew install tesseract wget imagemagick
$ mkdir -p ~/Downloads/tessdata
$ cd ~/Downloads/tessdata
$ wget https://github.com/tesseract-ocr/tessdata/raw/3.04.00/chi_sim.traineddata
```

The full list of languages trained data can be found here (note, they're different for different Tesseract versions):

https://github.com/tesseract-ocr/tesseract/wiki/Data-Files#data-files-for-version-304305

### Ubuntu/Debian

```sh
$ apt-get install tesseract-ocr tesseract-ocr-chi-sim imagemagick
```
