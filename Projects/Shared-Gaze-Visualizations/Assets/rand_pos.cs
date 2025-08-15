//random positioning at instantion, but also changes the name per photon view :) i love unnecessary dependencies :-)

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using Photon;
using Photon.Pun;


public class rand_pos :  MonoBehaviourPun
{
    // Start is called before the first frame update
    void Start()
    {
        PhotonView pv = PhotonView.Get(this);
        transform.name = transform.name + pv.ViewID;
        var position = new Vector3(Random.Range(-0.5f, 0.5f), transform.position.y, Random.Range(0.0f, -4.0f));
        if(PhotonNetwork.IsMasterClient)
            transform.position = position;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
