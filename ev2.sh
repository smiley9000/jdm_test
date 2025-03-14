#!/bin/bash


echo "--------------------------------------"
echo "Repo init success"
echo "--------------------------------------"


# build

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

wget https://raw.githubusercontent.com/smiley9000/jdm_test/main/frame-1-15.patch 
wget https://raw.githubusercontent.com/smiley9000/jdm_test/main/frame-2-15.patch
wget https://raw.githubusercontent.com/smiley9000/jdm_test/main/bt-15.patch
wget https://raw.githubusercontent.com/smiley9000/jdm_test/main/sms-15.patch
wget https://raw.githubusercontent.com/smiley9000/jdm_test/main/proc.patch


echo "------------------------------------------------"
echo " Patching sysbta"
echo "------------------------------------------------"

echo "------------------------------------------------"
echo " Bluetooth Module"
echo "------------------------------------------------"

git apply bt-15.patch
echo "------------------------------------------------"
echo " Frameworks AV 1"
echo "------------------------------------------------"
git apply frame-1-15.patch
echo "------------------------------------------------"
echo " Frameworks AV 2"
echo "------------------------------------------------"
git apply frame-2-15.patch
echo "------------------------------------------------"
echo "SYSBTA Patching Done"
echo "------------------------------------------------"
git apply sms-15.patch
git apply proc.patch

#remove trees
rm -rf device/samsung/a05m
rm -rf vendor/samsung/a05m

#clone
git clone https://github.com/smiley9000/android_device_samsung_a05m -b evo-10.1 device/samsung/a05m
git clone https://github.com/smiley9000/vendor_samsung_a05m vendor/samsung/a05m
git clone https://github.com/smiley9000/hm vendor/lineage-priv/keys
git clone https://github.com/Roynas-Android-Playground/hardware_samsung-extra_interfaces -b lineage-21 hardware/samsung_ext
git clone https://github.com/LineageOS/android_device_mediatek_sepolicy_vndr device/mediatek/sepolicy_vndr
git clone https://github.com/crdroidandroid/android_prebuilts_clang_host_linux-x86_clang-6443078 prebuilts/clang/host/linux-x86/clang-r383902
git clone https://gitlab.com/manjulahemamali/a05m kernel/samsung/a05m

#convert to unix
dos2unix device/samsung/a05m/sepolicy/private/lpm.te

#start build
 . build/envsetup.sh
source build/envsetup.sh
lunch lineage_a05m-userdebug
lunch lineage_a05m-ap2a-userdebug
lunch lineage_a05m-ap3a-userdebug
lunch lineage_a05m-ap4a-userdebug
lunch lineage_a05m-ap1a-userdebug
m evolution




