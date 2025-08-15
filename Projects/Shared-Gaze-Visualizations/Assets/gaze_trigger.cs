/* Communicates gaze trigger across the Photon Network
* IN this iteration, this script has significantly more dependency that just triggering gaze. This script the position and visualization of gaze as a whole. TODO: isolating gaze positioning from this script. However 
* it still works with the current modification, which is to set sgv_trigger = false at the start. (HERE)
*/

/*
*more than trigger now, handles everyting related to gaze ray, including solo view
*/
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Microsoft.MixedReality.Toolkit;
using static Microsoft.MixedReality.Toolkit.Examples.Demos.EyeTracking.EyeCalibrationChecker;
using MRTK.Tutorials.MultiUserCapabilities;



public class gaze_trigger : MonoBehaviourPun
{
    public GameObject rotationParent;
    public GameObject rotationGlobal;
    public GameObject child;
    // public GameObject rotationChild;
    // public GameObject user;
    float current;
    float lapse_eye;
    Quaternion last_rotation;
    bool on;
    bool waiting;
    bool sgv_trigger;
    bool sgv_always_on;
    bool sgv_no_self;
    // GameObject control;

    //TODO: testing eye-gaze values
     public GameObject scoreBoard;
     public bool? gaze;
     public bool? prevCalibrationStatus = false;
    
    // Start is called before the first frame update
    void Start()
    {
        sgv_trigger = false; ///HERE: THIS SCRIPT WORKS BECAUSE OF THIS HARDCODING WHICH BYPASSES THE GAZE TRIGGER TIMER
        sgv_always_on = false;
        // control = GameObject.Find("Manager");
        on = true;
        waiting = false;
        lapse_eye = Time.time;
        last_rotation = Quaternion.LookRotation(CoreServices.InputSystem.EyeGazeProvider.GazeDirection);
        // Debug.Log(CoreServices.InputSystem.EyeGazeProvider.IsEyeTrackingEnabled);
    }

    // Update is called once per frame
    void Update()
    {

        //TODO:only update if master
        // sgv_trigger = GameObject.Find("NetworkRoom").GetComponent<PhotonRoom>().sgv_trigger; //TODO: disabled since no gaze _trigger for this iteration... yet
        sgv_always_on = GameObject.Find("NetworkRoom").GetComponent<PhotonRoom>().sgv_always_on;
        sgv_no_self = GameObject.Find("NetworkRoom").GetComponent<PhotonRoom>().sgv_no_self;



        PhotonView photonView = PhotonView.Get(this);
        try{
            if(photonView.IsMine) //->no sgv_trigger here
                updateVisualization();
            else if(sgv_always_on && !sgv_trigger)
                on = true;
            else if(!sgv_always_on && !sgv_trigger)
                on = false;
            // Debug.Log("always on should be working");
            
        }
        catch{
            // Debug.Log("not computing...");
            return;
        }
        // if(!sgv_trigger)
        //     on = sgv_always_on; //always off
        // Debug.Log("Gaze Trigger ViewID: " + photonView.ViewID + " Status: " + on); it works lol
        MeshRenderer render = child.GetComponent<MeshRenderer>();
        render.enabled = on; //convert to rpc call
        
        //will continuously be setting off and overriding "on" ERROR
        if(photonView.IsMine && sgv_no_self) // if we add it in the if statement, only works when on, otherwise it doesnt override
            render.enabled = false; //overrides everything, only the self user can't see it but everyone else can see their own. only if the user owns that viz.



    }

    public void updateVisualization() //only the owner should be changing their visualization
    {   

        PhotonView photonView = PhotonView.Get(this);

        //comapre differences in angle, if less than 10 degrees over the last 0.7 second display

        var current_rotation = Quaternion.LookRotation(CoreServices.InputSystem.EyeGazeProvider.GazeDirection);
    
        var direction = CoreServices.InputSystem.EyeGazeProvider.GazeDirection;
        var origin = CoreServices.InputSystem.EyeGazeProvider.GazeOrigin;

        //the solution :)
        child.transform.position = direction+origin;
        child.transform.rotation = Quaternion.LookRotation(direction);//save


        current = Time.time;

        //check angle lapse
        var diff = Quaternion.Angle(current_rotation,last_rotation);
        // if(diff != 0)
            // Debug.Log(diff);
        // Debug.Log(current.Second - lapse_eye.Second);

        if(sgv_always_on && !sgv_trigger){
            on = true; //always off
            // Debug.Log("always on should be working");
        }
        else if(sgv_trigger) //working after always_on turned off and failed last condition
        {
            // Debug.Log("trigger");
            if(diff > 1.8 && on)
            {
                on = false;
                waiting = true;
                photonView.RPC("turnOn", RpcTarget.All, on);
            }
            if(!waiting)
                lapse_eye = Time.time;

            if(!on)
            {
                var time = current - lapse_eye;
                // Debug.Log(time);
                if(time > 1.5f){
                    //render off 
                    //send RPC for render off
                    on = true;
                    waiting = false;
                    photonView.RPC("turnOn", RpcTarget.All, on);
                    lapse_eye = Time.time;
            }
            
            MeshRenderer render = child.GetComponent<MeshRenderer>();
            last_rotation = Quaternion.LookRotation(CoreServices.InputSystem.EyeGazeProvider.GazeDirection);
            render.enabled = on; 
            }
        }
        else{
            on = false;
            // Debug.Log("always on should be false");
            }
    }

    [PunRPC]
    void turnOn(bool activate)
    {
        on = activate;
    }

    

}
