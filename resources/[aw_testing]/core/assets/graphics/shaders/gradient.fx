texture gTexture;

float gGradientAngle = 0;
float4 gStartColor = float4(1,1,1,1);
float4 gEndColor = float4(1,1,1,1);
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

float findRotation( float x1, float y1, float x2, float y2 )
{
    float2 t = -degrees( atan2( x2 - x1, y2 - y1 ) );
    return t < 0 ? t + 360 : t;
}

float2 getPointFromDistanceRotation( float x, float y, float dist, float angle )
{

    float a = radians( 90 - angle );

    float dx = cos(a) * dist;
    float dy = sin(a) * dist;

    return float2( x+dx, y+dy );

}

float getDistanceBetweenPoints2D( float x1, float y1, float x2, float y2 )
{

    float dx = abs( x2 - x1 );
    float dy = abs( y2 - y1 );

    return sqrt( dx*dx + dy*dy );

}

float4 MaskTextureMain( float2 uv : TEXCOORD0 ) : COLOR0
{

    float4 color = tex2D( Sampler0, uv );

    float r = findRotation( 0.5, 0.5, uv.x, uv.y );
    float dist = getDistanceBetweenPoints2D( 0.5, 0.5, uv.x, uv.y );

    float2 transformedCoord = getPointFromDistanceRotation( 0.5, 0.5, dist, r + gGradientAngle );
    float progress = transformedCoord.x;

    color *= float4(
        gStartColor.r + ( gEndColor.r - gStartColor.r ) * progress,
        gStartColor.g + ( gEndColor.g - gStartColor.g ) * progress,
        gStartColor.b + ( gEndColor.b - gStartColor.b ) * progress,
        gStartColor.a + ( gEndColor.a - gStartColor.a ) * progress
    );

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