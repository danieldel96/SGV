using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon;
using Photon.Pun;
using System;
using System.Threading;



public class move : MonoBehaviourPun
{
    public bool active_output = false;

    PhotonView pv;
    
    public float speed = 0.5f;

    float speed_new = 0.005f;

    static int interval = 16;

    DateTime nextExecution = DateTime.UtcNow.AddMilliseconds(interval);
    
    DateTime currentTime = DateTime.UtcNow;


    // Start is called before the first frame update
    void Start()
    {
        pv = GetComponent<PhotonView>();
        speed = speed/1000.0f;

    }

    // Update is called once per frame (24 fps) 
    void Update()
    {

        currentTime = DateTime.UtcNow;

        if(pv.IsMine){

            if (currentTime >= nextExecution)
            {
                // Execute your task
                // Debug.Log($"Script executed at: {currentTime:HH:mm:ss.fff}");

                //the actual physical movement
                transform.position = transform.position + new Vector3(0,0,speed_new);

                // Schedule the next execution
                nextExecution = nextExecution.AddMilliseconds(interval);

                
            }
            Thread.Sleep(1);
        }

        //old move
        // if(pv.IsMine && !active_output)
        //     transform.position = transform.position + new Vector3(0,0,speed);
    }

}
