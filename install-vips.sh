#!/bin/bash
# refresh_at 04/10/2020 14:20
vips_site=https://github.com/jcupitt/libvips/releases/download
version=$LIBVIPS_VERSION


set -e


if [ ! -v SOURCE_TARGET_DIR ]; then
  project_dir=$(pwd)
else
  project_dir=${SOURCE_TARGET_DIR}
fi

build_dir="${project_dir}/vips-${version}"
target_dir="${HOME}/vips"
build_flag="${build_dir}/build.done"


cd "${project_dir}"

if [ -f "${build_flag}" ]; then
  echo "build use cache"
  cd vips-$version
else
  echo 'Downloading libvips source'
  wget $vips_site/v$version/vips-$version.tar.gz >/dev/null 2>&1
  echo 'Extracting'
  tar xf vips-$version.tar.gz
  cd vips-$version
  echo 'Configuring'
  CXXFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 ./configure --prefix=${target_dir} $* # >/dev/null 2>&1
  echo 'Make'
  make # >/dev/null 2>&1
fi

echo 'Install'
make install # >/dev/null 2>&1
