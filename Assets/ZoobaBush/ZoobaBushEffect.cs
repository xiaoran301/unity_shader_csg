using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ADBannerView = UnityEngine.iOS.ADBannerView;

public class ZoobaBushEffect : MonoBehaviour
{
    public GameObject _bushEffect;

    public GameObject _inside;
    public AnimationCurve _curve;
    public int InOthersShareView;
    
    private Material _mat;
    private float _accTime = 0.0f;
    private bool _exiting = false;
    private bool _entering = false;
    private Transform _parentTrans;
    private Vector3 _oldPos;
    private Vector3 _oldDir;
    private float _testSpeed;

    // Start is called before the first frame update
    void Start()
    {
        _parentTrans = transform.parent;
        _oldPos = _parentTrans.position;
        _mat = _inside.GetComponent<Renderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.Log("update");
        if (_bushEffect.activeSelf == false)
        {
            return;
        }

        _accTime += Time.deltaTime;
        float cof = _curve.Evaluate(_accTime);
        //Debug.LogFormat("cof: {0},_accTime: {1}",cof,_accTime);
        if (_exiting)
        {
            cof = 1 - cof;
            if (cof <= 0.01f)
            {
                _bushEffect.SetActive(false);
                _exiting = false;
            }
        }
        _bushEffect.transform.localScale = new Vector3(cof, 1.0f, cof);
        
        // move pos update
        _mat.SetVector("_MainPlayerPos",new Vector4(_parentTrans.position.x,_parentTrans.position.y,_parentTrans.position.z));
        
        // dir
        var dis = _parentTrans.position - _oldPos;
        _oldPos = _parentTrans.position;
        
        var dir = Vector3.Normalize(dis);
        if(!dir.Equals(Vector3.zero))
        {
            _oldDir = dir;
        }
        var speed = dis.magnitude / Time.deltaTime;
        // var w = speed;
        _testSpeed += 0.01f;
        if (_testSpeed >= 1.0f)
        {
            _testSpeed = 0.0f;
        }
        var w = _testSpeed;
        _mat.SetVector("_MovementDir",new Vector4(_oldDir.x,_oldDir.y,_oldDir.z,w));
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("cao"))
        {
            Debug.LogFormat("zoo trigger enter cao");
            _bushEffect.SetActive(true);
            _accTime = 0;
            _exiting = false;
            _entering = true;
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("cao"))
        {
            Debug.LogFormat("zoo trigger exit cao");
           // _bushEffect.SetActive(false);
           _accTime = 0;
           _exiting = true;
           _entering = false;
        }
    }
}
