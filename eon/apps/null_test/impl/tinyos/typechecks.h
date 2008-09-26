#ifndef TYPECHECKS_H_INCLUDED
#define TYPECHECKS_H_INCLUDED

bool IsEven(int val)
{
	return ((val % 2) == 0);
}

bool IsOdd(int val)
{
	return !IsEven(val);
}

#endif // TYPECHECKS_H_INCLUDED
