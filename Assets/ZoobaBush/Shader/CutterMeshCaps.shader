﻿Shader "Custom/CutterMeshCaps"
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

            #pragma vertex vert
             #pragma fragment surf 

            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma target 3.0

            sampler2D _MainTex;
            struct Input
            {
                float2 uv_MainTex;
            };

         
    half _Glossiness;
    half _Metallic;
    fixed4 _Color;
    float4 _MainTex_ST;
    float4 _MovementDir;
    float4 _MainPlayerPos;


              struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 vertexColor : COLOR;
                };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 uv0 : TEXCOORD0;
                float4 uv1 : TEXCOORD1;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
            VertexOutput o = (VertexOutput)0;
            //float2 uv = TRANSFORM_TEX(v.texcoord0,_MainTex);
            float2 uv = v.texcoord0 * _MainTex_ST.xy + _MainTex_ST.zw;
            o.uv0.x = uv.x - _MovementDir.w;
            o.uv0.yw = uv.yy;
            o.uv0.z = uv.x + _MovementDir.w ;

            float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
            float2 toPlayer = normalize(worldPos.xz - _MainPlayerPos.xz);
            float2 right = _MovementDir.zx * float2(1,-1);
            float cos = -dot(right,toPlayer);
            
           
            o.uv1 = v.texcoord1;
            o.uv1.x = cos;
            o.vertexColor = v.vertexColor;
            o.pos = UnityObjectToClipPos( v.vertex );
            return o;
        }

           fixed4 surf (VertexOutput IN) : SV_Target
            {
                // Albedo comes from a texture tinted by color
                //fixed4 c = tex2D (_MainTex, IN.uv0) * _Color;
                float a = (IN.uv1.x + 1) * 0.5;
                a = clamp(a,0,1);
                
                float4 c1 = tex2D(_MainTex,IN.uv0.zw)  ;  
                float4 c2 = tex2D(_MainTex,IN.uv0.xy)  ;
                float4 c = a*(c1 -c2) + c2;
                return c;  

            }
            ENDCG
        }


    }
    FallBack "Diffuse"
}
