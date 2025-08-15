using System;
using System.Timers;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Microsoft.MixedReality.Toolkit;
using MRTK.Tutorials.MultiUserCapabilities;
using Photon;
using Photon.Pun;

public class danger_obj : MonoBehaviourPun
{
    // public MeshRenderer render; //self render
    public GameObject otherObject;
    public string name_;

    public GameObject gameManager;


    // Start is called before the first frame update
    void Start()
    {
        name_ = transform.gameObject.name;

        var rand = UnityEngine.Random.Range(-1.0f,1.0f);
        if(rand > -0.4f) //80%
            this.GetComponent<gaze_outline>().dangerObj = true;
    }

    // Update is called once per frame
    void Update()
    {
        
    }


    void OnCollisionEnter(Collision collider){
        // Debug.Log("Colliding: ");
        if(collider.gameObject != null && collider.gameObject.name == "rotation_parent") // user is hit
        {
            photonView.RPC("UserHit", RpcTarget.MasterClient);
            gameObject.GetComponent<leftover_obj>().DestroyOnNetwork();
            // DestroyOnNetwork(); // only let objects hit once
        }
    }

    [PunRPC]
    void UserHit()
    {
        if(PhotonNetwork.IsMasterClient)
            GameObject.Find("NetworkRoom").GetComponent<PhotonRoom>().UserHitLog(name_);
    }



}
