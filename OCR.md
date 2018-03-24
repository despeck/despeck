# OCR with Despeck

To make OCR work, you need to install the following tools:

* Tesseract (version 3.x)
* ImageMagick (version 6.x)

## Installation

### MacOS

To install tesseract itself (with all languages pre-installed):

```sh
$ brew install tesseract --all-languages
```

Or you can install Tesseract with some languages manually:

```sh
$ brew install tesseract
$ mkdir -p ~/Downloads/tessdata
$ cd ~/Downloads/tessdata
$ wget https://github.com/tesseract-ocr/tessdata/raw/3.04.00/chi_sim.traineddata
```

To install ImageMagick:

```sh
$ brew install imagemagick@6
$ echo 'export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"' >> ~/.bash_profile
$ export PKG_CONFIG_PATH=/usr/local/opt/imagemagick@6/lib/pkgconfig
```

The full list of languages trained data can be found here (note, they're different for different Tesseract versions):

https://github.com/tesseract-ocr/tesseract/wiki/Data-Files#data-files-for-version-304305

### Ubuntu/Debian

```sh
$ apt-get install tesseract-ocr tesseract-ocr-chi-sim imagemagick
```

# FAQ

> **I'm getting the following error:**
>
> 'convert': No such file or directory @ rb_sysopen - /var/folders/2t/xmdrn2sd2lv2w49dv0zw9_q00000gp/T/1521805124.661379908.txt (RTesseract::ConversionError)


*This error means you don't have the appropriate Tesseract language installed (or Tesseract is unable to find that language). See language installation instructions above.*
