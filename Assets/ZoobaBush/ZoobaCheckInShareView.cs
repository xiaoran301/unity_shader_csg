using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public struct DebugShareViewRefCnt
{
    public GameObject obj;
    public int refCnt;

}
public class ZoobaCheckInShareView : MonoBehaviour
{
    // Start is called before the first frame update

    public ZoobaBushEffect _bindZoobaBushEffect;
    public DebugShareViewRefCnt[] _debugShareView = new DebugShareViewRefCnt[10];
    private Dictionary<GameObject,int> _viewedBushPlayers = new Dictionary<GameObject, int>();
    
    void Start()
    {
        _viewedBushPlayers.Clear();
    }

    // Update is called once per frame
    void Update()
    {
        foreach (var key  in _viewedBushPlayers.Keys)
        {
            var bush = key.GetComponent<ZoobaBushEffect>();
            Debug.LogFormat("bush.enabled1: {0}",bush.gameObject.activeSelf);
        }
    }
    private void OnTriggerEnter(Collider other)
    {

        if (other.gameObject.CompareTag("zoobaBushPlayer"))
        {
            //ReliableOnTriggerExit.NotifyTriggerEnter(other,other.gameObject,OnTriggerExit);
            var bush = other.GetComponent<ZoobaBushEffect>();
            bush.InOthersShareView += 1;
            if (!_viewedBushPlayers.ContainsKey(other.gameObject))
            {
                _viewedBushPlayers.Add(other.gameObject,0);
                
            }

            _viewedBushPlayers[other.gameObject] += 1;

        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("zoobaBushPlayer"))
        {
            //ReliableOnTriggerExit.NotifyTriggerExit(other,other.gameObject);
            var bush = other.GetComponent<ZoobaBushEffect>();
            bush.InOthersShareView -= 1;
            _viewedBushPlayers.Remove(other.gameObject);
        }
    }

    private void OnEnable()
    {
        Debug.LogFormat("on enablel");
    }
    

    private void OnDisable()
    {
        foreach (var key  in _viewedBushPlayers.Keys)
        {
            var bush = key.GetComponent<ZoobaBushEffect>();
            bush.InOthersShareView -= 1;
        }
        _viewedBushPlayers.Clear();
    }

    private void OnTriggerStay(Collider other)
    {
       //Debug.LogFormat("stay other tag: {0} name: {1} parentName: {2}",other.gameObject.tag,other.gameObject.name,other.transform.parent.gameObject.name); 
    }
}
