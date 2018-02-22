Shader "Hidden/Glitch_Analog" 
{
	Properties 
	{
		_MainTex("-", 2D) = ""{}
	}

	CGINCLUDE
	#include "UnityCG.cginc"
	sampler2D _MainTex
	float2 _MainTex_TexelSize;
	float2 _ScanLineJitter1; //displacement and the threshold aka min and max
	float2 _VerticalJump; //amount, timing
	float _HorizontalShake;
	float2 _ColourDrift; //amount, timing

	float nrand(float x, float y)
	{
		return frac(sin(dot(float2(x, y), float2(12.9898, 78.233)))*43758.5453);
	}

	half4 frag(v2f_img i) : SV_Target
	{
		float u = i.uv.x;
		float v = i.uv.y;
		//scan line jitter
		float jitter = nrand(v, _Time.x) * 2 - 1;
		jitter *= step(_ScanLineJitter.y, abs(jitter)) * _ScanLineJitter.x;
		//Vertical Jump
		float jump = lerp(v, frac(v + _VerticalJump.y), _VerticalJump.x);
		//Horizontal Shake
		float shake = (nrand(_Time.x, 2) - 0.5) * _HorizontalShake;
		//Colour Drift
		float drift = sin(jump + _ColourDrift.y) * _ColourDrift.x;
		half4 src1 = tex2D(_MainTex, frac(float2(u + jitter + shake, jump)));
		half4 src2 = tex2D(_MainTex, frac(float2(u + jitter + shake + drift, jump)));
		return half4(src1.r, src2.g, src1.b, 1);
	}
		ENDCG

		SubShader
	{
		Pass
		{
			ZTest Always Cull Off ZWrite Off
			CGPROGRAM
			#prama vertex vert_img
			#prama fragment frag
			#prama target 3.0
			ENDCG
		}
	
	}
}
