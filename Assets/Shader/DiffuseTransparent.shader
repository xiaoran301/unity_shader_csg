// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

// Simplified Diffuse shader. Differences from regular Diffuse one:
// - no Main Color
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "WhiteBird/Mobile/DiffuseTransparent" {
Properties {
   _Color ("Main Color", Color) = (1.000000,1.000000,1.000000,1.000000)
   _MainTex ("Base (RGB) Trans (A)", 2D) = "white" { }
   _Cutoff ("Alpha cutoff", Range(0.000000,1.000000)) = 0.500000
   _Alpha ("Alpha ", Range(0,1)) = 0.2
   _TexScale("TexScale  ", Range(0,1)) = 0.2
}
SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
    LOD 200
    ColorMask 0

CGPROGRAM
#pragma surface surf Lambert  alpha:fade

sampler2D _MainTex;
float _Alpha;
fixed4 _Color;
float _Cutoff;
float _TexScale;

struct Input {
    float2 uv_MainTex;
};

void surf (Input IN, inout SurfaceOutput o) {
    fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
    o.Albedo = _Color.rgb+c.rgb*_TexScale;
    clip(c.a-_Cutoff);
    o.Alpha =c.a*_Alpha;
}
ENDCG
}

Fallback "Mobile/VertexLit"
}
