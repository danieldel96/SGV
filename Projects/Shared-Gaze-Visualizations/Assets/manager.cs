/*This script manages miscellaneous objects in the scene
* press the key "h" to activate/deactivate hover
* press the key "t" to activate/deactivate trigger
*deactivating trigger leaves it as always on
*/
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Microsoft.MixedReality.Toolkit;
using MRTK.Tutorials.MultiUserCapabilities;

public class manager : MonoBehaviour
{
    public bool sgv_hover{get;set;}
    public bool sgv_trigger{get;set;}
    public bool sgv_always_on{get;set;}
    public int errorCount;
    public int successCount;
    public GameObject scoreBoard;
    float start;
    float current;
    float lapse_score;


    public GameObject visualization;

    //TODO: streaming text

    void Awake()
    {
        // #Critical
        // this makes sure we can use PhotonNetwork.LoadLevel() on the master client and all clients in the same room sync their level automatically
        PhotonNetwork.AutomaticallySyncScene = true;
    }
    // Start is called before the first frame update
    void Start()
    {
        start = Time.time;
        lapse_score = Time.time;
        // lapse_eye = DateTime.Now;
        setCondition(true,true,true); //or true true true?
        // last_rotation = Quaternion.LookRotation(CoreServices.InputSystem.EyeGazeProvider.GazeDirection);
    }

    // Update is called once per frame
    void Update()
    {
        // updateTime();

        updateScore();
        // if (PhotonNetwork.IsMasterClient)
        //     Commands();
        
        // updateVisualization();

    }

    // [PunRPC]
    private void updateScore(){
        current = Time.time;
        TMPro.TMP_Text gameText = scoreBoard.GetComponent<TMPro.TMP_Text>();
        gameText.text = " ScoreBoard: \n" + "Success: " + successCount + "\n" + "Error: " + errorCount + "\n" + "Time: " + string.Format("{0:F1}",(current-start))  + "s";
    }
    
    // [PunRPC]
    // private void updateTime(){
    //     current = Time.time;
    //     // Debug.Log(current.Second - lapse.Second);
    //     if((current.Second - lapse_score.Second) > 5 ){
    //         lapse_score = DateTime.Now;
    //         // Debug.Log(current.Second - start.Second);
    //     }
    // }

    [PunRPC]
    public void setCondition(bool hover, bool trigger, bool always_on) 
    {
        sgv_hover = hover;
        sgv_trigger = trigger;
        sgv_always_on = always_on;
    }




}
