
 Contacts: stefano.paniga@gmail.com

/*********************
 COMPONENTS
*********************/
The main directories are: 
	1- java
	2- sensors
	3- dpcm_C

1- java

This directory contains the 'src' subdirectory in which all the java source code is located.
The java source code is divided in 'GUI' and 'messages'. The GUI code manages the main program
throught the threads that receive, decode and reconstruct the incoming frames; moreover cameraGUI.java
and BagPanel.java are needed to build the actual user interface.
The last file, DynamicFrameRate.java is the class used to balance the stream of frames displayed with respect 				
to those actually received.

In the 'message' directory we find the classes used to specify the format of the incoming messages.
Every class corresponds to a specific message type.

2- sensors

Contains the complete environment necessary to program the motes.
In the sensors directory there is the code to program the camera mote, with the correspondant 
Makefile.
All the other directories are needed to support the built of the camera code (jpeg/dpcm compression algorithms, 
modified camera drivers etc..), except for the 'intermediateNode' and the 'baseStation' directories. 
Between the support directories there is also the 'cameraComm': it is the communication module for the camera node; 
it is used by the camera mote to send/receive data and commands.

The 'intermediateNode' and 'baseStation' directories contain the code to program, respectively, the
intermediate nodes of the path and the node directly attached to the gateway. 
The intermediate node simply forward to the destination the incoming packets.
The base station node receives radio messages and forward them to the serial channel during the camera->gateway 
communication while receives the messages from the gateway and forward them to the radio channel when the communication
goes from the gateway to the camera node.

All the nodes (camera,intermediate,base station), are composed by two main modules: the communication module
and the core module. The latter manages the resources and the capabilities of the node, included 
the communication module. Every node has its own Makefile.

3- dpcm_C

This directory contains the C version of the dpcm algorithm. It is possible to compile such code
with the included Makefile and test the algorithm.

/**********************
 REQUIREMENTS
**********************/

 - TinyOS environment
 - intelmote2 hardware and the programming kit
 - OPENOCD software: http://docs.tinyos.net/tinywiki/index.php/OpenOCD_for_IMote2
 - tinyos java library (tinyos.jar) and serial forwarder software: in the tinyOS source directory
 - Serial Forwarder software instructions: http://www.tinyos.net/dist-2.0.0/tinyos-2.x/doc/html/tutorial/lesson4.html


/**********************
 FAST START
**********************/
To immediately test the system test:


	- Program a node with the camera code enabling the serial option in the Makefile (uncomment the PFLAG that declares the SERIAL_MODE var):
		$sensors: make intelmote2 install openocd 
	- With the camera mote directly connected to the gateway
	- Run SerialForwarder on the right port
		java net.tinyos.sf.SerialForwarder -comm serial@/dev/ttyUSB2:intelmote2
	- Run the cameraGUI.java application


/***********************
 NETWORK SETUP 
***********************/

 The simplest working sensor network requires only the camera node.

 The CAMERA NODE source code must be installed on a intelmote2 node equipped with a camera module directly 
 bound with the gateway pc throught a serial cable.
 Any address can be assigned to the node and DEST and SRC variables, defined in the cameraComm/config.h file,
 are meaningless.

 CODE SETUP:
 The CAMERA NODE must be directly connected to the gateway through the serial cable.
 To enable the serial primitives while disabling the radio communication, uncomment the SERIAL_MODE
 flag in the sensors/Makefile

 EXTERNAL TOOLS:
 The gateway setup requires a tool to read the serial input, called SerialForwarder. The serial forwarder start command,
 receives in input: the virtual device used to communicate with the mote and the channel data rate (set as a number, 
 es:115000, or specified by the mote type, es: intelmote2). 
 
 See the SerialForwarder man page for more informations.

 -->  usage example:
 	
	java net.tinyos.sf.SerialForwarder -comm serial@/dev/ttyUSB2:intelmote2

 GUI:
 Once the Serial Forwarder is running, the CameraGUI java application must be started. 
 It shows up a graphical interface with which the user can interact with the motes. 
 The GUI allows, very intuitively, to take a picture, to start the video capturing and to stop it.
 

 NETWORK PARADIGMS:

 --> One-hop Network

 It is possible to extend the sensors network by adding other motes and configuring them properly.
 From now on, the addresses given to the different nodes become meaningful.
 To implement a one-hop paradigm two motes are required.

  Node 0: is attached to the gateway machine through a cabled serial link.
	  Runs the BASE STATION source code.
          
 	   --> Example address settings: 
		
		- baseStaition/config.h file has SRC variable set to 1;
		- TOS_NODE_ID = 0.

  Node 1: Runs the camera code and is equipped with the hardware camera module.
	 
 	   --> Example address settings: 
	
		- cameraComm/config.h file has SRC variable set to 1;
		- TOS_NODE_ID = 1.

 --> Multi-hop Paradigm
 
 Requires 3 or more motes.
 
 Node 0: see one hop configuration for Node 0.

 Node 1: runs the INTERMEDIATE NODE code. 
 	   

	--> Example address settings: 
	
		- intermediateNode/config.h file has SRC and DEST variables set, respectively, to 2 and 0;
		- TOS_NODE_ID = 1.

 Node 2: Runs the CAMERA NODE source code and is equipped with the camera module. 
	--> Example address settings: 
	
		- cameraComm/config.h file has DEST variable set to 1;
		- TOS_NODE_ID = 2.



 N.B.: to extend the multi hop paradigm to a major number of nodes, add more intermediate nodes
 and set every DEST/SRC variable properly.

 /************************
  TEST, NOACK & PSNR ENVIRONMENT
 ************************/
 To enable the test environment uncomment the TEST_ENV flag in "each Makefile of the path": sensors/Makefile for
 the camera node, sensors/intermediateNode/Makefile some intermediate nodes are present and sensors/baseStation/Makefile
 for the base station.

 To disable the aknowledgement mode for the reconstructed frames packets, uncomment the NO_ACK flag in the 
 sensors/baseStation/Makefile and  sensors/intermediateNode/Makefile.

 To enable the computation of the mse, for the PSNR measurement, uncomment the PSNR_ENV flag in the sensors/Makefile and
 rename the DpcmM_PSNR.nc file in DpcmM.nc.

 WARNING: the TEST and PSNR boolean variables, in cameraGUI, must be set according to the enabling and the disabling of the
 	  test and the psnr environment.
	  A correct functioning is expected with the two environments running separately.
 

 /*******************
  DPCM PARAMETERS
 ********************/

 - Parameters located in: sensors/cameraModuleM.nc

 - These parameters control the DPCM encoder algorithm

 Camera sensor params 	-> DPCM_SEQ= 20 // length of the Dpcm sequence. 
					// The first frame of the sequence is a Jpeg pictures, the others 19 frames are 
					// produced as output of the DPCM algorithm.
 			-> FULL_FRAME_PERIOD=240 // Max value of the Frame_id field. WARNING: use uint8 variables.
			-> JPEG_QUALITY=9 // adjusts the quantization matrix values for the Photo case. 
			-> DPCM_QUALITY=6 // adjusts the quantization matrix values for the Video case. 
					 //Values supported by the system, in both cases, are: 4,5,6,7,8,9

- Parameters located in: cameraGUI.java
- These parameters control the DPCM decoder and the video reproduction operations.

 Java params	-> BUFFER_SIZE=30 // size of the buffer used to store the icoming frames.

    		-> START_READING=5 // video display thread start threshold: the received frames are 
				   // played only once five frame was received.

		-> DPCM_SEQ=20  //length of Dpcm sequence. This values must be set according 
			       //to the correspondent value in the cameraModuleM.nc file.

    		-> REP_TIME=500 // time between the reproduction of two subsequent frames (2fps) by the video
				// display thread. Set statically the reproduction frame rate.

		-> BUF_REFILLING_DIST=2 // Once the buffer of the incoming frames has been emptied
					// the video display thread is stopped untill 
					// BUF_REFILLING_DIST frames are received.

    		-> FULL_FRAME_PERIOD=240 // Max value of the Frame_id field

    		-> PAYLOAD_LENGTH=40 // payload size of the data packets. Set in all the Makefiles as 
				     // PFLAGS += -DTOSH_DATA_LENGTH=43. 
				     //In this example, 43 stands for: 40 bytes of payload+3 bytes of header.

		-> MAX_REF_DIST=8;

    		-> MIN_REF_DIST=2 // set the max and min value that the BUF_REFILLING_DIST can take. 
				  // The reproduction frame rate is tuned dynamically on the base of the
				  // number of frames received in the last 5 seconds. 
				  // If the arrival rate does not slow down for 15 seconds, the BUF_REFILLING_DIST
				  // value is decremented so that, once the buffer is emptied, the reproduction
				  // can be quickly re-started. On the other side, the first time we notice a diminishing 
				  // of the arrival rate, the BUFFER_REFILLING_DIST is incremented so that, once 
				  // the buffer is emptied, we can store more frames before re-starting the reproduction.
				
/*********************
  C Dpcm Code
*********************/
to test the C implementation of the dpcm encoder/decoder compile the files in the
dpcm_C source directory:

#code: make

then run the encoder:

#code: ./dpcmEncodeApp.exe input_file_path frame_num

- frame_num = 0 the encoder is equivalent to a common jpeg encoder except that the original image
		is saved in the a buffer called "sender_buffer". The encoded output is saved in a file
		called input_file_name+"_coded_"+frame_num+".dpcm".

- frame_num > 0 the encoder reads the buffer filled with the precedent image and compute the difference. 
		Then it encodes the latter saving the output in the .dpcm file.

to recontruct the original image:

#code: ./dpcmDecodeApp.exe encoded_input_file_path frame_num

- frame_num must correspond to the frame_num value used for the encoding.
 If frame_num = 0 the buffer content is ignored, otherwise it is summed to the input file.
 The output file name is composed as follows: encoded_input_file_name+"_rec_"frame_num+".pgm"



