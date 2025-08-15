// How to build
// mex control.c cbw64.lib

// Include files
#include <stdio.h>
#include <unistd.h>
#include <string>
//#include "cbw.h" //DAQ
//#include "Utilities.h" //DAQ
#include "mex.h"

int call_mat(int num_channels, long num_secs)
{
    // Variable Declarations
    int     BoardNum = 0;
    int     ULStat = NOERRORS;
    int     ADRes = 0;
    int     Options = BACKGROUND;
    char    BoardName[BOARDNAMELEN];
    int		LowChan = 0;
	int		HighChan = num_channels-1;
	int		Range = BIP5VOLTS;
	long	Count = num_secs*1000*num_channels;
	long	Rate = 1000;
    HGLOBAL MemHandle = 0;
	unsigned short*	ADData = NULL;
    short	Status = RUNNING;
    long	CurCount;
    long	CurIndex;
    long last = -1;
    
 
    MemHandle = cbWinBufAlloc(Count);
    ADData = (unsigned short*) MemHandle;  

    cbAInScan(BoardNum, LowChan, HighChan, Count, &Rate, Range, MemHandle, Options);

    double myData[num_channels];
    
    while(last*num_channels < Count-num_channels){
        ULStat = cbGetStatus(BoardNum, &Status, &CurCount, &CurIndex, AIFUNCTION);
        
        if(CurIndex>last*num_channels){
            last++;
            
            for(int i=0;i<num_channels;i++){
                myData[i] = (double) ADData[i+last*num_channels];
            }
            
            mxArray *prhsApp;
            prhsApp = mxCreateDoubleMatrix(1, num_channels, mxREAL);
            mxFree(mxGetData(prhsApp)); // Added line to avoid memory leak
            mxSetData(prhsApp, myData);
            mexPutVariable("base", "emg_data", prhsApp);
            mxSetData(prhsApp, NULL); // Added line to detach C native memory
            mxDestroyArray(prhsApp);

            mexCallMATLAB(0,NULL,0,NULL,"control_to_be_called");
        }
    }
    return 0;
}

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[]) {
    
    int num_channels = mxGetScalar(prhs[0]);
    int num_secs = mxGetScalar(prhs[1]);
    
    call_mat(num_channels, num_secs);
}
