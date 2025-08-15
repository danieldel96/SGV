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

public class EyeInteractions : MonoBehaviourPun, IPunObservable
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
        if(!PhotonNetwork.IsMasterClient)
            eyeContact();
    }

    void eyeContact(){
        try{
            lookingAt = CoreServices.InputSystem.EyeGazeProvider.HitInfo.collider.gameObject; //object looking at
        }
        catch{
            return;
        }
        var gazeOrigin = CoreServices.InputSystem.EyeGazeProvider.GazeOrigin;
        var gazeDirection = CoreServices.InputSystem.EyeGazeProvider.GazeDirection;
        
        string loc_org = "ORIGIN(x,y,z):" + "\t" + gazeOrigin.x + "\t" + gazeOrigin.y+ "\t" + gazeOrigin.z;
        string loc_dir = "Direction(x,y,z):" + "\t" + gazeDirection.x + "\t" + gazeDirection.y+ "\t" + gazeDirection.z;
        string location = loc_org + "\t" + loc_dir;
        //gazeorigin
        //gaze direction

        new_string = lookingAt.name; //object looking at's name

        PhotonView pv = GetComponent<PhotonView>(); //self


        try{
            if(new_string != old_string){ //ATTENTION (TODO): Remove "true" to activate on action

                string objectAt = "";

                PhotonView photonView = PhotonView.Get(this);

                if (new_string.ToLower().Contains("wall")) 
                    objectAt = new_string; //just looking at a wall lol
                else
                    objectAt = lookingAt.GetComponent<Transform>().name;
                    // objectAt = lookingAt.GetComponent<PhotonView>().ViewID.ToString(); //photon id, walls are tracked because they are static

                photonView.RPC("updatePlayerEyeInteractions", RpcTarget.MasterClient, PhotonNetwork.NickName, objectAt + "\t"  + location);
                old_string = new_string; //only update if change; reduces number of network communication instances
            }
        }
        catch{

        }

    }

    //master client needs to communicate withitself about updating csv file
    [PunRPC]
    public void updatePlayerEyeInteractions(string UserID, string ObjectID)
    {
            if (!PhotonNetwork.IsMasterClient) return; //Only master client needs to update logger with player attributes
            GetComponent<PhotonRoom>().updateLogger(UserID,ObjectID);
            // Debug.Log(UserID + " " + ObjectID + " " + timest);

    }


}
