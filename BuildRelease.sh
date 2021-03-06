#!/bin/sh

#extract firmware version from header file
VER=`awk 'sub(/.*MAIN_VERSION/,""){print $1}' RepRapFirmware/src/Version.h  | awk 'gsub(/"/, "", $1)'`

OUTPUT=releases/${VER}

mkdir -p releases/${VER}

#Building Firmware + Ethernet
make distclean
make -j2 firmware BUILD=Release MBED=false NETWORKING=true ESP8266WIFI=false TMC22XX=false OUTPUT_NAME=firmware USE_DFU=false
if [ -f ./build/firmware.bin ]; then
	mv ./build/firmware.bin ${OUTPUT}/firmware-eth-notmc.bin
fi 


#Building Firmware + WIFI
make distclean
make -j2 firmware BUILD=Release MBED=false NETWORKING=false ESP8266WIFI=true OUTPUT_NAME=firmware USE_DFU=false
if [ -f ./build/firmware.bin ]; then
        mv ./build/firmware.bin ${OUTPUT}/firmware-wifi.bin
fi 

#Building Firmware + SBC
make distclean
make -j2 firmware BUILD=Release MBED=false NETWORKING=false ESP8266WIFI=false SBC=true OUTPUT_NAME=firmware USE_DFU=false
if [ -f ./build/firmware.bin ]; then
        mv ./build/firmware.bin ${OUTPUT}/firmware-sbc.bin
fi 

