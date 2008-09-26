#ifndef _MTYPES_H_
#define _MTYPES_H_

/*
StargateTestAudio  1
StargateTestVideo  2
StargateTestImage  3

*/

bool
StargateTestAudio (uint8_t value)
{
	return value == 1;
}

bool
StargateTestVideo (uint8_t value)
{
	return value == 2;
}

bool
TestVideo (uint8_t value)
{
  return FALSE;
}

bool
TestAudio (uint8_t value)
{
  return FALSE;
}

bool
StargateTestImage (uint8_t value)
{
	return value == 3;
}

bool
TestImage (uint8_t value)
{
  return FALSE;
}

bool
TestText (uint8_t value)
{
  return FALSE;
}

#endif // _MTYPES_H_
