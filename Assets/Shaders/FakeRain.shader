//https://www.youtube.com/watch?v=NLFlsKw9SZU

Shader "TestFakeRainShader"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Diffuse Texture (RGB), Alpha (A)", 2D) = "white"{}
		_NormalTex ("Normal Texture (RGB), Specular Texture (A)", 2D) = "white"{}
		_LightPower ("Light Power", Float) = 1

		_SpecularPower ("Specular Power", range(0,10)) = 1
		_SpecularColor ("Specular Color", Color) = (1,1,1,1)

		_RainTexture ("RainDrops (R), RainSide (G), Noise (B)", 2D) = "white"{}
		_UpDirection ("Up direction", Vector) = (0,1,0)
		_transition ("Transition", range (0,1)) = 0.5
		_RainDropsAmount ("Rain drops amount", range (0,1)) = 0.5
		_RainDropsPower ("Rain drops Power", range (1,10)) = 5
	}

	SubShader
	{
		Tags {"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM
		#pragma surface RainSurface HalfLambert
		#pragma 3.0

		half4 _Color;
		sampler2D _MainTex;
		sampler2D _NormalTex;
		half _LightPower;

		half _SpecularPower;
		half4 _SpecularColor;
		
		struct Input
		{
			float2 uv_MainTex;
		};
	
		half halfDot(half3 a, half3 b)
		{
			return dot(normalize(a), normalize(b)) * 0.5f + 0.5f;
		}

		struct NewSurfaceOutput
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Specular;
			half Alpha;
			half3 SpecularColor;
		};

		half4 LightingHalfLambert(NewSurfaceOutput o, half3 lightDir, half3 viewDir, half atten)
		{
			half shadingValue = halfDot(o.Normal, lightDir);
			half3 diffuseValue = shadingValue * o.Albedo * _LightColor0;

			half specularValue = pow(halfDot(o.Normal, lightDir + viewDir), _SpecularPower);
			half3 specularLighting = specularValue * o.SpecularColor * _LightColor0;

			half3 returnColor = (diffuseValue + specularLighting) * atten * _LightPower;

			return half4(returnColor, o.Alpha);
		}

		void RainSurface(Input IN, inout NewSurfaceOutput o)
		{
			half4 diffuseValue = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = diffuseValue.rgb * _Color;
			o.Alpha = diffuseValue.a;

			half3 normalValue = UnpackNormal(tex2D(_NormalTex, IN.uv_MainTex));
			o.Normal = normalValue.rgb;

			half specularValue = tex2D(_NormalTex, IN.uv_MainTex).a;
			o.SpecularColor = specularValue * _SpecularColor;
		}
		ENDCG
	}
	FallBack "Diffuse"
}