/*
* Copyright (c) 2007 New University of Lisbon - Faculty of Sciences and
* Technology.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of New University of Lisbon - Faculty of Sciences and
* Technology nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * @author Ricardo Tiago
 */

#include <stdio.h>
#include <tos.h>
#include <sim_fire.h>

int ignition[13][13];
int grid[13][13];
int x=0;
int y=0;
int grid_x=0;
int grid_y=0;
int my_posx=0;
int my_posy=0;

int getPositionXFromValue(int val,int *posx) {
	int i;
	int j;
	int idx = 0;
	for (i = 0; i < 12; i++) {
		for (j= 0; j < 12; j++) {
			if (ignition[i][j] == val) {
				posx[idx] = i;
				//printf("posx is %d\n",i);
				idx++;
			}
		}
	}
	return idx;
}

int getPositionYFromValue(int val,int *posy) {
	int i;
	int j;
	int idx = 0;
	for (i = 0; i < 12; i++) {
		for (j= 0; j < 12; j++) {
			if (ignition[i][j] == val) {
				posy[idx] = j;
				//printf("posj is %d\n",j);
				idx++;
			}
		}
	}
	return idx;
}

void getNodeFromXY(int *valx,int xsize, int *valy,int ysize,int* nodes_grid) {
	int i;
	for (i = 0; i < xsize; i++) {
		/*printf("valx[%d] is %d\n",i,valx[i]);
		printf("valy[%d] is %d\n",i,valy[i]);
		printf("grid[%d][%d] is %d\n",valx[i],valy[i],grid[valx[i]][valy[i]]);*/
	 	nodes_grid[i] = grid[valx[i]][valy[i]];
	}
}


void printGridIgnition() {
	int i;
	int j;

	for (i = 0; i < 12; i++) {
		for (j= 0; j < 12; j++) {
			printf("ignition[%d][%d]=%d\n",j,i,ignition[j][i]);
		}
	}
	for (i = 0; i < 12; i++) {
		for (j= 0; j < 12; j++) {
			printf("grid[%d][%d]=%d\n",i,j,grid[i][j]);
		}
	}
}

void getMyPos() {
	int i;
	int j;
	for (i = 0; i < 12; i++) {
		for (j= 0; j < 12; j++) {
			if (grid[i][j] == TOS_NODE_ID) {
				my_posx = i;
				my_posy = j;
			}
		}
	}
	/*printf("My position x is %d\n",my_posx);
	printf("My position y is %d\n",my_posy);*/
}

bool checkYellow(int *valx, int *valy,int size) {
	int i;
	getMyPos(); 
	for (i = 0; i < size; i++) {
		/*printf("valx is %d\n",valx[i]);
		printf("valy is %d\n",valy[i]);
		printf("abs posx is %d\n",abs(my_posx-valx[i]));
		printf("abs posy is %d\n",abs(my_posy-valy[i]));*/
		if (abs(my_posx-valx[i]) < 3 && abs(my_posy-valy[i]) < 3) {
			//printf("In yellow!\n");
			return TRUE;
		}
	}
	return FALSE;
}

bool checkRed(int *valx, int *valy,int size) {
	int i;
	getMyPos(); 
	for (i = 0; i < size; i++) {
		if (abs(my_posx-valx[i]) < 2 && abs(my_posy-valy[i]) < 2) {
			//printf("In red!\n");
			return TRUE;
		}
	}
	return FALSE;
}


void setFireGrid(int val) {
	int i,j; 
	//printf("Grid val %d\n",val);
	if (grid_x < 12) {
		grid[grid_x][grid_y] = val;
		grid_x++;
		return;
	}
	else {
		if (grid_y < 12) {
			grid_x=0;
			grid_y++;
			grid[grid_x][grid_y] = val;
			return;
		}
		//printf("grid matrix loaded\n");
	}
}

void setFireIgnition(int val) {
	int i,j;
	//printf("Ignition[%d][%d] val %d\n",x,y,val);
	if (x < 12) {
		ignition[x][y] = val;
		x++;
		return;
	}
	else {
		if (y < 12) {
			x=0;
			y++;
			ignition[x][y] = val;
			return;
		}
		//printf("ignition matrix loaded\n");
	}
	/*for (i = 0; i < 12; i++) {
		for (j= 0; j < 12; j++) {
			//printf("ignition[%d][%d]=%d\n",i,j,ignition[i][j]);
		}
	}*/
}
