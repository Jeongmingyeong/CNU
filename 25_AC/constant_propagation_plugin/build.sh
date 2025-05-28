#!/bin/bash

path="/home/minkyoungj/constant_propagation_plugin/"

g++ -fplugin="${path}constprop.so" -O0 test.c -S -fdump-tree-all
