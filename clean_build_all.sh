#!/bin/bash

cd sdrs
./clean_build.sh
cd ..

cd gnuradio310
./clean_build.sh
cd ..
