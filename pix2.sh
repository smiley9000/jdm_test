#!/bin/bash

#rm -rf .repo/local_manifests/
repo init -u https://github.com/crdroidandroid/android.git -b 16.0 --git-lfs --no-clone-bundle

echo "--------------------------------------"
echo " Repo init success"
echo "--------------------------------------"


# build
/opt/crave/resync.sh

echo "--------------------------------------"
echo " Sync success"
echo "--------------------------------------"

echo "--------------------------------------"
echo " Clean Trees"
echo "--------------------------------------"
rm -rf  vendor/infinix/X6531
rm -rf  device/infinix/X6531
rm -rf device/infinix/X6531-kernel
rm -rf NotificationShadeWindowControllerImpl.java


echo "--------------------------------------"
echo " Clone Trees"
echo "--------------------------------------"
git clone https://github.com/smiley9000/android_device_infinix_x6531 -b lineage-23.0 device/infinix/X6531
git clone https://github.com/smiley9000/X6531_vndr -b bka-2 vendor/infinix/X6531
git clone https://github.com/smiley9000/android_device_infinix_X6531-kernel device/infinix/X6531-kernel

echo "--------------------------------------"
echo " Clone MediaTek Dependecies"
echo "--------------------------------------"
git clone https://github.com/crdroidandroid/android_device_mediatek_sepolicy_vndr device/mediatek/sepolicy_vndr
git clone https://github.com/crdroidandroid/android_hardware_mediatek hardware/mediatek 

git clone https://gitlab.com/17101443/key vendor/lineage-priv/keys

wget https://raw.githubusercontent.com/smiley9000/jdm_test/main/NotificationShadeWindowControllerImpl.java

mv frameworks/base/packages/SystemUI/src/com/android/systemui/shade/NotificationShadeWindowControllerImpl.java NotificationShadeWindowControllerImpl.java.bk
cp NotificationShadeWindowControllerImpl.java frameworks/base/packages/SystemUI/src/com/android/systemui/shade/NotificationShadeWindowControllerImpl.java

echo "--------------------------------------"
echo " Building"
echo "--------------------------------------"

. build/envsetup.sh
lunch lineage_X6531-bp1a-userdebug
lunch lineage_X6531-bp2a-userdebug
make bacon



