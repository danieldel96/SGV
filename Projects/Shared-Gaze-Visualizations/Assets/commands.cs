using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class commands : MonoBehaviour
{
    private float current;
    private float lapse_score;
    private bool loading = false;


    // Start is called before the first frame update
    void Start()
    {
        current = Time.time;
        lapse_score = Time.time;
    }

    // Update is called once per frame
    void Update()
    {
        //if master
        Commands();
    }
    
    void Commands()
    {
        // Debug.Log(Input.GetButton("AXIS_1")); //presses "1" on keyboard\
        // Debug.Log(Input.GetKey(KeyCode.Alpha1));
        if(!loading){
            if(Input.GetKey(KeyCode.H))
            {
                loading = true;
                Debug.Log("Hover pressed...");
                PhotonView photonView = PhotonView.Get(this);
                photonView.RPC("runHover",RpcTarget.All);
            }
            if(Input.GetKey(KeyCode.T))
            {
                loading = true;
                Debug.Log("Trigger pressed...");
                PhotonView photonView = PhotonView.Get(this);
                photonView.RPC("runTrigger", RpcTarget.All);
            }
            if(Input.GetKey(KeyCode.O))
            {
                loading = true;
                Debug.Log("Always on...");
                PhotonView photonView = PhotonView.Get(this);
                photonView.RPC("runAlwaysOn", RpcTarget.All);
            }
            // if(Input.GetKey(KeyCode.D))
            // {
            //     Debug.Log("Deleting Scene...");
            //     var room = GameObject.Find("NetworkRoom").GetComponent<PhotonRoom>();
            //     room.DestroyObjects();
            //     loading = true;
            // }

            if(Input.GetKey(KeyCode.Keypad1))
            {
                loading = true;
                Debug.Log("Starting first scene...");
                PhotonView photonView = PhotonView.Get(this);
                photonView.RPC("CreateScene1", RpcTarget.All);
            }
            if(Input.GetKey(KeyCode.Keypad2))
            {              
                loading = true;     
                PhotonView photonView = PhotonView.Get(this);
                photonView.RPC("runAlwaysOn", RpcTarget.All);
            }
            if(Input.GetKey(KeyCode.Keypad3))
            {
                loading = true;
                PhotonView photonView = PhotonView.Get(this);
                photonView.RPC("runAlwaysOn", RpcTarget.All);
            }
            current = lapse_score = Time.time;
        }
        if(loading){
            var loading_time = 5;
            current = Time.time; //udpate current time
            if(current - lapse_score > loading_time ){ //compare since loading began
                Debug.Log("Done waiting for load...");
                lapse_score = Time.time;
                current = Time.time;
                loading = false;
            } 
        }
    }
    

}
