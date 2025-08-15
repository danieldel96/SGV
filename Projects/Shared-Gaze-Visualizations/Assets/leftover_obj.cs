using System;
using System.Timers;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Microsoft.MixedReality.Toolkit;
using MRTK.Tutorials.MultiUserCapabilities;
using Photon;
using Photon.Pun;

public class leftover_obj : MonoBehaviourPun
{
    // public MeshRenderer render; //self render
    public GameObject otherObject;
    public string name_;

    public GameObject gameManager;


    // Start is called before the first frame update
    void Start()
    {
        name_ = transform.gameObject.name;

    }

    // Update is called once per frame
    void Update()
    {
        
    }


    void OnTriggerEnter(Collider collider){
        if(collider.gameObject.name == "wall")
        {
                photonView.RPC("LeftoverObjectWall", RpcTarget.MasterClient);
                DestroyOnNetwork();
        }
        if(collider.gameObject.name == "floor")
        {
                photonView.RPC("LeftoverObjectFloor", RpcTarget.MasterClient);
                DestroyOnNetwork();
        }
            // Debug.Log("sorted..." + collider.gameObject.name);
    }


    [PunRPC]
    void LeftoverObjectWall() //i didn't want to add another parameter to be communicating through RPCs :p
    {
        if(PhotonNetwork.IsMasterClient)
            GameObject.Find("NetworkRoom").GetComponent<PhotonRoom>().LeftoverObject("wall");
    }

    [PunRPC]
    void LeftoverObjectFloor()
    {
        if(PhotonNetwork.IsMasterClient)
            GameObject.Find("NetworkRoom").GetComponent<PhotonRoom>().LeftoverObject("floor");
    }


    public void DestroyOnNetwork()
    {
        GetComponent<PhotonView>().RPC("NetworkDestroy", RpcTarget.All);
    }

    [PunRPC]
    private void NetworkDestroy()
    {
        Destroy(this.gameObject);
    }

    // [PunRPC]
    // void ObjectSorted(string obj)
    // {
    //     if(PhotonNetwork.IsMasterClient)
    //         GameObject.Find("NetworkRoom").GetComponent<PhotonRoom>().ObjectSorted(obj);
    // }



}
