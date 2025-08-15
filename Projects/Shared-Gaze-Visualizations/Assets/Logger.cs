// using System.Collections;
// using System.Collections.Generic;
// using UnityEngine;
// using System.IO;

using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using UnityEngine.SceneManagement;
using System.IO;


//playerid objectid timestamp

public class Logger : MonoBehaviour
{
    private string logFile;

    public bool isLogging;

    // static log file names and formatters
    private static string LOGFILE_DIRECTORY = "eye-logs";
    private static string LOGFILE_NAME_BASE = "-eye-log.tsv";
    private static string LOGFILE_NAME_TIME_FORMAT = "yyyy-MM-dd_HH-mm-ss"; // prefix of the logfile, created when application starts (year - month - day - hour - minute - second)
    
    // Start is called before the first frame update

    // Update is called once per frame


    public void userEyeInfo(string UserID, string ObjectID)
    {
        writeStringToLog("LOCATION",UserID + "\t"+ ObjectID);
        // Debug.Log(UserID + " is Looking At " + ObjectID + " at " + System.DateTime.Now.ToString("h:mm:ss tt"));
    }


    void Awake()
    {
        DontDestroyOnLoad(this.gameObject);
    }

    // Start is called before the first frame update
    void Start()
    {
        var date = DateTime.Now.ToString("hh:mm:ss.fff");

        if (this.isLogging)
        {
            //if (!Directory.Exists(LOGFILE_DIRECTORY))
            //{
            //    Directory.CreateDirectory(LOGFILE_DIRECTORY);
            //}

            this.logFile = LOGFILE_DIRECTORY + "/" + System.DateTime.UtcNow.ToString(LOGFILE_NAME_TIME_FORMAT) + LOGFILE_NAME_BASE;

            File.Create(this.logFile);

            // print("Got Here");

            if (File.Exists(this.logFile))
            {
                Debug.Log("[LoggingSystem] LogFile created at " + this.logFile);
            }
            else
            {
                Debug.LogError("[LoggingSystem] Error creating LogFile");
            }
        }
    }


    public void writeStringToLog(string type, string message)
    {
        if (this.isLogging)
        {
            if (File.Exists(this.logFile))
            {
                TextWriter tw = new StreamWriter(this.logFile, true);
                //tw.WriteLine(Time.realtimeSinceStartup.ToString() + "\t" + type + "\t" + message);
                tw.WriteLine(DateTime.Now.ToString("hh:mm:ss.fff") + "\t" + type + "\t" + message);

                tw.Close();
            }
        }
    }

}
