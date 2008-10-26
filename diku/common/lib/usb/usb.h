
#ifndef _H_usb_H
#define _H_usb_H

#include <byteorder.h>

#ifdef BIG_ENDIAN
#define usbToHost16(x) _BSWAP_UINT16(x)
#define hostToUsb16(x) _BSWAP_UINT16(x)
#define usbToHost32(l) _BSWAP_UINT32(l)
#define hostToUsb32(l) _BSWAP_UINT32(l)
#else
#define usbToHost16(x) x
#define hostToUsb16(x) x
#define usbToHost32(l) l
#define hostToUsb32(l) l
#endif

/**
 * Setup packet types
 */

typedef struct {
  uint8_t  bmRequestType;
  uint8_t  bRequest;
  uint16_t wValue;
  uint16_t wIndex;
  uint16_t wLength;
} usb_setup_pkt_t;			// End of Setup Packet Type

typedef enum {
  USB_EP_DISABLED = 0,
  USB_EP_IN       = 1,
  USB_EP_OUT      = 2,
  USB_EP_INISO    = 3,
  USB_EP_OUTISO   = 4
} usb_ep_config_t;


typedef enum {
  USB_LOW_SPEED  = 0,
  USB_FULL_SPEED = 1,
  USB_HIGH_SPEED = 2
} usb_mode_t;

typedef enum {
  USB_RECEIVE_FOLLOW_SETUP = 0,
  USB_SETUP_DONE = 1
} usb_device_request_t;

// Device Request Direction (bmRequestType bit7)
enum {
  USB_DRD_MASK = 0x80,		// Mask for device request direction
  USB_DRD_OUT  = 0x00,		// OUT: host to device
  USB_DRD_IN   = 0x80		// IN:	device to host
};

// Request Codes (bRequest)
enum {
  USB_GET_STATUS	= 0x00,
  USB_CLEAR_FEATURE	= 0x01,
  USB_SET_FEATURE	= 0x03,
  USB_SET_ADDRESS	= 0x05,
  USB_GET_DESCRIPTOR	= 0x06,
  USB_SET_DESCRIPTOR	= 0x07,
  USB_GET_CONFIGURATION	= 0x08,
  USB_SET_CONFIGURATION	= 0x09,
  USB_GET_INTERFACE	= 0x0A,
  USB_SET_INTERFACE	= 0x0B,
  USB_SYNCH_FRAME	= 0x0C
};

// Device Request Type (bmRequestType)
enum {
  USB_BMREQUEST_MASK     = 0x60,      // Mask for device request type
  USB_REQUEST_VENDOR     = 0x40,       // Vendor specific request
  USB_REQUEST_CLASS      = 0x20,	  // Class specific request
  USB_REQUEST_STD        = 0x00	  // Standard device request
};

// Device Request Recipient (bmRequestType bit4-0)
#define DRR_MASK				0x1F		// Mask for device request recipient
#define DRR_DEVICE				0x00		// Device
#define DRR_INTERFACE			0x01		// Interface
#define DRR_ENDPOINT			0x02		// Endpoint

// Define bmRequestType bitmaps
#define USB_OUT_DEVICE		(DRD_OUT | USB_REQUEST_STD | DRR_DEVICE)		
// Request made to device,
#define USB_IN_DEVICE		(USB_DRD_IN  | USB_REQUEST_STD | DRR_DEVICE)	
// Request made to device,
#define USB_OUT_INTERFACE	(DRD_OUT | USB_REQUEST_STD | DRR_INTERFACE)		
// Request made to interface,
#define USB_IN_INTERFACE	(USB_DRD_IN  | USB_REQUEST_STD | DRR_INTERFACE)	
// Request made to interface,
#define USB_OUT_ENDPOINT	(DRD_OUT | USB_REQUEST_STD | DRR_ENDPOINT)		
// Request made to endpoint,
#define USB_IN_ENDPOINT		(USB_DRD_IN  | USB_REQUEST_STD | DRR_ENDPOINT)	
// Request made to endpoint,

#define USB_OUT_CL_INTERFACE	(DRD_OUT | DRT_CLASS | DRR_INTERFACE)
// Request made to class interface,
#define USB_IN_CL_INTERFACE	(USB_DRD_IN  | DRT_CLASS | DRR_INTERFACE)	
// Request made to class interface,

#define USB_OUT_VR_INTERFACE	(DRD_OUT | DRT_VENDOR | DRR_INTERFACE)
// Request made to vendor interface,
#define USB_IN_VR_INTERFACE	(USB_DRD_IN  | DRT_VENDOR | DRR_INTERFACE)	
// Request made to vendor interface,

// Descriptor type (GET_DESCRIPTOR and SET_DESCRIPTOR)
#define USB_DESCRIPTOR_DEVICE	 0x01
#define USB_DESCRIPTOR_CONFIG    0x02
#define USB_DESCRIPTOR_STRING    0x03
#define USB_DESCRIPTOR_INTERFACE 0x04
#define USB_DESCRIPTOR_ENDPOINT  0x05
#define USB_DESCRIPTOR_DEVICE_AULIFIER 0x6 // USB2.0 only
#define USB_DECRIPTROR_OTHER_SPEED     0x7 // USB2.0 only

// Define wValue bitmaps for Standard Feature Selectors
#define DEVICE_REMOTE_WAKEUP	0x01    // Remote wakeup feature(not used)
#define ENDPOINT_HALT		0x00	// Endpoint_Halt feature selector

/**
 * Device Descriptor
 */

typedef struct {
   uint8_t  bLength;
   uint8_t  bDescriptorType;
   uint16_t bcdUSB;
   uint8_t  bDeviceClass;                  // Device Class Code
   uint8_t  bDeviceSubClass;               // Device Subclass Code
   uint8_t  bDeviceProtocol;               // Device Protocol Code
   uint8_t  bMaxPacketSize0;               // Maximum Packet Size for EP0
   uint16_t idVendor;                      // Vendor ID
   uint16_t idProduct;                     // Product ID
   uint16_t bcdDevice;                     // Device Release Number in BCD
   uint8_t  iManufacturer;                 // Index of String Desc for Manufacturer
   uint8_t  iProduct;                      // Index of String Desc for Product
   uint8_t  iSerialNumber;                 // Index of String Desc for SerNo
   uint8_t  bNumConfigurations;            // Number of possible Configurations
} usb_device_descriptor_t;                   // End of Device Descriptor Type


// Descriptor types
enum {
  USB_DESCRIPTOR_TYPE_DEVICE	   = 0x01,
  USB_DESCRIPTOR_TYPE_CONFIG	   = 0x02,
  USB_DESCRIPTOR_TYPE_STRING       = 0x03,
  USB_DESCRIPTOR_TYPE_INTERFACE    = 0x04,
  USB_DESCRIPTOR_TYPE_ENDPOINT     = 0x05,
// class specific descriptor types
  USB_DESCRIPTOR_SUBTYPE_CS_HEADER_FUNC	= 0x00,
  USB_DESCRIPTOR_SUBTYPE_CS_CALL_MAN    = 0x01,
  USB_DESCRIPTOR_SUBTYPE_CS_ABST_CNTRL  = 0x02,
  USB_DESCRIPTOR_SUBTYPE_CS_UNION_FUNC  = 0x06,
  USB_DESCRIPTOR_TYPE_CS_INTERFACE = 0x24 
};

#define VER_USB				0x0200
#define EP0_PACKET_SIZE			0x40
#define VID				0x16C0
#define PID				0x06EC
#define DSC_NUM_INTERFACE		2
#define DSC_NUM_STRING			4
#define DEV_REV				0x0000

const usb_device_descriptor_t MyDeviceDesc __attribute__((code)) = {
	18,
	//sizeof(usb_device_descriptor_t),
	USB_DESCRIPTOR_TYPE_DEVICE,
	hostToUsb16( VER_USB ),
	0x02,
	0x00,
	0x00,
	EP0_PACKET_SIZE,
	hostToUsb16( VID ),
	hostToUsb16( PID ),
	hostToUsb16( DEV_REV ),
	0x01,
	0x02,
	0x03,
	0x01
};

/**
 * Configuration Descriptor
 */

typedef struct {
   uint8_t bLength;                       // Size of this Descriptor in Bytes
   uint8_t bDescriptorType;               // Descriptor Type (=2)
   uint16_t wTotalLength;                  // Total Length of Data for this Conf
   uint8_t bNumInterfaces;                // # of Interfaces supported by Conf
   uint8_t bConfigurationValue;           // Designator Value for *this* Conf
   uint8_t iConfiguration;                // Index of String Desc for this Conf
   uint8_t bmAttributes;                  // Configuration Characteristics
   uint8_t bMaxPower;                     // Max. Power Consumption in Conf (*2mA)
} configuration_descriptor_t;            // End of Configuration Descriptor Type

typedef struct {
   uint8_t bLength;                       // Size of this Descriptor in Bytes
   uint8_t bDescriptorType;               // Descriptor Type (=4)
   uint8_t bInterfaceNumber;              // Number of *this* Interface (0..)
   uint8_t bAlternateSetting;             // Alternative for this Interface
   uint8_t bNumEndpoints;                 // No of EPs used by this IF (excl. EP0)
   uint8_t bInterfaceClass;               // Interface Class Code
   uint8_t bInterfaceSubClass;            // Interface Subclass Code
   uint8_t bInterfaceProtocol;            // Interface Protocol Code
   uint8_t iInterface;                    // Index of String Desc for Interface
} interface_descriptor_t;                // End of Interface Descriptor Type

typedef struct {
   uint8_t bLength;                       // Size of this Descriptor in Bytes
   uint8_t bDescriptorType;               // Descriptor Type (=5)
   uint8_t bEndpointAddress;              // Endpoint Address (Number + Direction)
   uint8_t bmAttributes;                  // Endpoint Attributes (Transfer Type)
   uint16_t wMaxPacketSize;                // Max. Endpoint Packet Size
   uint8_t bInterval;                     // Polling Interval (Interrupt) ms
} endpoint_descriptor_t;                 // End of Endpoint Descriptor Type

typedef struct {
    uint8_t bLength;
    uint8_t bDescriptorType;
    uint8_t bDescriptorSubtype;
    uint16_t bcdCDC;
} header_func_descriptor_t;

typedef struct {
    uint8_t bLength;
    uint8_t bDescriptorType;
    uint8_t bDescriptorSubtype;
    uint8_t bmCapabilities;
    uint8_t bDataInterface;
} call_man_func_descriptor_t;

typedef struct {
    uint8_t bLength;
    uint8_t bDescriptorType;
    uint8_t bDescriptorSubtype;
    uint8_t bmCapabilities;
} abst_control_mana_descriptor_t;

typedef struct {
  uint8_t bLength;
  uint8_t bDescriptorType;
  uint8_t bDescriptorSubtype;
  uint8_t bMasterInterface;
  uint8_t bSlaveInterface0;
} union_func_descriptor_t;

typedef struct {
  configuration_descriptor_t		config_desc;
    interface_descriptor_t		interface_desc_0;
    header_func_descriptor_t		header_func_desc;
    call_man_func_descriptor_t		call_man_desc;
    abst_control_mana_descriptor_t	abst_control_desc;
    union_func_descriptor_t		union_func_desc;
    endpoint_descriptor_t		endpoint_desc_IN1;
  interface_descriptor_t		interface_desc_1;
    endpoint_descriptor_t		endpoint_desc_IN2;
    endpoint_descriptor_t		endpoint_desc_OUT2;
} configuration_desc_set_t;

#define EP1_PACKET_SIZE			0x0010
#define EP2_PACKET_SIZE			0x0040

#define IN_EP1				0x81
#define OUT_EP1				0x01
#define IN_EP2				0x82
#define OUT_EP2				0x02

#define DSC_EP_CONTROL			0x00
#define DSC_EP_ISOC                     0x01
#define DSC_EP_BULK			0x02
#define DSC_EP_INTERRUPT		0x03

const configuration_desc_set_t MyConfigDescSet __attribute__((code)) = {
  {					  // Configuration descriptor
    sizeof(configuration_descriptor_t),	  // bLength
    USB_DESCRIPTOR_TYPE_CONFIG,                      // bDescriptorType
    hostToUsb16( sizeof(configuration_desc_set_t) ),// bTotalLength
    DSC_NUM_INTERFACE,                    // bNumInterfaces
    0x01,				  // bConfigurationValue
    0x00,				  // iConfiguration
    0x80,				  // bmAttributes
    0x0F				  // bMaxPower
  },
  {					  // Interface(0) - Communication Class
    sizeof(interface_descriptor_t),	  // bLength
    USB_DESCRIPTOR_TYPE_INTERFACE,        // bDescriptorType
    0x00,				  // bInterfaceNumber
    0x00,				  // bAlternateSetting
    0x01,				  // bNumEndpoints
    0x02,				  // bInterfaceClass (Communication Class)
    0x02,				  // bInterfaceSubClass (Abstract Control Model)
    0x01,				  // bInterfaceProcotol (V.25ter, Common AT commands)
    0x00				  // iInterface
  },
  {					  // Header Functional Descriptor
    sizeof(header_func_descriptor_t),	  // bLength
    USB_DESCRIPTOR_TYPE_CS_INTERFACE,	  // bDescriptorType (CS_INTERFACE)
    USB_DESCRIPTOR_SUBTYPE_CS_HEADER_FUNC,// bDescriptorSubtype (Header Functional)
    hostToUsb16(0x0110)			  // bcdCDC (CDC spec release number, 1.1)
  },
  {					  // Call Management Functional Descriptor
    sizeof(call_man_func_descriptor_t),	  // bLength
    USB_DESCRIPTOR_TYPE_CS_INTERFACE,	  // bDescriptorType (CS_INTERFACE)
    USB_DESCRIPTOR_SUBTYPE_CS_CALL_MAN,	  // bDescriptorSubtype (Call Management)
    0x01,				  // bmCapabilities (only over Communication Class IF / handles itself)
    0x01				  // bDataInterface (Interface number of Data Class interface)
  },
  {					   // Abstract Control Management Functional Descriptor
    sizeof(abst_control_mana_descriptor_t),// bLength
    USB_DESCRIPTOR_TYPE_CS_INTERFACE,	   // bDescriptorType (CS_INTERFACE)
    USB_DESCRIPTOR_SUBTYPE_CS_ABST_CNTRL,  // bDescriptorSubtype (Abstract Control Management)
    0x06				   // bmCapabilities (Supports Send_Break, Set_Line_Coding, Set_Control_Line_State,
	 	                           // Get_Line_Coding, and the notification Serial_State)
  },
  {					   // Union Functional Descriptor
    sizeof(union_func_descriptor_t),	   // bLength
    USB_DESCRIPTOR_TYPE_CS_INTERFACE,	   // bDescriptorType (CS_INTERFACE)
    USB_DESCRIPTOR_SUBTYPE_CS_UNION_FUNC,  // bDescriptorSubtype (Union Functional)
    0x00,				   // bMasterInterface (Interface number master interface in the union)
    0x01				   // bSlaveInterface0 (Interface number slave interface in the union)
  },
  {					// Endpoint1
    sizeof(endpoint_descriptor_t),	// bLength
    USB_DESCRIPTOR_TYPE_ENDPOINT,       // bDescriptorType
    IN_EP1,				// bEndpointAddress
    DSC_EP_INTERRUPT,	                // bmAttributes
    hostToUsb16( EP1_PACKET_SIZE ),	// MaxPacketSize
    1					// bInterval
  },
  {					// Interface(1) - Data Interface Class
    sizeof(interface_descriptor_t),	// bLength
    USB_DESCRIPTOR_TYPE_INTERFACE,      // bDescriptorType
    0x01,				// bInterfaceNumber
    0x00,				// bAlternateSetting
    0x02,				// bNumEndpoints
    0x0A,				// bInterfaceClass (Data Interface Class)
    0x00,				// bInterfaceSubClass
    0x00,				// bInterfaceProcotol (No class specific protocol required)
    0x00				// iInterface
  },
  {					// Endpoint IN 2 descriptor
    sizeof(endpoint_descriptor_t),	// bLength
    USB_DESCRIPTOR_TYPE_ENDPOINT,       // bDescriptorType
    IN_EP2,				// bEndpointAddress
    DSC_EP_BULK,		        // bmAttributes
    hostToUsb16( EP2_PACKET_SIZE ),     // MaxPacketSize
    0					// bInterval
  },
  {					// Endpoint OUT 2 descriptor
    sizeof(endpoint_descriptor_t),	// bLength
    USB_DESCRIPTOR_TYPE_ENDPOINT,	// bDescriptorType
    OUT_EP2,			        // bEndpointAddress
    DSC_EP_BULK,		        // bmAttributes
    hostToUsb16( EP2_PACKET_SIZE ),     // MaxPacketSize
    0					// bInterval
  }
}; //end of Configuration

#define STR0LEN 4
const uint8_t String0Desc[STR0LEN] __attribute__((code)) = {
  STR0LEN, USB_DESCRIPTOR_TYPE_STRING, 0x09, 0x04
};

#define STR1LEN sizeof("Polaric")*2

const uint8_t String1Desc[STR1LEN] __attribute__((code)) = {
	STR1LEN, USB_DESCRIPTOR_TYPE_STRING,
	'P', 0,
	'o', 0,
	'l', 0,
	'a', 0,
	'r', 0,
	'i', 0,
	'c', 0
};

#define STR2LEN sizeof("SWM1702DK")*2
const uint8_t String2Desc[STR2LEN] __attribute__((code)) = {
	STR2LEN, USB_DESCRIPTOR_TYPE_STRING,
	'S', 0,
	'W', 0,
	'M', 0,
	'1', 0,
	'7', 0,
	'0', 0,
	'2', 0,
	'D', 0,
	'K', 0
};

#define STR3LEN sizeof("0001")*2

const uint8_t  String3Desc[STR3LEN] __attribute__((code))= {
	STR3LEN, USB_DESCRIPTOR_TYPE_STRING,
	'0', 0,
	'0', 0,
	'0', 0,
	'1', 0
};

const uint8_t *StringDescTable[4] __attribute__((code)) = {
  String0Desc,
  String1Desc,
  String2Desc,
  String3Desc
};

const uint8_t OnesPacket[2] __attribute__((code)) = {1,0};
const uint8_t ZerosPacket[2] __attribute__((code)) = {1,0};

/* typedef struct { */
/* 	configuration_descriptor_t ConfigDescriptor; */
/* 	interface_descriptor_t InterfaceDescriptor; */
/*   	endpoint_descriptor_t EndpointDescriptor0; */
/* 	endpoint_descriptor_t EndpointDescriptor1; */
/* } USB_CONFIG_DATA; */

/* const USB_CONFIG_DATA ConfigurationDescriptor __attribute((code)) = { */
/*     {                              /\* configuration descriptor *\/ */
/*     sizeof(configuration_descriptor_t), /\* bLength *\/ */
/*     USB_DESCRIPTOR_TYPE_CONFIG, /\* bDescriptorType *\/ */
/*     hostToUsb16(sizeof(USB_CONFIG_DATA)),       /\* wTotalLength *\/ */
/*     1,                             /\* bNumInterfaces *\/ */
/*     1,                             /\* bConfigurationValue *\/ */
/*     0,                             /\* iConfiguration String Index *\/ */
/*     0x80,                          /\* bmAttributes Bus Powered, No Remote Wakeup *\/ */
/*     0x32                           /\* bMaxPower, 100mA *\/  */
/*     }, */
/*     {                              /\* interface descriptor *\/ */
/*     sizeof(interface_descriptor_t), /\* bLength *\/ */
/*     USB_DESCRIPTOR_TYPE_INTERFACE,     /\* bDescriptorType *\/ */
/*     0,                             /\* bInterface Number *\/ */
/*     0,                             /\* bAlternateSetting *\/ */
/*     2,                             /\* bNumEndpoints *\/ */
/*     0x0,                          /\* bInterfaceClass (Vendor specific) *\/ */
/*     0x0,                          /\* bInterfaceSubClass *\/ */
/*     0x0,                          /\* bInterfaceProtocol *\/ */
/*     0                              /\* iInterface String Index *\/ */
/*     }, */
/*     {                              /\* endpoint descriptor *\/ */
/*     sizeof(endpoint_descriptor_t),  /\* bLength *\/ */
/*     USB_DESCRIPTOR_TYPE_ENDPOINT,      /\* bDescriptorType *\/ */
/*     0x01,                          /\* bEndpoint Address EP1 OUT *\/ */
/*     0x03,                          /\* bmAttributes - Interrupt *\/ */
/*     hostToUsb16(0x0008),                        /\* wMaxPacketSize *\/ */
/*     0x0A                           /\* bInterval *\/ */
/*     }, */
/*     {                              /\* endpoint descriptor *\/ */
/*     sizeof(endpoint_descriptor_t),  /\* bLength *\/ */
/*     USB_DESCRIPTOR_TYPE_ENDPOINT,      /\* bDescriptorType *\/ */
/*     0x81,                          /\* bEndpoint Address EP1 IN *\/ */
/*     0x03,                          /\* bmAttributes - Interrupt *\/ */
/*     hostToUsb16(0x0008),                        /\* wMaxPacketSize *\/ */
/*     0x0A                           /\* bInterval *\/ */
/*     } */
/* }; */

typedef struct {
  uint8_t length;
  uint8_t page[EP2_PACKET_SIZE];
} usb_pkt_t;

#endif //_H_usb_H
