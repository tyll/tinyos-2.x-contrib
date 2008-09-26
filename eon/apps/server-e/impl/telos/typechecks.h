#ifndef TYPECHECKS_H_INCLUDED
#define TYPECHECKS_H_INCLUDED

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

#endif // TYPECHECKS_H_INCLUDED
