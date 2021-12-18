--------------------------------------------------------------------------------
README - blinker_devmem_test
--------------------------------------------------------------------------------
Author: Nicoals Schuck
Date: 19.12.21

This is software to demonstrate Led-functionality over HPS-Peripheral. The code 
is based on the code from 
"DE10-Nano_v.1.3.8_HWrevC_SystemCD/Demonstrations/SoC/hps_gpio/main.c"
               

--------------------------------------------------------------------------------
SoC EDS
--------------------------------------------------------------------------------
Start embedded command shell and create your hps_0.h header-file.

cd ~/intelFPGA/18.1/embedded
./embedded_command_shell.sh 
PATH=/home/nicolas/intelFPGA_lite/18.1/quartus/sopc_builder/bin:$PATH

cd ~/Documents/EmbeddedLinux_De1-SOC/DE1-SoC/
sopc-create-header-files --single hps_0.h --module hps_0

copy hps_0.h to lib directory of this project
copy <altera>/<version>/embedded/ip/altera/hps/altera_hps/hwlib/include/hwlib.h
copy <altera>/<version>/embedded/ip/altera/hps/altera_hps/hwlib/include/soc_cv_av/socal