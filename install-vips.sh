#!/bin/bash
# refresh_at 04/10/2020 14:20
vips_site=https://github.com/jcupitt/libvips/releases/download
version=$LIBVIPS_VERSION

set -e

# do we already have the correct vips built? early exit if yes
# we could check the configure params as well I guess
if [ -d "$HOME/vips/bin" ]; then
  installed_version=$($HOME/vips/bin/vips --version)
  echo "Need vips-$version"
  echo "Found $installed_version"
  if [[ "$installed_version" =~ ^vips-$version ]]; then
    echo "Using cached directory"
    exit 0
  fi
fi

rm -rf $HOME/vips
echo 'Downloading libvips source'
wget $vips_site/v$version/vips-$version.tar.gz >/dev/null 2>&1
echo 'Extracting'
tar xf vips-$version.tar.gz
cd vips-$version
echo 'Configuring'
CXXFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 ./configure --prefix=$HOME/vips $* >/dev/null 2>&1
echo 'Make'
make >/dev/null 2>&1
echo 'Install'
make install >/dev/null 2>&1
