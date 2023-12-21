texture screenSource;
float2 screenSize = float2(0, 0);
float blurStrength = 4;
float saturation = 1.0;
float contrast = 1.0;
float brightness = 1.0;


sampler TextureSampler = sampler_state {
    Texture = <screenSource>;
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};


static const float2 blurring[12] = 
{
        float2(-0.326212f, -0.40581f),
        float2(-0.840144f, -0.07358f),
        float2(-0.695914f, 0.457137f),
        float2(-0.203345f, 0.620716f),
        float2(0.96234f, -0.194983f),
        float2(0.473434f, -0.480026f),
        float2(0.519456f, 0.767022f),
        float2(0.185461f, -0.893124f),
        float2(0.507431f, 0.064425f),
        float2(0.89642f, 0.412458f),
        float2(-0.32194f, -0.932615f),
        float2(-0.65432f, -0.87421f),
};


float4 PixelShaderFunction(float2 texCoords : TEXCOORD0) : COLOR0 {	
	
	float4 blurColor = tex2D(TextureSampler, texCoords);
	
	for(int i = 0; i < 12; i++)
    {
        float2 newCoords = texCoords.xy + (blurring[i] / screenSize * blurStrength);
        blurColor += tex2D(TextureSampler, newCoords);
		newCoords = texCoords.xy - (blurring[i] / screenSize * blurStrength);
		blurColor += tex2D(TextureSampler, newCoords);
    }
	
	blurColor /= 24;

	float3 luminanceWeights = float3(0.299, 0.587, 0.114);
	float luminance = dot(blurColor, luminanceWeights);
	float4 finalColor = lerp(luminance, blurColor, saturation);
	finalColor.rgb *= 1.5;
	
	finalColor.a = blurColor.a;
	finalColor.rgb = ((finalColor.rgb - 0.5f) * max(contrast, 0)) + 0.5f;
	finalColor.rgb *= brightness;
	
	return finalColor;
}
 
 
technique Blur
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}