/*
Daniel Delgado
RuizLab
Manages necessary values from core services needed for eye-gaze/tracking.
sends values to manager.
Only objects that will react to gaze interactions should be using this scirpt for the sake of being organized.
*/


//templates......
// ----------------------------------------------------------------------------
// <copyright file="PhotonNetworkPart.cs" company="Exit Games GmbH">
//   PhotonNetwork Framework for Unity - Copyright (C) 2018 Exit Games GmbH
// </copyright>
// <summary>
// PhotonNetwork is the central class of the PUN package.
// </summary>
// <author>developer@exitgames.com</author>
// ----------------------------------------------------------------------------

/// <summary>
/// The photon view list.
/// </summary>
// private static NonAllocDictionary<int, PhotonView> photonViewList = new NonAllocDictionary<int, PhotonView>();

/// <summary>
/// Gets the photon views.
/// </summary>
/// <remarks>
/// This is an expensive operation as it returns a copy of the internal list.
/// </remarks>
/// <value>The photon views.</value>


using System;
using System.Timers;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Microsoft.MixedReality.Toolkit;
using MRTK.Tutorials.MultiUserCapabilities;
using Photon;
using Photon.Pun;

public class gaze_hover : MonoBehaviourPun, IPunObservable
{

    //TODO: Streaming current gaze
    public Color on_color;
    public Color off_color;
    public bool current_on = false;
    public bool net_current_on = false;
    
    // private GameObject control;
    private bool sgv_hover;
    private bool sgv_no_self;

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
        sgv_hover = GameObject.Find("NetworkRoom").GetComponent<PhotonRoom>().sgv_hover;

        PhotonView pv = GetComponent<PhotonView>();
 
        //after starting your game in editor you should see this component on the list of
        //Observed Components in your Inspector after selecting synchronized object.
        if (pv) pv.ObservedComponents.Add(this);
        // Debug.Log(pv.ViewID);

        newMaterial();
        MeshRenderer render = this.GetComponent<MeshRenderer>();
        Material manipulate_material = render.material;
        manipulate_material.EnableKeyword("_EMISSION");
        // manipulate_material.SetColor("_EmissionColor", );
        on_color = manipulate_material.GetColor("_EmissionColor"); //TODO: make static variable that saves this :) but mostly solved
        off_color = Color.black;

        if(dangerObj){
            var rand = UnityEngine.Random.Range(0.0f,10.0f);
            if(rand > 2.0f) //80% chance of turning on
                off_color = Color.red;
        }


    }

    private void newMaterial()
    {
        Material selfMaterial = this.GetComponent<Renderer>().material;
        selfMaterial = new Material(selfMaterial); 
        this.GetComponent<Renderer>().material = selfMaterial;
    }

    // Update is called once per frame
    void Update()
    {
        sgv_hover = GameObject.Find("NetworkRoom").GetComponent<PhotonRoom>().sgv_hover;
        sgv_no_self = GameObject.Find("NetworkRoom").GetComponent<PhotonRoom>().sgv_no_self;
        // var lobby = GameObject.Find("NetworkRoom"); //TODO: read from network room
        
        // checkGaze();
        if(sgv_hover){//manage hover on control.GetComponent<manager>().sgv_hover
            displayHover();
            setEmission();
        }
        else{ //turn off hover for all
            MeshRenderer render = this.GetComponent<MeshRenderer>();
            Material manipulate_material = render.material;
            manipulate_material.SetColor("_EmissionColor", off_color);
        }

        //TODO: when including uni-directional, simply add in similar script from gaze trigger in which if object is mine, do not highlight
    }

    // void checkGaze()
    // {
        // Debug.Log(CoreServices.InputSystem.EyeGazeProvider.HitInfo.collider);
        // Debug.Log("EyeGaze Direction: " + CoreServices.InputSystem.EyeGazeProvider.GazeDirection.x + " " + CoreServices.InputSystem.EyeGazeProvider.GazeDirection.y + " " + CoreServices.InputSystem.EyeGazeProvider.GazeDirection.z);

        // if(CoreServices.InputSystem.EyeGazeProvider.HitInfo.collider != null){
            
        //     string lookingAt = CoreServices.InputSystem.EyeGazeProvider.HitInfo.collider.gameObject.name;

        //     MeshRenderer lookRender = GameObject.Find(lookingAt).GetComponent<MeshRenderer>();
        //     // lookRender.enabled = false;
        // }
    // }

    // [PunRPC]
    private void displayHover() //object gets highlight if its being looked at
    {
       
        if(CoreServices.InputSystem.EyeGazeProvider.HitInfo.collider != null)
        {
            // Debug.Log("Hit Collider...");
            setHover();
        }                                                                      
        //render current objects emission
    }

    // [PunRPC]
    private void setHover(){ //only called when intential collision from eye-gaze
        // Debug.Log("PUN RPC CALL SETHOVER()...");
            // manager managering = this.manage.GetComponent<manager>();
            // bool on = managering.sgv_always_on; //TODO:should be a function, not directly gaining access to variable    
            string lookingAt = CoreServices.InputSystem.EyeGazeProvider.HitInfo.collider.gameObject.name;
            //get ownership handlercontroller and give to me!!

            current_on = (lookingAt == this.GetComponent<Transform>().name);

            if(current_on) photonView.RequestOwnership(); //NOTE: change
            //instead of requesting ownership, message the current owner to highlight


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
        MeshRenderer render = this.GetComponent<MeshRenderer>();
        Material manipulate_material = render.material;
        bool on = false;

        if (!photonView.IsMine)//set local or networked value
            on = net_current_on; //networked
            // manipulate_material.SetColor("_EmissionColor", net_current_color);//someone else set the color out of here
        else 
            on = current_on; //local

        // Debug.Log("Currently on: " + on);
        
        if(photonView.IsMine && sgv_no_self)
            on = !sgv_no_self;

        if(on)// turn on/off hover
            manipulate_material.SetColor("_EmissionColor", on_color);
        else
            manipulate_material.SetColor("_EmissionColor", off_color);
    }

    // [PunRPC]
    // void runHover()
    // {
    //     sgv_hover = !sgv_hover;
    // }

    // public bool checkGrab()
    // {
    //     isGrabbed = this.GetComponent<ObjectManipulator>().isManipulated();
    //     if(!photonView.IsMine)
    //         return net_isGrabbed;
    //     else
    //         return isGrabbed;
    // }




}
