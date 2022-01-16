# !/bin/bash

#echo "Generate Image \n"

#echo "Delete rootfs/.img \n"

sudo rm -rf rootfs
sudo rm de10-nano_soc-sd-card.img

#echo "Copy lates files \n"

cp ../files/make_sdimage_p3.py .

cp ../buildroot/output/images/rootfs.tar .

cp ../buildroot/output/images/u-boot.img .

cp ../buildroot/output/images/zImage .

cp ../DE10_Nano_SoC/soc_system.dtb .

cp ../DE10_Nano_SoC/soc_system.rbf .

cp ../DE10_Nano_SoC/software/spl_bsp/preloader-mkpimage.bin .

cp ../DE10_Nano_SoC/software/spl_bsp/u-boot-socfpga/u-boot.scr .

#echo "Untar rootfs \n"

mkdir rootfs
cd rootfs
sudo tar -xvf ../rootfs.tar
cd ..

#echo "Generate Image \n"

sudo python3 ./make_sdimage_p3.py \
-f \
-P preloader-mkpimage.bin,num=3,format=raw,size=1M,type=A2 \
-P rootfs/*,num=2,format=ext3,size=512M \
-P zImage,u-boot.img,u-boot.scr,soc_system.rbf,soc_system.dtb,num=1,format=vfat,size=511M \
-s 1024M \
-n de10-nano_soc-sd-card.img

#echo "Exit \n"
