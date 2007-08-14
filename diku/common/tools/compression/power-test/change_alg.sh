#!/bin/bash

pushd ../../../apps/CompressionTest

rm -f compressor.h
ln -s ${1}.h compressor.h
make btnode2_2 install

popd