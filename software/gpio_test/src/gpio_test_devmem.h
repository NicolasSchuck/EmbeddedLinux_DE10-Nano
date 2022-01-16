/*
 * blinkder_devmem_test.h
 *
 *  Created on: Sep 11, 2021
 *      Author: nicolas
 */

#ifndef SRC_BLINKDER_DEVMEM_TEST_H_
#define SRC_BLINKDER_DEVMEM_TEST_H_


#define GPIO_TEST_SYSFS_ENTRY "/sys/bus/platform/devices/ff240000.gpio_test"
#define GPIO_TEST_PROCFS_ENTRY "/proc/device-tree/sopc@0/bridge@0xff200000/gpio_test@0x100040000"
// Offset address of the gpio_test registers
#define GPIO_TEST_REG_SWITCHES_OFFSET 0x0
#define GPIO_TEST_REG_LEDS_OFFSET 0x0


//
// usage string
//
#define USAGE_STR "\
\n\
Usage: gpio_test_devmem [ONE-OPTION-ONLY]\n\
-s, --read_switches\n\
-l, --write_leds reg_val (each bit equals one LED -> 8-bit max)\n\
-h, --help\n\
\n\
"
//
// help string
//
#define HELP_STR "\
\n\
Only one of the following options may be passed in per invocation:\n\
\n\
-s, --read_switches\n\
Read the current switch states.\n\
\n\
-l, --read_leds\n\
Write led state (ON/OFF).\n\
\n\
-h, --help\n\
Display this help message.\n\
\n\
"



#endif /* SRC_BLINKDER_DEVMEM_TEST_H_ */
