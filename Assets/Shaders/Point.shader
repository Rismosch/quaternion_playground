Shader "Unlit/Point"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Position("Position", Vector) = (0, 0, 0, 0)
        _Color("Color", Color) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha
        cull Off
        ZTest Always

        Pass
        {
            CGPROGRAM
            
            float4 _Position;
            float4 _Color;

            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 coord = (i.uv - 0.5) * 2;

                float2 position = coord - _Position * 0.9;
                float distance = length(position);
                float clamped = 1 - distance * 20;
                float alpha = lerp(0, clamped, distance < 0.1) * 4;
                alpha = clamp(alpha, 0, 1);

                return fixed4(_Color.rgb, alpha);
            }
            ENDCG
        }
    }
}
