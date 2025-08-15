using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Microsoft.MixedReality.Toolkit;
using MRTK.Tutorials.MultiUserCapabilities;

public class gaze_position : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public Vector3 origin()
    {
        return CoreServices.InputSystem.EyeGazeProvider.GazeOrigin;
    }

    public Vector3 direction()
    {
        return CoreServices.InputSystem.EyeGazeProvider.GazeDirection;
    }
}
