// http://www.cnblogs.com/Esfog/p/DissolveShader.html
Shader "Dissolve/Dissolve" {    
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_NoiseTex("NoiseTex (R)",2D) = "white"{}
		_DissolveSpeed("DissolveSpeed (Second)",Float) = 1
		_EdgeWidth("EdgeWidth",Range(0,0.5)) = 0.1
		_EdgeColor("EdgeColor",Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }

		Pass
		{
		CGPROGRAM
		#pragma vertex vert_img // unity提供的vert_img顶点着色器
		#pragma fragment frag
		#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
		uniform sampler2D _NoiseTex;
		uniform float _DissolveSpeed;
		uniform float _EdgeWidth;
		uniform float4 _EdgeColor;

		float4 frag(v2f_img i) :COLOR
		{
			float DissolveFactor = saturate(_Time.y / _DissolveSpeed);
			float noiseValue = tex2D(_NoiseTex, i.uv).r;
			if (noiseValue <= DissolveFactor)
			{
				discard;
			}

			float4 texColor = tex2D(_MainTex, i.uv);

			// noiseValue - DissolveFactor，这个值表示溶解贴图上的R通道值和目前的溶解基准值相差多少
			// 而(_EdgeWidth*DissolveFactor)可以这样理解,_EdgeWidth表示可以多大的差值可以算作是边缘,
			// 最后这两个值相除就代表当前片元的边缘程度,值越大表示离他被溶解掉的时间越长,
			// 反之表示他很快就要被溶解掉了.而乘以一个DissolveFactor，就表示边缘最大宽度会随着时间变化时间越长,宽度越宽
			float EdgeFactor = saturate((noiseValue - DissolveFactor) / (_EdgeWidth * DissolveFactor));

			return lerp(texColor, _EdgeColor, 1 - EdgeFactor);
		}
		ENDCG
	}
}
	FallBack Off
}
