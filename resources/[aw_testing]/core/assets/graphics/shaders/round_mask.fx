
float minAngle = 30;
float direction = 1;
float maxAngle = 210;

float4 color = float4(1,1,1,1);
float alpha = 1;

static const float PI = 3.1415926535;

texture gTexture;
sampler MaskSampler = sampler_state
{
    Texture = <gTexture>;
};

float4 MaskTextureMain( float2 uv : TEXCOORD0 ) : COLOR0
{
	float2 pixelVector = normalize(uv - float2(0.5, 0.5));
	if (length(pixelVector) < 0.001)
		return 0;
	
	float angle = 0;
	if (pixelVector.x * direction < 0)
		angle = PI - acos(-pixelVector.y);
	else
		angle = PI + acos(-pixelVector.y);
	
	angle = angle * 180 / PI;
	if (angle < minAngle || angle > maxAngle)
		return 0;
	
	// return float4(1,1,1,1);
	float4 result = tex2D(MaskSampler, uv);
	result *= color;
	result.a *= alpha;
	return result;
}

technique Technique1
{
    pass Pass1
    {
        AlphaBlendEnable = true;
        SrcBlend = SrcAlpha;
        DestBlend = InvSrcAlpha;
        PixelShader = compile ps_2_0 MaskTextureMain();
    }
}