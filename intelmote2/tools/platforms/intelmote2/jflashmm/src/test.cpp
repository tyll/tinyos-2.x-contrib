// The Code is Borland's, I just modified it
// to make it Standard C++

#include <direct.h> // for getcwd
#include <stdlib.h>// for MAX_PATH
#include <iostream> // for cout and cin
#include <windows.h>

using namespace std;
char PathInformation[4][_MAX_PATH];

void Split_File_Paths(char*, char[][_MAX_PATH]);

int main(int argc, char *argv[])
{
	char AppHome[_MAX_PATH];

	errno_t err;
	err = GetModuleFileName (NULL, AppHome, _MAX_PATH);
    if (err == 0)
    {
       printf("Error getting the path. Error code %d.\n", err);
       exit(1);
    }
	Split_File_Paths(AppHome,PathInformation);

   printf( "Path extracted with _splitpath_s:\n" );
   printf( "  Drive: %s\n", PathInformation[0] );
   printf( "  Dir: %s\n", PathInformation[1] );
   printf( "  Filename: %s\n", PathInformation[2] );
   printf( "  Ext: %s\n", PathInformation[3] );

}

void Split_File_Paths(char* inputString, char returnArray[][_MAX_PATH])
{
	errno_t err;

	err = _splitpath_s( inputString, returnArray[0], _MAX_PATH, returnArray[1], _MAX_PATH,
		returnArray[2], _MAX_PATH, returnArray[3], _MAX_PATH );

	if (err != 0)
	{
		printf("Error splitting the path. Error code %d.\n", err);
		exit(1);
	}
}