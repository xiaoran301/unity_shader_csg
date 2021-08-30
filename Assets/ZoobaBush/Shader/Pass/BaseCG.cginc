#ifndef __BASE_CG_CGINC__
#define __BASE_CG_CGINC__
#include "UnityCG.cginc"
// #include "HLSLSupport.cginc"
// #include "../Unity/UnityDefine.cginc"
// #include "../Define/CommonInputVariables.cginc"
// #include "../BRDF/BRDF.cginc"
// #include "../Lighting/FuzzLighting.cginc"
// #include "../Lighting/DiffuseLighting.cginc"
// #include "../Lighting/SpecularLighting.cginc"
// #include "../Lighting/IBLLighting.cginc"
// #include "../Lighting/SSSLighting.cginc"
// #include "../Lighting/TransmittanceLighting.cginc"
// #include "../Lighting/HairLighting.cginc"
// #include "../Lighting/ClothLighting.cginc"
// #include "../Lighting/AnisotropicLighting.cginc"
// #include "../Lighting/RimLighting.cginc"
// #include "../Lighting/EyeLighting.cginc"
// #include "../Lighting/SkinSpecLighting.cginc"
// #include "../Lighting/NewtonsRingsLighting.cginc"
// #include "CollectRealTimeLighting.cginc"


// :2 failed to open source file: 'HLSLSupport.cginc'
// :6 failed to open source file: 'UnityShaderVariables.cginc'
// :7 failed to open source file: 'UnityShaderUtilities.cginc'
// :8 failed to open source file: 'Lighting.cginc'
// :9 failed to open source file: 'UnityPBSLighting.cginc'
// :10 failed to open source file: 'UnityCG.cginc'
// :11 failed to open source file: 'Lighting.cginc'
// :12 failed to open source file: 'UnityPBSLighting.cginc'




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
    return c*_Color;  

    //return float4(1.0,1.0,1.0,1.0);
}

#endif