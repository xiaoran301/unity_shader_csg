﻿Shader "Custom/CutterMeshEx"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		_MovementDir("MovementDir",Vector)=(0,0,0,0)
		_MainPlayerPos("MainPlayerPos",Vector)=(0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Pass //1
        {
            ZTest LEqual
            ZWrite Off
            ColorMask 0
            Cull Back

            Stencil
            {
                Ref 128
                ReadMask 128
                WriteMask 127
                Comp Equal
                Pass IncrSat
                ZFail Keep
            }

            CGPROGRAM

                    // Physically based Standard lighting model, and enable shadows on all light types
//            #pragma Standard fullforwardshadows
            #pragma vertex vert
            #pragma fragment surf

            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma target 3.0

            sampler2D _MainTex;
            #include "./Pass/BaseCG.cginc"
            ENDCG
        }

        Pass //2
        {
            ZTest Greater
            ZWrite On
            ColorMask RGBA
            // Cull Front : 文章cutter mesh第2个pass为cull back,  https://medium.com/tech-at-wildlife-studios/zooba-graphics-bush-rendering-ce66c9d528f2
			Cull Back
            Stencil
            {
                Ref 128
                ReadMask 255
                WriteMask 127
                Comp Less
                Pass DecrSat
                ZFail DecrSat
            }

            CGPROGRAM

                    // Physically based Standard lighting model, and enable shadows on all light types
//            #pragma Standard fullforwardshadows

            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma vertex vert
            #pragma fragment surf
            #pragma target 3.0

            sampler2D _MainTex;
            #include "./Pass/BaseCG.cginc"
            ENDCG
        }

         Pass //3
        {
            ZTest LEqual
            ZWrite Off
            ColorMask 0
            Cull Front

            Stencil
            {
                Ref 128
                ReadMask 255
                WriteMask 127
                Comp LEqual
                Pass IncrSat
                ZFail Keep
            }

            CGPROGRAM


            #pragma vertex vert
            #pragma fragment surf
            #pragma target 3.0

            sampler2D _MainTex;
            #include "./Pass/BaseCG.cginc"
            ENDCG
        }
        Pass //4
        {
            ZTest Greater
            ZWrite On
            ColorMask RGBA
            Cull Back

            Stencil
            {
                Ref 128
                ReadMask 255
                WriteMask 127
                Comp Less
                Pass DecrSat
                ZFail Keep
            }

            CGPROGRAM


            #pragma vertex vert
            #pragma fragment surf
            #pragma target 3.0

            sampler2D _MainTex;
            #include "./Pass/BaseCG.cginc"
            ENDCG
        }

    }
    FallBack "Diffuse"
}
