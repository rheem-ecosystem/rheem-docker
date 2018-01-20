#!/usr/bin/env bash

echo ""

echo -e "\nbuild docker hadoop image\n"
sudo docker build -t rheem/rheem:1.0 .

echo ""