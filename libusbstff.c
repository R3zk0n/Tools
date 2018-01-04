#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <libusb-1.0/libusb.h>
// Functions prolog.

//Colors are lit. 
#define KNRM  "\x1B[0m"
#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KBLU  "\x1B[34m"
#define KMAG  "\x1B[35m"
#define KCYN  "\x1B[36m"
#define KWHT  "\x1B[37m"



static void print_endpoint_comp(const struct libusb_ss_endpoint_companion_descriptor *ep_comp)
{
	printf("USB 3.0 Endpoint Companion:\n");
	printf("bMaxBurst:        %d\n", ep_comp->bMaxBurst);
	printf("bmAttributes:     0x%02x\n", ep_comp->bmAttributes);
	printf("wBytesPerInterval: %d\n", ep_comp->wBytesPerInterval);
	if (ep_comp->wBytesPerInterval < 9)
	{
		printf("%sNot USB 3.0 Companion %d\n", desc.idVendor, KRED);
		printf("%s", KNRM);
	}
}




void print_devices(libusb_device *dev)
{
    struct libusb_device_descriptor desc;
    struct libusb_config_descriptor *config;
    const struct libusb_interface *inter;
    const struct libusb_interface_descriptor *interdesc;
    const struct libusb_endpoint_descriptor *endpointdesc;
    libusb_device_handle *handle = NULL; 
    int ret; 
    int a, b, c; 
    char active;
    char string[256];
    unsigned char strDesc[256]; //BFYO
    int retVal = 0; 
    ret = libusb_get_device_descriptor(dev, &desc);

    if (ret < 0)
    {
        fprintf(stderr, "error in getting descriptor\n\n");
        return; 
    }
 	
    printf("Device Class %d\n", desc.idVendor);
    printf("Product ID %d\n", desc.idProduct);    
    printf("Serial:%5x\n", desc.iSerialNumber); 
    active = libusb_get_active_config_descriptor(dev, &config);
   
    //if (desc.iSerialNumber) {
    //    ret = libusb_get_string_descriptor_ascii(handle, desc.iSerialNumber, string, sizeof(string));
      //  if (ret > 0)
        //    printf("Serial Number %s\n", string);
   // } 
   
    if (active != 0)
    {
        fprintf(stderr, "Error on active config descriptor\n\n");
    }
}
// main program
int main(int argc, char *argv[])
{
  libusb_context *context = NULL;
  struct libusb_device **devs;
  struct libusb_device_descriptor info;
  unsigned count,i;
  
  int rv=0;
  // init USB lib (this is the 1.0 lib)
  if (libusb_init(NULL)<0) 
    {
      printf("Can't open libusb\n");
      return 0;
    }
  // get list of devices and counts
  count=libusb_get_device_list(NULL,&devs);
  printf("%d USB devices found\n", count);
  if (count<=0)
    {
      printf("Error enumerating devices\n");
      return 2;
    }
  // walk the list, read descriptors, and dump some output from each
  for (i=0;i<count;i++)
    {
      libusb_get_device_descriptor(devs[i],&info);
      print_devices(devs[i]);
      print_endpoint_comp(&info);
      printf("%s", KGRN);
      printf("VID=%04x PID=%04x\n",info.idVendor,info.idProduct);
      printf("%s", KNRM);
    }
  libusb_free_device_list(devs,1);
  libusb_exit(NULL);
  return rv;
   