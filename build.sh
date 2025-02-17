#!/bin/bash

#rm -rf .repo/local_manifests/
repo init -u https://github.com/crdroidandroid/android.git -b 14.0 --git-lfs

echo "--------------------------------------"
echo "Repo init success"
echo "--------------------------------------"
#repo init -u https://github.com/crdroidandroid/android.git -b 14.0 --git-lfs

# build
/opt/crave/resync.sh

echo "--------------------------------------"
echo "Sync success"
echo "--------------------------------------"

#selinux patch

echo "------------------------------------------------"
echo " We dont need selinux from Ram boost,iso,udf,aux "
echo "------------------------------------------------"

# Define search paths
SYSTEM_PRIVATE_DIR="system/sepolicy/private/"
DEVICE_DIR="device/"

# Define the patterns to search and comment out
SYSTEM_PATTERNS=(
  "genfscon proc /sys/kernel/sched_nr_migrate u:object_r:proc_sched:s0"
  "genfscon proc /sys/vm/compaction_proactiveness u:object_r:proc_drop_caches:s0"
  "genfscon proc /sys/vm/extfrag_threshold u:object_r:proc_drop_caches:s0"
  "genfscon proc /sys/vm/swap_ratio u:object_r:proc_drop_caches:s0"
  "genfscon proc /sys/vm/swap_ratio_enable u:object_r:proc_drop_caches:s0"
  "genfscon proc /sys/vm/page_lock_unfairness u:object_r:proc_drop_caches:s0"
)

DEVICE_PATTERNS=(
  "vendor.camera.aux.packageexcludelist   u:object_r:vendor_persist_camera_prop:s0"
  "vendor.camera.aux.packagelist          u:object_r:vendor_persist_camera_prop:s0"
)

ISO_UDF_PATTERNS=(
  "type iso9660, sdcard_type, fs_type, mlstrustedobject;"
  "type udf, sdcard_type, fs_type, mlstrustedobject;"
  "genfscon iso9660 / u:object_r:iso9660:s0"
  "genfscon udf / u:object_r:udf:s0"
)

# Function to search and comment lines in files
comment_lines() {
  local dir=$1
  local patterns=("${!2}")
  local msg=$3
  local found=0
  
  for pattern in "${patterns[@]}"; do
    # Find files containing the pattern
    files=$(grep -rl "$pattern" "$dir")
    
    for file in $files; do
      # Comment the line if found
      sed -i "s|$pattern|# $pattern|" "$file"
      found=1
    done
  done
  
  if [ $found -eq 1 ]; then
    echo "$msg found"
  fi
}

# Search in system/private/ and comment if found
comment_lines "$SYSTEM_PRIVATE_DIR" SYSTEM_PATTERNS[@] "ram boost"

# Search in device/ and comment if found
comment_lines "$DEVICE_DIR" DEVICE_PATTERNS[@] "aux cam"

# Search for ISO and UDF patterns
comment_lines "$DEVICE_DIR" ISO_UDF_PATTERNS[@] "iso and udf"

echo "------------------------------------------------"
echo "Selinux Patching Done"
echo "------------------------------------------------"

#sysbta patch

wget https://raw.githubusercontent.com/smiley9000/jdm_test/main/frame-1.patch 
wget https://raw.githubusercontent.com/smiley9000/jdm_test/main/frame-2.patch
wget https://raw.githubusercontent.com/smiley9000/jdm_test/main/bt.patch
wget https://raw.githubusercontent.com/smiley9000/jdm_test/main/sms.patch
wget https://raw.githubusercontent.com/smiley9000/jdm_test/main/proc.patch


echo "------------------------------------------------"
echo " Bluetooth Module"
echo "------------------------------------------------"
git apply bt.patch
echo "------------------------------------------------"
echo " Frameworks AV 1"
echo "------------------------------------------------"
git apply frame-1.patch
echo "------------------------------------------------"
echo " Frameworks AV 2"
echo "------------------------------------------------"
git apply frame-2.patch
echo "------------------------------------------------"
echo " SMSC "
echo "------------------------------------------------"
git apply sms.patch
echo "------------------------------------------------"
echo " Proc "
echo "------------------------------------------------"
git apply proc.patch

#remove trees
rm -rf device/samsung/a03s
rm -rf device/samsung/a04e
rm -rf device/samsung/a04
rm -rf device/samsung/a05m
rm -rf device/samsung/a06
rm -rf device/samsung/mt6765-jdm
rm -rf device/samsung/mt6768-jdm
rm -rf vendor/samsung/lpm-p35
rm -rf vendor/samsung/lpm-g85
rm -rf vendor/samsung/hq-camera
rm -rf vendor/samsung/wing-camera
rm -rf vendor/samsung/wing-camera-n26
rm -rf kernel/samsung/a03s
rm -rf kernel/samsung/a04e
rm -rf kernel/samsung/a05m
rm -rf kernel/samsung/a06

#a05
git clone https://github.com/Samsung-Galaxy-G85-JDM/android_device_samsung_a05m device/samsung/a05m
#a06
git clone https://github.com/Samsung-Galaxy-G85-JDM/android_device_samsung_a06 device/samsung/a06

#a04e
git clone https://github.com/Samsung-Galaxy-G85-JDM/android_device_samsung_a04e device/samsung/a04e
#a04
git clone https://github.com/Samsung-Galaxy-G85-JDM/android_device_samsung_a04 device/samsung/a04
#a03s
git clone https://github.com/Samsung-Galaxy-G85-JDM/android_device_samsung_a03s device/samsung/a03s

#Camera Tree
git clone https://github.com/Samsung-Galaxy-G85-JDM/vendor_samsung_hq-camera vendor/samsung/hq-camera
git clone https://github.com/Samsung-Galaxy-G85-JDM/android_vendor_samsung_wing-camera vendor/samsung/wing-camera
git clone https://github.com/Samsung-Galaxy-G85-JDM/android_vendor_samsung_wing-camera-n26 vendor/samsung/wing-camera-n26

#LPM Tree
git clone https://github.com/Samsung-Galaxy-G85-JDM/vendor_samsung_lpm-p35 vendor/samsung/lpm-p35
git clone https://github.com/Samsung-Galaxy-G85-JDM/vendor_samsung_lpm-g85 vendor/samsung/lpm-g85

#Common Tree
git clone https://github.com/Samsung-Galaxy-G85-JDM/android_device_samsung_mt6765-jdm  device/samsung/mt6765-jdm
git clone https://github.com/Samsung-Galaxy-G85-JDM/android_device_samsung_mt6768-jdm  device/samsung/mt6768-jdm

#kernel
#git clone https://github.com/physwizz/a042-T-kernels kernel/samsung/a04e
#git clone https://github.com/xnnnsets/android_kernel_a037f kernel/samsung/a03s
git clone https://gitlab.com/manjulahemamali/a05m kernel/samsung/a05m
#git clone https://github.com/maydoxx1/android_kernel_samsung_a04 kernel/samsung/a04


#Clang
git clone https://github.com/crdroidandroid/android_prebuilts_clang_host_linux-x86_clang-6443078 prebuilts/clang/host/linux-x86/clang-r383902
#keys
git clone https://github.com/smiley9000/hm vendor/lineage-priv/keys


# Common
. build/envsetup.sh

start build a05m
lunch lineage_a05m-ap4a-userdebug
lunch lineage_a05m-ap2a-userdebug
lunch lineage_a05m-ap1a-userdebug
lunch lineage_a05m-userdebug
lunch lineage_a05m-ap3a-userdebug

#m evolution
mka bacon -j$(nproc --all)

#start build a06
lunch lineage_a06-ap4a-userdebug
lunch lineage_a06-ap2a-userdebug
lunch lineage_a06-ap1a-userdebug
lunch lineage_a06-userdebug
lunch lineage_a06-ap3a-userdebug

#m evolution
mka bacon -j$(nproc --all)

#start build a04e
lunch lineage_a04e-ap4a-userdebug
lunch lineage_a04e-ap2a-userdebug
lunch lineage_a04e-ap1a-userdebug
lunch lineage_a04e-userdebug
lunch lineage_a04e-ap3a-userdebug

mka bacon -j$(nproc --all)

#start build a04
lunch lineage_a04-ap4a-userdebug
lunch lineage_a04-ap2a-userdebug
lunch lineage_a04-ap1a-userdebug
lunch lineage_a04-userdebug
lunch lineage_a04-ap3a-userdebug

mka bacon -j$(nproc --all)

#start build a03s
lunch lineage_a03s-ap4a-userdebug
lunch lineage_a03s-ap2a-userdebug
lunch lineage_a03s-ap1a-userdebug
lunch lineage_a03s-userdebug
lunch lineage_a03s-ap3a-userdebug

#m evolution
mka bacon -j$(nproc --all)


#a05m
if ls out/target/product/a05m/*.zip 1> /dev/null 2>&1; then
    echo "ook" 
else
    echo "rebuild with fix"
    rm -rf vendor/samsung/wing-camera
    git clone https://github.com/Samsung-Galaxy-G85-JDM/android_vendor_samsung_wing-camera -b no-chk vendor/samsung/wing-camera
    lunch lineage_a05m-ap4a-userdebug
    lunch lineage_a05m-ap2a-userdebug
    lunch lineage_a05m-ap1a-userdebug
    lunch lineage_a05m-userdebug
    lunch lineage_a05m-ap3a-userdebug

    #m evolution
    mka bacon -j$(nproc --all)
fi

#a04
if ls out/target/product/a04/*.zip 1> /dev/null 2>&1; then
    echo "ook" 
else
    echo "rebuild with fix"
    rm -rf vendor/samsung/wing-camera-n26
    git clone https://github.com/Samsung-Galaxy-G85-JDM/android_vendor_samsung_wing-camera-n26 -b no-chk vendor/samsung/wing-camera-n26 
    lunch lineage_a04-ap4a-userdebug
    lunch lineage_a04-ap2a-userdebug
    lunch lineage_a04-ap1a-userdebug
    lunch lineage_a04-userdebug
    lunch lineage_a04-ap3a-userdebug

    #m evolution
    mka bacon -j$(nproc --all)
fi





