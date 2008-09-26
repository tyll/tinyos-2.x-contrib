#ifndef _MTYPES_H_
#define _MTYPES_H_

int suffixT(char *val, char *suffix) {
  int len = strlen(val);
  int s_len = strlen(suffix);
  int i;
  
  for (i=0;i<s_len;i++) {
    if (val[len-i]!=suffix[s_len-i])
      return 0;
  }
  return 1;
}

bool
TestVideo (char *value)
{
	if(suffixT(value,".mp4")||suffixT(value,".mpeg")||suffixT(value,".mov"))
	{	return TRUE;	}
  return FALSE;
}

bool
TestAudio (char *value)
{
	if(suffixT(value,".mp3")||suffixT(value,".wav"))
	{	return TRUE;	}
  return FALSE;
}

bool
TestImage (char *value)
{
	if(suffixT(value,".png")||suffixT(value,".gif")||suffixT(value,".jpg"))
	{	return TRUE;	}

  return FALSE;
}

bool
TestText (char *value)
{
  return TRUE;
}

#endif // _MTYPES_H_
