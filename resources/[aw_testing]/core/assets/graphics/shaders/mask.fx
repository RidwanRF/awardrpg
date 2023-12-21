texture gTexture;
texture gMaskTexture;

float gAlpha = 1;

float gMode = 0;
// 0 - убирает прозрачную область
// 1 - убирает непрозрачную область

sampler2D Sampler0 = sampler_state
{
    Texture         = (gTexture);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
    AddressU        = Mirror;
    AddressV        = Mirror;
};

sampler2D Sampler1 = sampler_state
{
    Texture         = (gMaskTexture);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
    AddressU        = Mirror;
    AddressV        = Mirror;
};

float4 MaskTextureMain( float2 uv : TEXCOORD0 ) : COLOR0
{

    float4 color = tex2D( Sampler0, uv );
    float4 mask = tex2D( Sampler1, uv );

    if ( gMode == 0 ) {
        color.a *= mask.a;
    } else {
        color.a *= (1-mask.a);
    }

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