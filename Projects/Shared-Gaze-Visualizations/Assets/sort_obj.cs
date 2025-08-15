using System;
using System.Timers;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Microsoft.MixedReality.Toolkit;
using MRTK.Tutorials.MultiUserCapabilities;
using Photon;
using Photon.Pun;

public class sort_obj : MonoBehaviourPun
{
    // public MeshRenderer render; //self render
    public GameObject otherObject;
    public string name_;

    public GameObject gameManager;


    // Start is called before the first frame update
    void Start()
    {
        name_ = transform.gameObject.name;
        // Debug.Log(name_);

    }

    // Update is called once per frame
    void Update()
    {
        
    }


    void OnTriggerEnter(Collider collider){
        if(collider.gameObject.name[0] == 'r')
            return; //danger object, dont sort

        // Debug.Log("name of object colliding: " + collider.gameObject.name + collider.gameObject.name.Contains(name_) + name_);
        
        if(collider.gameObject.name.Contains(name_)){
            // collider.gameObject.GetComponent<BoxCollider>().enabled = false; //shut off functionality of collision
            photonView.RPC("ObjectSorted", RpcTarget.MasterClient, collider.gameObject.name);
            DestroyOnNetwork(collider.gameObject.name);
        }
        // Debug.Log("after deleting object");

            // Debug.Log("sorted..." + collider.gameObject.name);
    }


    [PunRPC]
    void ObjectSorted(string obj)
    {
        if(PhotonNetwork.IsMasterClient)
            GameObject.Find("NetworkRoom").GetComponent<PhotonRoom>().ObjectSorted(obj); // Log
    }


    

    public void DestroyOnNetwork(string name)
    {
        GetComponent<PhotonView>().RPC("NetworkDestroy", RpcTarget.All, name);
    }

    [PunRPC]
    private void NetworkDestroy(string name)
    {
        Destroy(GameObject.Find(name));
    }



}
