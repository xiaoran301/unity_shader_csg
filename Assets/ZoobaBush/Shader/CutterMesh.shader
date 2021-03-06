Shader "Custom/CutterMesh"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Pass // 1
        {
            ZTest LEqual
            ZWrite Off
            ColorMask 0
            Cull Back

            Stencil
            {
                Ref 1
                ReadMask 255
                WriteMask 1
                Comp Always
                Pass Invert
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
            ZTest LEqual
            ZWrite Off
            ColorMask 0
            Cull Front

            Stencil
            {
                Ref 1
                ReadMask 255
                WriteMask 1
                Comp Always
                Pass Invert
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
            ZTest Greater
            ZWrite On
            ColorMask RGBA
            Cull Front

            Stencil
            {
                Ref 1
                ReadMask 1
                WriteMask 1
                Comp Equal
                Pass Zero
            }

            CGPROGRAM

                    // Physically based Standard lighting model, and enable shadows on all light types
//            #pragma  Standard fullforwardshadows

            // Use shader model 3.0 target, to get nicer looking lighting
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
