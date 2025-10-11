#!/bin/bash

#rm -rf .repo/local_manifests
#rm -rf prebuilts/clang/host/linux-x86

# ROM source repo
repo init -u https://github.com/Lunaris-AOSP/android -b 16 --git-lfs
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
rm -rf vendor/infinix/X6531
rm -rf device/infinix/X6531
rm -rf device/infinix/X6531-kernel
rm -rf device/mediatek/sepolicy_vndr
rm -rf hardware/mediatek 
rm -rf vendor/mediatek/ims
rm -rf NotificationShadeWindowControllerImpl.java


echo "--------------------------------------"
echo " Clone Trees"
echo "--------------------------------------"
git clone https://github.com/smiley9000/android_device_infinix_x6531 -b ev device/infinix/X6531
git clone https://github.com/smiley9000/X6531_vndr -b bka-2 vendor/infinix/X6531
git clone https://github.com/smiley9000/android_device_infinix_X6531-kernel device/infinix/X6531-kernel
#
echo "--------------------------------------"
echo " Clone MediaTek Dependecies A15 "
echo "--------------------------------------"
#git clone https://github.com/LineageOS/android_device_mediatek_sepolicy_vndr -b lineage-22.2 device/mediatek/sepolicy_vndr
#git clone https://github.com/LineageOS/android_hardware_mediatek -b lineage-22.2 hardware/mediatek 

echo "--------------------------------------"
echo " Clone MediaTek Dependecies A16 "
echo "--------------------------------------"
git clone https://github.com/crdroidandroid/android_device_mediatek_sepolicy_vndr device/mediatek/sepolicy_vndr
git clone https://github.com/crdroidandroid/android_hardware_mediatek hardware/mediatek 
git clone https://github.com/techyminati/android_vendor_mediatek_ims vendor/mediatek/ims
echo "--------------------------------------"
echo " Clone Keys "
echo "--------------------------------------"
git clone https://gitlab.com/17101443/key vendor/lineage-priv/keys

wget https://raw.githubusercontent.com/smiley9000/jdm_test/main/NotificationShadeWindowControllerImpl.java
mv frameworks/base/packages/SystemUI/src/com/android/systemui/shade/NotificationShadeWindowControllerImpl.java STK_NotificationShadeWindowControllerImpl.java.bk
cp NotificationShadeWindowControllerImpl.java frameworks/base/packages/SystemUI/src/com/android/systemui/shade/NotificationShadeWindowControllerImpl.java

echo "--------------------------------------"
echo " Building"
echo "--------------------------------------"

. build/envsetup.sh
. b*/env*

lunch lineage_X6531-bp2a-userdebug
#lunch bliss_X6531-userdebug
#lunch bliss_X6531-bp1a-userdebug
lunch lineage_X6531-bp2a-userdebug

lunch lineage_X6531-bp2a-userdebug


m lunaris


#mka bacon




