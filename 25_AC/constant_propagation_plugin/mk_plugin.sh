#!/bin/bash

path="/home/minkyoungj/constant_propagation_plugin/"

g++ -fPIC -shared -o "${path}constprop.so" "${path}constprop.cc" \
  -I"$(gcc -print-file-name=plugin)/include" \
  -I"$(gcc -print-file-name=include)" \
  -fno-rtti

