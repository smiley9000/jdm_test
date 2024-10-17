#!/bin/bash

rm -rf device/samsung
rm -rf device/samsung/a05m
rm -rf vendor/samsung/a05m
rm -rf frameworks/av
rm -rf device/lineage/sepolicy
rm -rf packages/modules/Bluetooth
rm -rf device/mediatek/sepolicy_vndr
sudo apt update
sudo apt install -y dos2unix
git clone https://github.com/smiley9000/android_device_samsung_a05m device/samsung/a05m
git clone https://github.com/smiley9000/vendor_samsung_a05m vendor/samsung/a05m
git clone https://github.com/smiley9000/android_frameworks_av frameworks/av
git clone https://github.com/smiley9000/android_packages_modules_Bluetooth packages/modules/Bluetooth
git clone https://github.com/smiley9000/android_device_lineage_sepolicy device/lineage/sepolicy
git clone https://github.com/smiley9000/hm vendor/lineage-priv/keys
git clone https://github.com/Roynas-Android-Playground/hardware_samsung-extra_interfaces -b lineage-21 hardware/samsung_ext
git clone https://github.com/LineageOS/android_device_mediatek_sepolicy_vndr device/mediatek/sepolicy_vndr
dos2unix device/samsung/a05m/sepolicy/private/lpm.te
source build/envsetup.sh
lunch lineage_a05m-ap2a-userdebug
make bacon 
