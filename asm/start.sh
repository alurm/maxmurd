#!/usr/bin/env sh

rm -rf build
mkdir build
nasm -f bin -o build/boot.bin maxmurd.asm
# ndisasm -b 16 build/boot.bin
hexdump -C build/boot.bin
truncate -s 1474560 build/boot.bin

qemu-system-i386 \
    -name guest="maxmurd",debug-threads=on \
    -machine q35,accel=kvm,usb=off,vmport=off,dump-guest-core=off \
    -overcommit mem-lock=off \
    -drive format=raw,media=disk,file=./build/boot.bin \
    -monitor stdio \
    -display sdl \
    -s
