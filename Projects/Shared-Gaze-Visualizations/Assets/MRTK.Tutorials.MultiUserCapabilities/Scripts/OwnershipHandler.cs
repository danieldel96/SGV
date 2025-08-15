using System;
using Microsoft.MixedReality.Toolkit.Input;
using Microsoft.MixedReality.Toolkit;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace MRTK.Tutorials.MultiUserCapabilities
{
    [RequireComponent(typeof(PhotonView), typeof(GenericNetSync))]
    public class OwnershipHandler : MonoBehaviourPun, IPunOwnershipCallbacks, IMixedRealityInputHandler
    {
        public void OnInputDown(InputEventData eventData)
        {
            // Debug.Log("OnInputDown");
            photonView.RequestOwnership();
        }

        public void OnInputUp(InputEventData eventData)
        {
        }

        public void OnOwnershipRequest(PhotonView targetView, Player requestingPlayer)
        {
            // Debug.Log("OnOwnershipRequest");
            targetView.TransferOwnership(requestingPlayer);
        }

        public void OnOwnershipTransfered(PhotonView targetView, Player previousOwner)
        {
        }

        public void OnOwnershipTransferFailed(PhotonView targetView, Player previousOwner)
        {
        }

        private void TransferControl(Player idPlayer)
        {
            // Debug.Log("TransferControl");
            if (photonView.IsMine) photonView.TransferOwnership(idPlayer);
        }

        private void OnTriggerEnter(Collider other)
        {
            // Debug.Log("OnTriggerEnter");
            if (photonView != null) photonView.RequestOwnership();
            // Debug.Log("Asking for control...");
        }

        private void OnTriggerExit(Collider other)
        {
        }

        public void RequestOwnership()
        {
            // Debug.Log("RequestOwnership");
            photonView.RequestOwnership();
        }
    }
}
