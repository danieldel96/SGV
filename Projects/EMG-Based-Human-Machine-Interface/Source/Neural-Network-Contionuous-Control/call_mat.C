// How to build
// mex -I./LeapSDK/include -L./LeapSDK/lib/x64 -lLeapC call_mat.c LeapConnection.cpp  // cbw64.lib (DAQ)

// Include files
#include <stdio.h>
#include <unistd.h>
#include <string>
//#include "cbw.h" //DAQ!!!
//#include "Utilities.h" //DAQ!!
#include "mex.h"
#include "matleap.h"
#include <sys/time.h>


// Global instance pointer
matleap::frame_grabber* fg = 0;


// Exit function
void matleap_exit()
{
    printf("closing connection");
	fg->close_connection();
	delete fg;
	fg = 0;
}

int call_mat(int num_channels, long num_secs)
{
    long	Count = num_secs*2000*num_channels; // we record faster than 1000 //changed to 2000 because it actually turns out to be 10 seconds lol
    long	CurIndex;
    long last = -1;
    double secs = 0;
    
    //initialize timestamp
    struct timeval stop,start;
    gettimeofday(&start,NULL);
    
    double myData[num_channels+8];
    
    if (!fg)
    {
        fg = new matleap::frame_grabber;
        if (fg == 0)
            mexErrMsgTxt("Cannot allocate a frame grabber");
        fg->open_connection(); //gets stuck here, searching for connection
        mexAtExit(matleap_exit);
    }
    
    
     while(num_secs > secs){ //remove dependency from count-num_channels
         //printf("%d", last*num_channels);
//         if(CurIndex>last*num_channels){
           printf("time taken %f\n",secs);

            last++;
    
            const matleap::frame& fm = fg->get_frame();
//             for(int k=0; k<500; k++){usleep(100);}
            for(int i=0;i<num_channels+4;i++){
                printf("%d",i);
                //Index of motion data
                if(i==num_channels+3){
                    myData[num_channels+7] = 2; //time stamp for leap motion
                    gettimeofday(&stop,NULL);
                    
                    secs = (double)(stop.tv_usec - start.tv_usec) / 1000000 + (double)(stop.tv_sec - start.tv_sec);
                    
                    myData[num_channels+7] = secs;
                    //printf("time taken %f\n",secs);
                    //myData[num_channels+7] = CurIndex/num_channels; //time stamp for leap motion

                    //TODO: datetime
                    //myData[num_channels+7] = datetime.now;
//                     myData[i+4] = last;
                }
                //Timestamp of EMG data
                else if(i==num_channels+2){
                    myData[num_channels+6] = last/2; //nothing happens here
                }
                //Wrist Angle
                else if(i==num_channels+1){// time points time stamp
                    myData[num_channels+1] = fm.hands[0].arm.rotation.x;
                    myData[num_channels+2] = fm.hands[0].arm.rotation.y;
                    myData[num_channels+3] = fm.hands[0].arm.rotation.z;
                    myData[num_channels+4] = fm.hands[0].arm.rotation.w;
                    myData[num_channels+5] = 0;
                }
                //Finger Angle
                else if(i==num_channels){ //time points time stamp
                    myData[num_channels] = fm.hands[0].grab_angle;
                }
                //EMG Data
                else if(i<num_channels){
                    //myData[i] = (double) ADData[i+last*num_channels]; //breaks here //DAQ
                     myData[i] = 0;
                     printf("%d",myData[i]);
                }
            }
                    
            mxArray *prhsApp;
            prhsApp = mxCreateDoubleMatrix(1, num_channels+8, mxREAL);
            mxFree(mxGetData(prhsApp)); // Added line to avoid memory leak
            mxSetData(prhsApp, myData);
            mexPutVariable("base", "emg_data", prhsApp);
            mxSetData(prhsApp, NULL); // Added line to detach C native memory
            mxDestroyArray(prhsApp);

            mexCallMATLAB(0,NULL,0,NULL,"mat_to_be_called"); //where all_data is made
//         }

    }//end while
    
    
    return num_channels;
}
 
int call_mat_(int num_channels, long num_secs)
{
    // Variable Declarations
    //int     BoardNum = 0;
    //int     ULStat = NOERRORS; //DAQ
    //int     ADRes = 0;
    //int     Options = BACKGROUND; //DAQ
    //char    BoardName[BOARDNAMELEN]; //DAQ
    //int		LowChan = 0;
	//int		HighChan = num_channels-1;
	//int		Range = BIP5VOLTS; //DAQ
	long	Count = num_secs*1000*num_channels;
	//long	Rate = 1000;
    //HGLOBAL MemHandle = 0; //DAQ
	//unsigned short*	ADData = NULL; //DAQ
    //short	Status = RUNNING; //DAQ
    //long	CurCount;
    long	CurIndex;
    long last = -1;
    
 
    //MemHandle = cbWinBufAlloc(Count); //DAQ
    //ADData = (unsigned short*) MemHandle;  //DAQ

    //cbAInScan(BoardNum, LowChan, HighChan, Count, &Rate, Range, MemHandle, Options); //DAQ
    printf("please print");
    double myData[num_channels+8];
    
    if (!fg)
    {
        fg = new matleap::frame_grabber;
        if (fg == 0)
            mexErrMsgTxt("Cannot allocate a frame grabber");
        fg->open_connection();
        mexAtExit(matleap_exit);
    }

    while(last*num_channels < Count-num_channels){
        //ULStat = cbGetStatus(BoardNum, &Status, &CurCount, &CurIndex, AIFUNCTION); /DAQ
        if(CurIndex>last*num_channels){
            last++;
    
            const matleap::frame& fm = fg->get_frame();

//             for(int k=0; k<500; k++){usleep(100);}
            for(int i=0;i<num_channels+4;i++){
                printf("%d",i);
                //Index of motion data
                if(i==num_channels+3){
                    myData[num_channels+7] = CurIndex/num_channels;
//                     myData[i+4] = last;
                }
                //Timestamp of EMG data
                else if(i==num_channels+2){
                    myData[num_channels+6] = last;
                }
                //Wrist Angle
                else if(i==num_channels+1){
                    myData[num_channels+1] = fm.hands[0].arm.rotation.x;
                    myData[num_channels+2] = fm.hands[0].arm.rotation.y;
                    myData[num_channels+3] = fm.hands[0].arm.rotation.z;
                    myData[num_channels+4] = fm.hands[0].arm.rotation.w;
                    myData[num_channels+5] = 0;
                }
                //Finger Angle
                else if(i==num_channels){
                    myData[num_channels] = fm.hands[0].grab_angle;
                }
                //EMG Data
                else if(i<num_channels){
                    //myData[i] = (double) ADData[i+last*num_channels]; //breaks here //DAQ
                     myData[i] = 0;
                     printf("%d",myData[i]);
                }
            }
                    
            mxArray *prhsApp;
            prhsApp = mxCreateDoubleMatrix(1, num_channels+8, mxREAL);
            mxFree(mxGetData(prhsApp)); // Added line to avoid memory leak
            mxSetData(prhsApp, myData);
            mexPutVariable("base", "emg_data", prhsApp); //emg_data goes to mat_to_be_called.m
            mxSetData(prhsApp, NULL); // Added line to detach C native memory
            mxDestroyArray(prhsApp);

            mexCallMATLAB(0,NULL,0,NULL,"mat_to_be_called"); //where all_data is made
        }

    }//end while
    

    return 0;
}

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[]) {
    
    int num_channels = mxGetScalar(prhs[0]);
    int num_secs = mxGetScalar(prhs[1]);
    
    call_mat(num_channels, num_secs);
}
