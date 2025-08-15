/*
match_object.cs
Daniel Delgado
Ruiz Lab
This script checks collisions between current object and other objects and compares the id's to check if it is a matching object. If so, the current object is made
the other made to disappear. Meaning the object has been properly placed.
*/
using System.Collections;
using System.Collections.Generic;
using Photon.Pun;
using UnityEngine;

public class match_object : MonoBehaviourPun
{
    public MeshRenderer render; //self render
    public GameObject otherObject;
    public string name_;

    public GameObject gameManager;

    public bool attached;

    //TODO: track current render and other objects render


    
    //make a copy of material during initialization


    // Start is called before the first frame update
    void Start()
    {
        name_ = transform.gameObject.name;
        render = this.GetComponent<MeshRenderer>();
        render.enabled = false;
        attached = false;
    }

    // Update is called once per frame
    void Update()
    {
        
    }


      //Detect collisions between the GameObjects with Colliders attached
    void OnTriggerEnter(Collider collision)
    {
        PhotonView photonView = PhotonView.Get(this);
        if(collision.gameObject != null)
            photonView.RPC("objectCollision", RpcTarget.All, collision.gameObject.name);
    }

    [PunRPC]
    void objectCollision(string collision)
    {
                // string name = transform.name;
        //Check for a match with the specified name on any GameObject that collides with your GameObject
        if (collision == name_ + "_m")
        {
            render.enabled = true;
            MeshRenderer otherRender = GameObject.Find(collision).GetComponent<MeshRenderer>();
            Transform otherTransform = GameObject.Find(collision).GetComponent<Transform>();
            otherTransform.position = new Vector3(100.0f, 1.0f, 1.0f);
            otherRender.enabled = false;

            //TODO: also remove
            BoxCollider otherCollider = GameObject.Find(name_).GetComponent<BoxCollider>();
            otherCollider.isTrigger = false;

            //If the GameObject's name matches the one you suggest, output this message in the console
            //TODO: count correct collisions
            if(!attached){
                // Debug.Log(name);
                manager mange = gameManager.GetComponent<manager>();
                mange.successCount++;
                attached = true;
            }
        }
        else if(collision.Substring(collision.Length - 2) == "_m") //colliding with 
        {
            // Debug.Log("Colliding: " + transform.name + " | " + collision.gameObject.name);
            
            //TODO: send count error collisions
            if(attached && !GameObject.Find(name_).GetComponent<BoxCollider>().isTrigger){
                manager mange = gameManager.GetComponent<manager>();
                mange.errorCount++;
            }
        }

    }

    void OnCollisionEnter(Collision collider){
        PhotonView photonView = PhotonView.Get(this);
        if(collider.gameObject != null)
            photonView.RPC("objectError", RpcTarget.All, collider.gameObject.name);
    }

    [PunRPC]
    void objectError(string collision)
    {
        if(collision.Substring(collision.Length - 2) == "_m") //colliding with 
        {
            if(attached && !GameObject.Find(name_).GetComponent<BoxCollider>().isTrigger){
                manager mange = gameManager.GetComponent<manager>();
                mange.errorCount++;
            }
        }
    }
}
