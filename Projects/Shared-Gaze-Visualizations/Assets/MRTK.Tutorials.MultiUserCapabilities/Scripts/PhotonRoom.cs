using System;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;
using UnityEngine.SceneManagement;
using System.Collections.Generic;


namespace MRTK.Tutorials.MultiUserCapabilities
{
    public class PhotonRoom : MonoBehaviourPunCallbacks, IInRoomCallbacks
    {
        public static PhotonRoom Room;

        [SerializeField] private GameObject photonUserPrefab = default;

        [SerializeField] private GameObject masterUserPrefab = default;

        // public GameObject manage;
        public GameObject easy_task;
        // public GameObject sound_obj;
        // public GameObject medium_task;
        // public GameObject hard_task; 
        public GameObject training;

        // player stats
        public int userHit;
        public int objectSorted;
        public int leftoverObj;

        public int condition_number = 0;

        //sound level

        private GameObject activeObject;
        
        // public GameObject scoreBoard;

        //EXPERIMENTAL
        public GameObject anchor;

        private bool loading = false;

        float current;
        float lapse_score;

        // private PhotonView pv;
        private Player[] photonPlayers;
        private int playersInRoom;
        private int myNumberInRoom;
        private string current_scene;

        // private GameObject module;
        // private Vector3 moduleLocation = Vector3.zero;

        //Active Objects vector
        List<GameObject> listObj = new List<GameObject>();

        //controls for SGV's
        public bool sgv_hover{get;set;}
        public bool sgv_outline{get;set;}
        public bool sgv_always_on{get;set;}
        public bool sgv_no_self{get;set;}

        //Sound Control
        public bool sound;

        //
        // private string current_scene;

        public override void OnPlayerEnteredRoom(Player newPlayer)
        {
            base.OnPlayerEnteredRoom(newPlayer);
            photonPlayers = PhotonNetwork.PlayerList;
            playersInRoom++;
        }

        private void Awake()
        {
            PhotonNetwork.AutomaticallySyncScene = true;
            if (Room == null)
            {
                Room = this;
            }
            else
            {
                if (Room != this)
                {
                    Destroy(Room.gameObject);
                    Room = this;
                }
            }
        }

        public override void OnEnable()
        {
            base.OnEnable();
            PhotonNetwork.AddCallbackTarget(this);
        }

        public override void OnDisable()
        {
            base.OnDisable();
            PhotonNetwork.RemoveCallbackTarget(this);
        }

        private void Start()
        {
            userHit = 0;
            objectSorted = 0;
            leftoverObj = 0;

            sgv_always_on = false;
            sgv_hover = false;
            sgv_outline = false;
            sgv_no_self = false;

            current = Time.time;
            lapse_score = Time.time;
            // pv = GetComponent<PhotonView>();

            Scene currentScene = SceneManager.GetActiveScene();

            // if(first_scene){
            //     first_scene = false;
            // Allow prefabs not in a Resources folder
                if (PhotonNetwork.PrefabPool is DefaultPool pool)
                {
                    
                    //EXPERIMENTAL
                    if (anchor != null) pool.ResourceCache.Add(anchor.name, anchor);

                    //
                    if (photonUserPrefab != null) pool.ResourceCache.Add(photonUserPrefab.name, photonUserPrefab);
                    if (masterUserPrefab != null) pool.ResourceCache.Add(masterUserPrefab.name, masterUserPrefab);

                    if (easy_task != null) pool.ResourceCache.Add(easy_task.name, easy_task);
                    // if (sound_obj != null) pool.ResourceCache.Add(sound_obj.name, sound_obj);
                    // if (medium_task != null) pool.ResourceCache.Add(medium_task.name, medium_task);
                    // if (hard_task != null ) pool.ResourceCache.Add(hard_task.name, hard_task);
                    if (training != null ) pool.ResourceCache.Add(training.name, training);

                }

        }

        void Update()
        {
            // if(PhotonNetwork.IsMasterClient)
            Commands();
        }

        void Commands()
        {
            // Debug.Log(Input.GetButton("AXIS_1")); //presses "1" on keyboard\
            // Debug.Log(Input.GetKey(KeyCode.Alpha1));
            if(!loading){
                /////////////////////// COMMANDS ////////////////////////

                ///////////// GAZE VIZ COMMANDS /////////////////////
                if(Input.GetKey(KeyCode.H))
                {
                    loading = true;
                    // Debug.Log("Hover pressed...");
                    GetComponent<Logger>().writeStringToLog("SceneChange","Hover pressed...");
                    PhotonView photonView = PhotonView.Get(this);
                    photonView.RPC("runHover",RpcTarget.All);
                }
                if(Input.GetKey(KeyCode.T))
                {
                    loading = true;
                    // Debug.Log("Outline pressed...");
                    GetComponent<Logger>().writeStringToLog("SceneChange","Outline pressed...");
                    PhotonView photonView = PhotonView.Get(this);
                    photonView.RPC("runOutline", RpcTarget.All);

                }
                if(Input.GetKey(KeyCode.O))
                {
                    loading = true;
                    // Debug.Log("Always on...");
                    GetComponent<Logger>().writeStringToLog("SceneChange","Always on pressed...");
                    PhotonView photonView = PhotonView.Get(this);
                    photonView.RPC("runAlwaysOn", RpcTarget.All);
                }
                if(Input.GetKey(KeyCode.N))
                {
                    loading = true;
                    // Debug.Log("Always on...");
                    GetComponent<Logger>().writeStringToLog("SceneChange","No self pressed...");
                    PhotonView photonView = PhotonView.Get(this);
                    photonView.RPC("runNoSelf", RpcTarget.All);
                }



                ////////// Scene Commands ////////////////////
                if(Input.GetKey(KeyCode.Keypad1))
                {
                    loading = true;
                    // Debug.Log("Starting first scene...");
                    GetComponent<Logger>().writeStringToLog("SceneChange","Starting first scene...");
                    CreateScene1();
                }

                if(Input.GetKey(KeyCode.Z))
                {
                    loading = true;
                    // Debug.Log("Starting first scene...");
                    GetComponent<Logger>().writeStringToLog("SceneChange","Adding sound...");
                    photonView.RPC("runSound", RpcTarget.All);
                }
 
                //EXPERIMENTAL
                if(Input.GetKey(KeyCode.Keypad5))
                {
                    loading = true;
                    // Debug.Log("Deleting");
                    GetComponent<Logger>().writeStringToLog("SceneChange","Deleting scene...");

                    // Debug.Log(listObj.Count);
                    foreach (var objects in listObj)
                    {
                        PhotonNetwork.Destroy(objects);
                    }
                    listObj.Clear();
                }

                if(Input.GetKey(KeyCode.B))
                {
                    loading = true;
                    condition_number++;
                    var output_str = "Begin condition: " + condition_number;
                    Debug.Log(output_str);
                    GetComponent<Logger>().writeStringToLog("SceneChange",output_str);
                }


                ////////////////////// END COMMANDS //////////////////////

                current = lapse_score = Time.time;
            }
            if(loading){
                LoadWait(1); //wait 5 seconds
            }
        }

        private void LoadWait(int time)
        {
            var loading_time = time;
                current = Time.time; //udpate current time
                if(current - lapse_score > loading_time ){ //compare since loading began
                    Debug.Log("Done waiting for load...");
                    lapse_score = Time.time;
                    current = Time.time;
                    loading = false;
                }
        }

        public override void OnJoinedRoom()
        {
            base.OnJoinedRoom();

            photonPlayers = PhotonNetwork.PlayerList;
            playersInRoom = photonPlayers.Length;
            myNumberInRoom = playersInRoom;
            // PhotonNetwork.NickName = myNumberInRoom.ToString();
            PhotonNetwork.NickName = GenerateName(7);
            StartGame();
        }

        
        private static string GenerateName(int len)
        { 
            System.Random r = new System.Random();
            string[] consonants = { "b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "l", "n", "p", "q", "r", "s", "sh", "zh", "t", "v", "w", "x" };
            string[] vowels = { "a", "e", "i", "o", "u", "ae", "y" };
            string Name = "";
            Name += consonants[r.Next(consonants.Length)].ToUpper();
            Name += vowels[r.Next(vowels.Length)];
            int b = 2; //b tells how many times a new letter has been added. It's 2 right now because the first two letters are already in the name.
            while (b < len)
            {
                Name += consonants[r.Next(consonants.Length)];
                b++;
                Name += vowels[r.Next(vowels.Length)];
                b++;
            }

            return "user_" + Name;
        }

        private void StartGame()
        {
            if(PhotonNetwork.IsMasterClient)
                CreateMasterPlayer();
            else
                CreatePlayer();

            if (!PhotonNetwork.IsMasterClient) return;
            
            GetComponent<Logger>().enabled = true;

            // if (TableAnchor.Instance != null)
            Scene currentScene = SceneManager.GetActiveScene(); 
            // CreateInteractableObjects();
        }

        private void CreateMasterPlayer()
        {
            var MasterPlayer = PhotonNetwork.Instantiate(masterUserPrefab.name, Vector3.zero, Quaternion.identity);

        }


        private void CreatePlayer()
        {
            var player = PhotonNetwork.Instantiate(photonUserPrefab.name, Vector3.zero, Quaternion.identity);//only one user type
        }

        public void CreateInteractableObjects()
        {
            Debug.Log("Creating objects...");
            var start_world = PhotonNetwork.InstantiateRoomObject(easy_task.name, easy_task.transform.position, easy_task.transform.rotation);
            current_scene = start_world.name;
        }

        // [PunRPC]
        public void CreateScene1()
        {   
            Debug.Log("Creating objects...");
            var start_world = PhotonNetwork.InstantiateRoomObject(easy_task.name, easy_task.transform.position, easy_task.transform.rotation);
            current_scene = start_world.name;
            Debug.Log("Adding object to list"); //TODO: add to logging
            listObj.Add(start_world);
        }
      

        public void LeftoverObject(string obj)
        {
            leftoverObj++;           
            GetComponent<Logger>().writeStringToLog("Object", "LeftoverObject" + "\t" + leftoverObj.ToString() + "\t" + obj);
        }

        public void ObjectSorted(string obj)
        {
            objectSorted++;
            GetComponent<Logger>().writeStringToLog("Object", "SortedObject" + "\t" + objectSorted.ToString() + "\t" + obj);
        }

        public void UserHitLog(string obj)
        {
            userHit++;
            GetComponent<Logger>().writeStringToLog("UserInteraction", "UserHit" + "\t" + userHit.ToString() + "\t" + obj);
        }


        public void updateLogger(string UserID, string ObjectID)
        {
                GetComponent<Logger>().userEyeInfo(UserID,ObjectID);
        }

        public void updateLogInteraction(string type, string message)
        {
            photonView.RPC("updateLogExternal", RpcTarget.MasterClient,type + "\t" + message);
        }

        [PunRPC]
        public void updateLogExternal(string message)
        {
            if(!PhotonNetwork.IsMasterClient) return;
                GetComponent<Logger>().writeStringToLog("UserInteraction", message);
        }

        [PunRPC]
        public void runSound()
        {
            sound = !sound;
            if(sound)
                this.GetComponent<AudioSource>().enabled = true;
            else
                this.GetComponent<AudioSource>().enabled = false;
            PrintStatusSGV();
        }

        [PunRPC]
        public void runHover()
        {
            sgv_hover = !sgv_hover;
            PrintStatusSGV();     
            // if(PhotonNetwork.IsMasterClient)
            //     sgv_hover = false;
        }

        [PunRPC]
        void runNoSelf()
        {
            sgv_no_self = !sgv_no_self;
            PrintStatusSGV();
            // if(PhotonNetwork.IsMasterClient)
            //     sgv_hover = false;
        }

        [PunRPC]
        void runOutline()
        {

            sgv_outline = !sgv_outline;
            PrintStatusSGV();
            // if(PhotonNetwork.IsMasterClient)
            //     sgv_outline = false;

        }

        [PunRPC]
        void runAlwaysOn() //ray
        {
            sgv_always_on = !sgv_always_on;
            PrintStatusSGV();
            // if(PhotonNetwork.IsMasterClient)
            //     sgv_always_on = false;
        }

        void PrintStatusSGV()
        {
            Debug.Log("Always on: " + sgv_always_on + "\nHover: " +  sgv_hover + "\nNo Self: " + sgv_no_self + "\nOutline: " + sgv_outline + "\nSound: " + sound);
        }


    }
}

