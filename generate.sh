# !/bin/bash

filePath=$(pwd)

echo "Export quartus prime location to PATH \n"

compile="false";
image="false";

while getopts c:i: flag
do
	case "${flag}" in
		c) compile=${OPTARG};;
		i) image=${OPTARG};;
	esac
done

echo "Compile: $compile";

export PATH="~/intelFPGA_lite/18.1/quartus/bin:$PATH"
# export PATH="~/intelFPGA_lite/18.1/quartus/sopc_builder/bin:$PATH"

if [ $compile = 'TRUE' ] || [ $compile = 'true' ];
then
	cd $filePath/DE10_Nano_SoC
	echo $filePath
	echo "Pin Assignments"
	~/intelFPGA_lite/18.1/quartus/bin/quartus_sh -t DE10_Nano_SoC.tcl
	echo "Generate qsys"
	~/intelFPGA_lite/18.1/quartus/sopc_builder/bin/qsys-generate soc_system.qsys --synthesis=VERILOG
	echo "Compile Quartus Project"
	echo "Analysis & Synthesis"
	~/intelFPGA_lite/18.1/quartus/bin/quartus_map --read_settings_files=on --write_settings_files=off DE10_Nano_SoC -c DE10_Nano_SoC
	echo "Fitter"
	~/intelFPGA_lite/18.1/quartus/bin/quartus_fit --read_settings_files=off --write_settings_files=off DE10_Nano_SoC -c DE10_Nano_SoC
	echo "Assembler"
	~/intelFPGA_lite/18.1/quartus/bin/quartus_asm --read_settings_files=off --write_settings_files=off DE10_Nano_SoC -c DE10_Nano_SoC
	echo "Timing Analysis"
	~/intelFPGA_lite/18.1/quartus/bin/quartus_sta DE10_Nano_SoC -c DE10_Nano_SoC

	#quartus_sh --flow compile ./DE10_Nano_SoC
	cd ..
else
	echo "No Compilation to be done"
fi

DIR="buildroot"

if [ ! -d $DIR ]; 
then
	echo "Get buildroot"
	git clone https://github.com/buildroot/buildroot.git
	cd buildroot
	git checkout 2018.11.x
	make clean
	
	echo "Create full_users_table.txt"

	cat > boot.script <<- "EOF"
	socfpga -1 fpga -1 =socfpga /home/socfpga /bin/sh - Socfpga user
	EOF
	
	cp ../files/.config .
else
	echo "Buildroot already exists"
fi

# echo "Run Embedded Command Shell \n"
# ~/intelFPGA/18.1/embedded/./embedded_command_shell.sh

cd $filePath/DE10_Nano_SoC

echo "Run BSP-Editor"

bsp-create-settings \
   --type spl \
   --bsp-dir software/spl_bsp \
   --preloader-settings-dir hps_isw_handoff/soc_system_hps_0 \
   --settings software/spl_bsp/settings.bsp \
   --set spl.boot.FAT_SUPPORT 'true'
   
cd software/spl_bsp
make
cd ../..

echo "Generate .rbf \n"
quartus_cpf -c -o bitstream_compression=off ./output_files/DE10_Nano_SoC.sof soc_system.rbf
#quartus_cpf -c soc_system.cof

echo "Generate .dts \n"
sopc2dts --input soc_system.sopcinfo --output soc_system.dts --type dts --board soc_system_board_info.xml --board hps_common_board_info.xml --bridge-removal all --clocks

echo "Generate .dtb \n"
dtc -I dts -O dtb -o soc_system.dtb soc_system.dts

cd $filePath/buildroot
cp ../DE10_Nano_SoC/soc_system.dts .
cp ../files/full_users_table.txt .
make

export PATH=$filePath/buildroot/output/host/usr/bin:$PATH

DIR="u-boot-socfpga"

if [ ! -d $DIR ];
then
	echo "Get u-boot repo"
	cd $filePath
	git clone https://github.com/altera-opensource/u-boot-socfpga.git
	cd u-boot-socfpga
	git checkout ACDS18.1_REL_GSRD_PR
	make mrproper
	make socfpga_cyclone5_config
	make
	
	echo "Create boot.script"

	cat > boot.script <<- "EOF"
	echo -- Programming FPGA --
	fatload mmc 0:1 $fpgadata soc_system.rbf;
	fpga load 0 $fpgadata $filesize;
	run bridge_enable_handoff;

	echo -- Setting Env Variables --
	setenv fdtimage soc_system.dtb;
	setenv mmcroot /dev/mmcblk0p2;
	setenv mmcload 'mmc rescan;${mmcloadcmd} mmc 0:${mmcloadpart} ${loadaddr} ${bootimage};${mmcloadcmd} mmc 0:${mmcloadpart} ${fdtaddr} ${fdtimage};';
	setenv mmcboot 'setenv bootargs console=ttyS0,115200 root=${mmcroot} rw rootwait; bootz ${loadaddr} - ${fdtaddr}';

	run mmcload;
	run mmcboot;
	EOF

	tools/mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "My script" -d boot.script u-boot.scr
	
	cd ..
else
	echo "u-boot already exists"
fi

cd $filePath/DE10_Nano_SoC

if [ $image = 'TRUE' ] || [ $image = 'true' ]; 
then
     	cd ..
     	sudo rm -fr sdcard
	mkdir sdcard
	cd sdcard
	cd ../sdcard
	cp ../files/genImg.sh .
	sudo sh genImg.sh
else
	echo "No Image to be done"
fi
