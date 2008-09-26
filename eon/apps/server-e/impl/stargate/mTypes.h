#ifndef _MTYPES_H_
#define _MTYPES_H_


bool
TestVideo (uint8_t value)
{
  return (value == 4);
}

bool
TestAudio (uint8_t value)
{
  return (value == 3);
}

bool
TestImage (uint8_t value)
{
  return (value == 2);
}

bool
TestText (uint8_t value)
{
  return (value == 1);
}

#endif // _MTYPES_H_
