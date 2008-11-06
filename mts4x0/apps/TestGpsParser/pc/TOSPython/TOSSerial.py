#!/usr/bin/python

class TOSSerialReceptionError:
	def __init__(self, chaine = "Vide"):
		self.ch = chaine;

	def __str__(self):
		return self.ch;	

class TOSSerialPacket:
	"""Data structure that defines the content of a serial packet"""
	def __init__(self):
		messageType = 0;
		dest = 0;
		src = 0;
		len = 0;
		group = 0;
		handler = 0;
		payload = [];

class TOSSerialParser:
	# Allowed parser states:
	#  0: Init
	#  1: Start or end flag read
	#  2: Start flag read
	#  3: Protocol byte read
	#  4: Message type byte read
	#  5: Address MSB read
	#  6: Address LSB read
	#  7: Destination byte
	#  8: Source byte
	#  9: Length byte read
	# 10: Group byte read
	# 11: Handler byte read
	# 12: Payload byte read
	# 13: CRC MSB read
	# 14: CRC LSB read
	# 15: End flag read

	def __init__(self):
		self.state = 0; # Init state
		self.currentLength = 0;
		self.currentPacket = TOSSerialPacket();
		self.currentCRC = 0;
		self.escapeChar = False;

	def readByte(self, b):
		if self.state == 0:
			# Init state
			if ord(b) == 0x7E:
				# We have read a start or end packet flag
				self.state = 1;
		elif self.state == 1:
			# "Start of end flag read" state
			if ord(b) == 0x7E:
				# We have read a start flag
				self.state = 2;
			else:
				if ord(b) in [67, 68, 69, 255]:
					# We have read the protocol byte
					self.state = 3;
				else:
					# The protocol byte is not allowed
					self.state = 1;
					raise TOSSerialReceptionError("Protocol not allowed");
		elif self.state == 2:
			# "Start flag read" state
			if ord(b) in [67, 68, 69, 255]:
				# We have read the protocol byte
				self.state = 3;
			else:
				# The protocol byte is not allowed
				self.state = 1;
				raise TOSSerialReceptionError("Protocol not allowed");
		elif self.state == 3:
			# "Protocol byte read" state
			if ord(b) in [0, 1, 2, 255]:
				# We have read the message type byte
				self.currentPacket.messageType = ord(b);
				self.state = 4;
			else:
				# The message type is not allowed
				self.state = 1;
				raise TOSSerialReceptionError("Message type not allowed");
		elif self.state == 4:
			# "Message type read" state
			# We have read the MSB of address
			self.state = 5;
		elif self.state == 5:
			# "Address MSB read" state
			# We have read the LSB of address
			self.state = 6;
		elif self.state == 6:
			# "Address LSB read" state
			# We have read the destination byte
			self.currentPacket.dest = ord(b);
			self.state = 7;
		elif self.state == 7:
			self.currentPacket.src = ord(b);
			self.state = 8;
		elif self.state == 8:
			self.currentPacket.len = ord(b);
			self.state = 9;
		elif self.state == 9:
			self.currentPacket.group = ord(b);
			self.state = 10;
		elif self.state == 10:
			self.currentPacket.handler = ord(b);
			self.currentPacket.payload = [];
			self.state = 11;
		elif self.state == 11:
			if ord(b) == 0x7E:
				self.state = 1;
				raise TOSSerialReceptionError("Byte 0x7E not allowed in payload")
			elif ord(b) == 0x7D:
				self.escapeChar = True;
				self.currentLength = 0;
			else:
				self.currentPacket.payload.append(b);
				self.escapeChar = False;
				self.currentLength = 1;
			self.state = 12;
		elif self.state == 12:
			if ord(b) == 0x7E:
				self.state = 1;
				if self.currentLength == self.currentPacket.len:
					raise TOSSerialReceptionError("Byte 0x7E not allowed in CRC")
				else:
					raise TOSSerialReceptionError("Byte 0x7E not allowed in payload")
			elif ord(b) == 0x7D:
				self.escapeChar = True;
			else:
				if self.escapeChar:
					self.escapeChar = False;
					if ord(b) == 0x5E:
						b = chr(0x7E);
					elif ord(b) == 0x5D:
						b = chr(0x7D);
					else:
						self.state = 1;
						if self.currentLength == self.currentPacket.len:
							raise TOSSerialReceptionError("Wrong escape sequence in CRC")
						else:
							raise TOSSerialReceptionError("Wrong escape sequence in payload")

				if self.currentLength == self.currentPacket.len:
					self.currentCRC = ord(b) << 8;
					self.state = 13;
				else:
						self.currentPacket.payload.append(b);
						self.currentLength += 1;
		elif self.state == 13:
			if ord(b) == 0x7E:
				self.state = 1;
				raise TOSSerialReceptionError("Byte 0x7E not allowed in CRC")
			elif ord(b) == 0x7D:
				self.escapeChar = True;
			else:
				if self.escapeChar:
					self.escapeChar = False;
					if ord(b) == 0x5E:
						b = chr(0x7E);
					elif ord(b) == 0x5D:
						b = chr(0x7D);
					else:
						self.state = 1;
						raise TOSSerialReceptionError("Wrong escape sequence in CRC")
				self.currentCRC += ord(b);
				# TODO: compute the real CRC and match with the read one
				self.state = 14;
		elif self.state == 14:
			if ord(b) == 0x7E:
				self.state = 15;
				raise self.currentPacket;
			else:
				self.state = 1;
				raise TOSSerialReceptionError("Byte should be 0x7E at end of message");
		elif self.state == 15:
			if ord(b) == 0x7E:
				self.state = 2;
			else:
				self.state = 1;
				raise TOSSerialReceptionError("Byte should be 0x7E at beginning of message");
