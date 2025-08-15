/* Experimental script for measuring eye-contact duration between two users using microsoft hololens 2 eye-tracking
*
*/


using System;
using System.Timers;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Microsoft.MixedReality.Toolkit;
using MRTK.Tutorials.MultiUserCapabilities;
using Photon;
using Photon.Pun;

public class eye_contact : MonoBehaviourPun, IPunObservable
{

    string old_string;
    string new_string;

    
    //TODO: Streaming current gaze
    public Color on_color;
    public Color off_color;
    public bool current_on = false;
    public bool net_current_on = false;

    public GameObject lookingAt;
    
    // private GameObject control;
    // private bool sgv_hover;


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
        // sgv_hover = true;

        PhotonView pv = GetComponent<PhotonView>();
 
        //after starting your game in editor you should see this component on the list of
        //Observed Components in your Inspector after selecting synchronized object.
        if (pv) pv.ObservedComponents.Add(this);
        // Debug.Log(pv.ViewID);
    }

    // Update is called once per frame
    void Update()
    {
        eyeContact();
    }

    void eyeContact(){
        lookingAt = CoreServices.InputSystem.EyeGazeProvider.HitInfo.collider.gameObject; //object looking at
        new_string = lookingAt.name; //object looking at name

        PhotonView pv = GetComponent<PhotonView>(); //self

        if (new_string.ToLower().Contains("wall")) return; //just looking at a wall lol

        try{
            if(new_string != old_string){
                // Debug.Log(pv.ViewID + "is looking at..." + lookingAt.GetComponent<PhotonView>().ViewID); //[self] is looking at [object]
                PhotonView photonView = PhotonView.Get(this);

                photonView.RPC("updatePlayerEyeInteractions", RpcTarget.All, pv.ViewID.ToString(), lookingAt.GetComponent<PhotonView>().ViewID.ToString(), "12:00 AM");
                old_string = new_string; //only update if change; reduces number of network communication instances
            }
        }
        catch{

        }

    }
    
    [PunRPC]
    public void updatePlayerEyeInteractions(string UserID, string ObjectID, string timest)
    {
            if (!PhotonNetwork.IsMasterClient) return; //Only master client needs to update logger with player attributes
            
            Debug.Log(UserID + " " + ObjectID + " " + timest);

    }


}
