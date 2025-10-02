#!/bin/bash

#rm -rf .repo/local_manifests
#rm -rf prebuilts/clang/host/linux-x86

# ROM source repo
repo init -u https://github.com/PixelOS-AOSP/android_manifest.git -b sixteen --git-lfs
echo "--------------------------------------"
echo "Repo init success"
echo "--------------------------------------"


# Re-sync
/opt/crave/resync.sh
echo "--------------------------------------"
echo " Synced Successfully "
echo "--------------------------------------"


echo "--------------------------------------"
echo " Sync success"
echo "--------------------------------------"

echo "--------------------------------------"
echo " Clean Trees"
echo "--------------------------------------"
rm -rf  vendor/infinix/X6531
rm -rf  device/infinix/X6531
rm -rf device/infinix/X6531-kernel
#rm -rf NotificationShadeWindowControllerImpl.java


echo "--------------------------------------"
echo " Clone Trees"
echo "--------------------------------------"
git clone https://github.com/smiley9000/android_device_infinix_x6531 -b aosp device/infinix/X6531
git clone https://github.com/smiley9000/X6531_vndr -b bka-2 vendor/infinix/X6531
git clone https://github.com/smiley9000/android_device_infinix_X6531-kernel device/infinix/X6531-kernel
#
echo "--------------------------------------"
echo " Clone MediaTek Dependecies"
echo "--------------------------------------"
git clone https://github.com/crdroidandroid/android_device_mediatek_sepolicy_vndr device/mediatek/sepolicy_vndr
git clone https://github.com/crdroidandroid/android_hardware_mediatek hardware/mediatek 
git clone https://github.com/techyminati/android_vendor_mediatek_ims vendor/mediatek/ims

git clone https://gitlab.com/17101443/key vendor/lineage-priv/keys

#wget https://raw.githubusercontent.com/smiley9000/jdm_test/main/NotificationShadeWindowControllerImpl.java
#mv frameworks/base/packages/SystemUI/src/com/android/systemui/shade/NotificationShadeWindowControllerImpl.java STK_NotificationShadeWindowControllerImpl.java.bk
#cp NotificationShadeWindowControllerImpl.java frameworks/base/packages/SystemUI/src/com/android/systemui/shade/NotificationShadeWindowControllerImpl.java

echo "--------------------------------------"
echo " Building"
echo "--------------------------------------"

. build/envsetup.sh
lunch aosp-bp2a-userdebug

mka bacon




