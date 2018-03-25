using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleRain : MonoBehaviour
{
    private ParticleSystem rain;
    private ParticleSystem.Particle[] rainDrops;
    private Color rainColor;
    private int totalDrops;

    // Use this for initialization
    void Start ()
    {
        rain = GetComponent<ParticleSystem>();
        totalDrops = rain.particleCount;
    }
	
	// Update is called once per frame
	void Update ()
    {
        for (int i = 0; i < totalDrops; i++)
        {
            rainColor = new Color(255, 0, 0, Random.Range(0, 0.8f));
            rainDrops[i].startColor = rainColor;  
        }
        rain.SetParticles(rainDrops, totalDrops); 
	}
}
