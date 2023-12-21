texture gTexture;

float gAlpha = 1;

sampler2D Sampler0 = sampler_state
{
    Texture         = (gTexture);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
    AddressU        = Mirror;
    AddressV        = Mirror;
};


float4 MaskTextureMain( float2 uv : TEXCOORD0 ) : COLOR0
{

    float4 color = tex2D( Sampler0, uv );

    float gray = (color.r + color.g + color.b) / 3;
    color.rgb = float3(gray, gray, gray);

    color.a *= gAlpha;

    return color;

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