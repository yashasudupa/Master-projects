#!/bin/bash

# url for NEST download
nest_url=https://github.com/nest/nest-simulator/archive/v2.14.0.tar.gz

# temporary build directory
build_base="$HOME/build"

# installation directory
install_base="$HOME/opt"

# number of CPUs usable for make
num_cpus=4

# ----------------------------------------------------------------------
# setup directories

nest_file=${nest_url##*/}
nest_version=${nest_file%%\.tar\.gz}
nest_dir="nest-simulator-${nest_version##v}"
build_dir="${nest_dir}-build"
install_dir=${install_base}/${nest_dir}

# check directories

echo "build directories:"
echo "  ${build_base}"
echo "  ${build_base}/${build_dir}"
echo ""
echo "install directory:"
echo "  ${install_dir}"
echo ""

echo "continue? [y/n]"
read yn
case "${yn}" in
  [yY]*) ;;
  *) exit 0 ;
esac

# get and unpack code

set +x

mkdir -p ${build_base} 2>/dev/null
cd ${build_base}

echo "downloading nest (${nest_url}) ..."
curl -LOs ${nest_url}

if [ $? -ne 0 ]; then
  echo "download failed, aborting."
  exit -1
fi

echo "unpacking nest..."
tar xzf ${nest_file}

if [ $? -ne 0 ]; then
  echo "unpacking failed, aborting."
  exit -1
fi

# setup build directory

mkdir ${build_dir} 2>/dev/null
cd ${build_dir}

# configure

echo "running cmake..."
cmake -DCMAKE_INSTALL_PREFIX:PATH="${install_dir}" -Dwith-python=3 ../${nest_dir}

if [ $? -ne 0 ]; then
  echo "cmake failed, aborting."
  exit -1
fi

# make

echo "make..."
make -j ${num_cpus}

if [ $? -ne 0 ]; then
  echo "make failed, aborting."
  exit -1
fi

# install

echo "installing..."
make install

if [ $? -ne 0 ]; then
  echo "make install failed, aborting."
  exit -1
fi

# run tests

echo "check install..."
source "${install_dir}/${nest_dir}/bin/nest_vars.sh"
make installcheck

if [ $? -eq 0 ]; then
  echo "install successful."
else
  echo "install successful, but checks failed"
fi

echo "add this to your .bashrc:"
echo "source \"${install_dir}/bin/nest_vars.sh\""
