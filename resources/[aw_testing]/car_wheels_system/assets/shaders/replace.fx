float width = -0.001;
float size = 0;

texture gTexture;


float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float4x4 gWorld : WORLD;
float4x4 gView  : VIEW;
float4x4 gProjection  : PROJECTION;
float gTime : TIME;

float4 MTACalcScreenPosition(float3 InPosition)
{
    float4 posWorld = mul(float4(InPosition, 1), gWorld);
    float4 posWorldView = mul(posWorld, gView);
    return mul(posWorldView, gProjection);
}

sampler Sampler1 = sampler_state
{
    Texture = (gTexture);
};

struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
    float3 Binormal : TEXCOORD2;
    float3 Normal : TEXCOORD3;
};

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    PS.Position = mul(float4(VS.Position, 3), gWorldViewProjection);
    VS.Position -= VS.Normal * float3(width, size, size);
    PS.Position = MTACalcScreenPosition(VS.Position);
    PS.TexCoord = VS.TexCoord;
    PS.Normal = normalize(mul(VS.Normal, (float3x3)gWorld));
    PS.Normal = VS.Normal;

    return PS;
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 maptex = tex2D(Sampler1,PS.TexCoord.xy);
    maptex.rgb *= 0.5;
    return maptex;
}

technique tec0
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}