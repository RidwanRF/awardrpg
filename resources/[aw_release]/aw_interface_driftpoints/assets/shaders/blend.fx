texture sourceTexture;
texture blendTexture;

float gAlpha = 1;
float blendAlpha = 1;

float gTime : TIME;

sampler2D Sampler0 = sampler_state
{
    Texture         = (sourceTexture);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
    AddressU        = Mirror;
    AddressV        = Mirror;
};
sampler2D Sampler1 = sampler_state
{
    Texture         = (blendTexture);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
    AddressU        = Mirror;
    AddressV        = Mirror;
};

float4 MaskTextureMain( float2 uv : TEXCOORD0 ) : COLOR0
{

    float4 color1 = tex2D( Sampler0, uv );
    float4 color2 = tex2D( Sampler1, uv );

    float4 finalColor = color1;

    if ( color1.a > 0.1 && color2.a > 0 ){
        finalColor = 1;
        finalColor.rgb *= blendAlpha;
    }

    finalColor.a *= gAlpha;

    return finalColor;

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