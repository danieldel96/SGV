using System;
using System.Timers;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Microsoft.MixedReality.Toolkit;
using MRTK.Tutorials.MultiUserCapabilities;
using Photon;
using Photon.Pun;

public class gaze_outline : MonoBehaviourPun, IPunObservable
{

    
    //TODO: Streaming current gaze
    public bool current_on = false;
    public bool net_current_on = false;
    
    // private GameObject control;
    private bool sgv_outline;

    public bool dangerObj = false;


    // private bool grabbed;

    // public int numOfLookers;

    void IPunObservable.OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
    {
        if (stream.IsWriting) {
            stream.SendNext(current_on);
            // stream.SendNext(isGrabbed);
            //  Debug.Log("Writing to stream...");
             } 
        else{ 
            // Debug.Log("Reading from stream..." + this.transform.name + stream.Count);            
            
            try
            {
                net_current_on = (bool) stream.ReceiveNext();
                // net_isGrabbed = (bool) stream.ReceiveNext();
            }
            catch
            {
                // Debug.Log("Failed to read from stream: " + this.transform.name + stream.Count);
            }
        }

    }

    // Start is called before the first frame update
    void Start()
    {
        // control = GameObject.Find("Manager");
        sgv_outline = true;

        PhotonView pv = GetComponent<PhotonView>();
 
        //after starting your game in editor you should see this component on the list of
        //Observed Components in your Inspector after selecting synchronized object.
        if (pv) pv.ObservedComponents.Add(this);
        // Debug.Log(pv.ViewID);


    }

    // Update is called once per frame
    void Update()
    {
        sgv_outline = GameObject.Find("NetworkRoom").GetComponent<PhotonRoom>().sgv_outline; //TODO: switch to outline
        // checkGaze();
        if(sgv_outline){
            displayOutline();
            setEmission();
        }
        else{ //turn off hover for all
            GetComponent<Outline>().enabled = false;
        }
    }

    private void displayOutline() //object gets highlight if its being looked at
    {
       
        if(CoreServices.InputSystem.EyeGazeProvider.HitInfo.collider != null)
        {
            // Debug.Log("Hit Collider...");
            setOutline();
        }                                                                      
        //render current objects emission
    }

    private void setOutline(){ //only called when intential collision from eye-gaze
        // Debug.Log("PUN RPC CALL SETHOVER()...");
            // manager managering = this.manage.GetComponent<manager>();
            // bool on = managering.sgv_always_on; //TODO:should be a function, not directly gaining access to variable    
            string lookingAt = CoreServices.InputSystem.EyeGazeProvider.HitInfo.collider.gameObject.name;
            //get ownership handlercontroller and give to me!!

            current_on = (lookingAt == this.GetComponent<Transform>().name);

            //if transfer is the other user, need to communicate with server

            if(current_on) photonView.RequestOwnership(); //NOTE: change
            // if(current_on)
            // {
            //     Debug.Log("lookingAt == this.GetComponent<Transform>().name: " + (lookingAt == this.GetComponent<Transform>().name));
            //     Debug.Log(lookingAt);
            //     Debug.Log("Local: " + current_on);
            //     Debug.Log("Networked: " + net_current_on);
            // }
    }

    
    private void setEmission()
    {
        bool on = false;

        if (!photonView.IsMine)//set local or networked value
            on = net_current_on; //networked
            // manipulate_material.SetColor("_EmissionColor", net_current_color);//someone else set the color out of here
        else 
            on = current_on; //local

        // Debug.Log("Currently on: " + on);
        
        if(on)// turn on/off hover
            GetComponent<Outline>().enabled = true;
        else
            GetComponent<Outline>().enabled = false;
    }
}
