/*
 ============================================================================
 Name        : custom_counter_de10_nano.c
 Author      : Nicolas Schuck
 Version     :
 Copyright   : Your copyright notice
 Description : Hello World in C, Ansi-style
 ============================================================================
 */

#define DEBUG

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <dirent.h>
#include "custom_counter_de10_nano.h"
#include "hwlib.h"
#include "socal.h"
#include "hps.h"
#include "hps_0.h"

//setting for the HPS2FPGA AXI Bridge
#define ALT_AXI_FPGASLVS_OFST (0xc0000000) // axi_master
#define HW_FPGA_AXI_SPAN (0x40000000) // Bridge span 1GB
#define HW_FPGA_AXI_MASK ( HW_FPGA_AXI_SPAN - 1 )

// funciton prototypes
void validate_soc_system(void);

int main(void) {
    int fd;

    void *axi_virtual_base;
    void *h2p_counter_addr;

    //validate the features of the actual hardware
    //validate_soc_system();

    if(( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 )
    {
        printf( "ERROR: could not open \"/dev/mem\"...\n" );
        return( 1 );
    }

    //HPS-to-FPGA bridge
    axi_virtual_base = mmap( NULL, HW_FPGA_AXI_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd,ALT_AXI_FPGASLVS_OFST );

    if( axi_virtual_base == MAP_FAILED )
    {
        printf( "ERROR: axi mmap() failed...\n" );
        close( fd );
        return( 1 );
    }

    h2p_counter_addr=axi_virtual_base + ((unsigned long)(0x0 + CUSTOM_COUNTER_0_BASE) & (unsigned long)(HW_FPGA_AXI_MASK));
    uint32_t count = 0;

    while(1) {
        printf("%lu \n", (unsigned long)count);
        usleep(1000*500);
        count = *((uint32_t *)h2p_counter_addr);
    }

    if( munmap( axi_virtual_base, HW_FPGA_AXI_SPAN ) != 0 )
    {
        printf( "ERROR: axi munmap() failed...\n" );
        close( fd );
        return( 1 );
    }

    close (fd);

    return(0);
}

void
    validate_soc_system
        (void)
{
    const char *dirname;
    DIR *ds;

    //verify that the blinker device entry exists in the sysfs
    dirname = GPIO_TEST_SYSFS_ENTRY;
    ds = opendir(dirname);

    if(ds == NULL)
    {
        printf("ERROR: blinker may not be present in the system hardware");
        exit(EXIT_FAILURE);
    }

    if(closedir(ds))
    {
        printf("ERROR: blinker may not be present in the system hardware");
        exit(EXIT_FAILURE);
    }
}
