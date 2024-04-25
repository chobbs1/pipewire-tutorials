#! /bin/bash

gcc -Wall main.c -o main $(pkg-config --cflags --libs libpipewire-0.3)