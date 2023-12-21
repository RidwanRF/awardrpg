wheelStandart = [[ //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++      _________           __         __________       __               __    __  __      _________       +++++//
//+++++     |XX|X X XX|          XX        |HH|HHH\HHH\     |XX              |XX|  |XX||XX|    |XX|X X XX|      +++++//
//+++++     |XX|    |XX|        /XX\       |HH|      \HH\   |XX||XX|     |XX||XX|    |XX|      |XX|    |XX|     +++++//
//+++++     |XX|    |XX|       /XXXX\      |HH|       |HH|  |XX| |XX|   |XX| |XX|    |XX|      |XX|    |XX|     +++++//
//+++++     |XX|   |XX|       /XX/\XX\     |HH|       |HH|  |XX|  |XX| |XX|  |XX|    |XX|      |XX|   |XX|      +++++//
//+++++     |XX|X X X|       /XX/  \XX\    |HH|       |HH|  |XX|     |XX|    |XX|    |XX|      |XX|X X X|       +++++//
//+++++     |XX|   \XX\     /XXXXXXXXXX\   |HH|       |HH|  |XX|             |XX|    |XX|      |XX|   \XX\      +++++//
//+++++     |XX|    \XX\   /XX/      \XX\  |HH|      /HH/   |XX|             |XX|    |XX|      |XX|    \XX\     +++++//
//+++++     |XX|    |XX|  /XX/        \XX\ |HH|    /HHH/    |XX|             |XX|    |XX|      |XX|     |XX|    +++++//
//+++++     |XX|    |XX| /XX/          \XX\|HHHHHHHHH/      |XX|             |XX|  |XX||XX|    |XX|     |XX|    +++++// 
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

//---------------------------------------------------------------------
// ...
//---------------------------------------------------------------------
//int gGameTimeHours : GAME_TIME_HOURS;
//int gGameTimeMinutes : GAME_TIME_MINUTES;
//int gWeather : WEATHER;
//int gStage1ColorOp < string stageState="1,COLOROP"; >;

float2 sEffectFade = float2(50, 40);
//---------------------------------------------------------------------
// Textures
//---------------------------------------------------------------------
texture gScreenSource : SCREEN_SOURCE;
texture gDepthBuffer : DEPTHBUFFER;

float4 Color = float4(0.8, 0.8, 0.8, 0.8);

texture sReflDay;
texture sReflNight;
texture sSnow;
texture sSnowA;
texture sShine;
texture sReflDayV;
//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
#include "radmir.fx"
//---------------------------------------------------------------------
// Sampler
//---------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
};

sampler SamplerDepth = sampler_state
{
    Texture = (gDepthBuffer);
    AddressU = Clamp;
    AddressV = Clamp;
};

samplerCUBE VReflDaySampler = sampler_state
{
	Texture = (sReflDay);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE; //FALSE		
    MaxMipLevel=0;
    MipMapLodBias=0;
};

samplerCUBE ReflDaySampler = sampler_state
{
	Texture = (sReflDay);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE;		
    MaxMipLevel=0;
    MipMapLodBias=0;
};

samplerCUBE ReflNightSampler = sampler_state
{
	Texture = (sReflNight);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE;//FALSE
    MaxMipLevel=0;
    MipMapLodBias=0;
};

sampler2D SamplerSnow = sampler_state
{
   Texture   = <sSnow>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerSnowA = sampler_state
{
   Texture   = <sSnowA>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerShine = sampler_state
{
   Texture   = <sShine>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler SamplerColor = sampler_state
{
    Texture = (gScreenSource);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU  = Clamp;
	AddressV  = Clamp;
	SRGBTexture=FALSE;	
};

//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
	float3 Normal : NORMAL0;
	
    float4 Color : COLOR0;	
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
	float4 Position2 : POSITION1;	
    float2 TexCoord : TEXCOORD0;
    float4 Color : COLOR0;
	float4 AmbC : TEXCOORD1;
    float4 invTex : TEXCOORD2;
    float3 Material : TEXCOORD3;	
    float3 Normal : TEXCOORD4;
    float4 View : TEXCOORD5;
    float4 Light : TEXCOORD6;	
    float4 Diffuse : TEXCOORD7;		
};


////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

   // FixUpNormal( VS.Normal );
	
    // Set information to do specular calculation
    float3 Normal = mul(VS.Normal, (float3x3)gWorld);
    PS.Normal = Normal;
    Normal = normalize(Normal);	

    float4 worldPos = mul( float4(VS.Position.xyz,1) , gWorld );

	PS.Position = mul(float4(VS.Position.xyz , 1.0), gWorldViewProjection);
	PS.Position2 = PS.Position;
	
    PS.AmbC = gMaterialAmbient;
    PS.Material = AlphaMaterial();
    PS.View.xyz = gCameraPosition - worldPos.xyz;
	
    //PS.Color = CalcGTACompleteDiffuse(Normal, VS.Color);
    PS.Diffuse = gMaterialDiffuse;	
    PS.Diffuse *= Color;
	PS.Light = CalcGTADynamicDiffuse(Normal); //1
	PS.TexCoord.xy = VS.TexCoord.xy;

    float refMask = pow(2 * dot(Normal, normalize(PS.View.xyz)), 3);
    PS.View.w = saturate(1 - refMask) * pow(dot(Normal, float3(0,0,1)), 1);

    float4x4 gWVPI =  inverse(gWorldViewProjection);
	float4 objspacepos	= mul(PS.Position2, gWVPI);
	       objspacepos.xyz/=objspacepos.w;
		   
    PS.invTex = objspacepos;
/**/	
    // Distance fade calculation
    float DistanceFromCamera = distance(gCameraPosition, worldPos.xyz);
    PS.View.w *= saturate(1 - ((DistanceFromCamera - sEffectFade.y) / (sEffectFade.x - sEffectFade.y)));
	
    return PS;
}

float3 GetCorrection(float3 color)
{
	float3 n0 = normalize(color.xyz);
	float3 ct0=color.xyz/n0.xyz;
	       ct0=pow(ct0, 1.0);
           n0.xyz = pow(n0.xyz, 1.1);   
           color.xyz = ct0*n0.xyz;  
           color.xyz*= 1.0;
	 
	float mC = max(color.x, max(color.y, color.z));		 		 
	float3 x1 = 1.0 - exp(-mC);	
	float3 rg =  float3(x1.x, x1.y, x1.z);
	float3 x2 = 1.0 - exp(-color);	
	float3 rg2 =  float3(x2.x, x2.y, x2.z);	
		 
	float mm = rg;
	float3 c1 = color * mm / mC;
	float3 p2 = rg2;
	color.xyz = lerp(p2, c1, 0.2);		 

	return color;	
}

float3 Uncharted2Tonemap(float3 x)
{
    float A = 1.0;
	float B = 0.25;
	float C = 0.52;
	float D = 0.34;
	float E = 0.0;
	float F = 1.0;

    return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
}

/*
*/

float2 wpd2(float3 cd)
{
   float4 tv = float4(cd.xyz, 1.0);
   float4 wp = mul(tv, gViewInverseTranspose);
		  //wp.xyz/= wp.w;   
		  
		  wp.x = -wp.x;  		  
		  wp.xy = wp.xy*0.0+0.0;
   return wp.xy;
}

////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

float4 PS_Reflection(PSInput PS) : COLOR0
{
    float3 vView = normalize(PS.View.xyz);	

	float wx = gWeather;
	
    float  wpos2 = length(vView.xyz);
    float3 camdir = vView.xyz / wpos2;	
    float3 npos = normalize(PS.Normal);
	
  float hourMinutes = (1 / 59) * 15;
  float GameTime = 15 + hourMinutes;

   float t0 = GameTime;
   float x1 = smoothstep(0.0, 4.0, t0);
   float x2 = smoothstep(4.0, 5.0, t0);
   float x3 = smoothstep(5.0, 6.0, t0);
   float x4 = smoothstep(6.0, 7.0, t0);
   float xE = smoothstep(8.0, 11.0, t0);
   float x5 = smoothstep(16.0, 17.0, t0);
   float x6 = smoothstep(18.0, 19.0, t0);
   float x7 = smoothstep(19.0, 20.0, t0);
   float xG = smoothstep(20.0, 21.0, t0);  
   float xZ = smoothstep(21.0, 22.0, t0);
   float x8 = smoothstep(22.0, 24.0, t0);	
   
 //SunDirection--------------------
float3  f = lerp(float3(0.,0.,-.61), float3(.583,-.257,-.0108), smoothstep(0.,5.,GameTime));
        f = lerp(f, float3(.569,-.242,.151), smoothstep(5.,7.,GameTime));
		f = lerp(f, float3(.49,-.247,.323), smoothstep(7.,9.,GameTime));
		f = lerp(f, float3(.373,-.262,.445), smoothstep(9.,11.,GameTime));
		f = lerp(f, float3(.201,-.312,.517), smoothstep(11.,13.,GameTime));
		f = lerp(f, float3(-.00732,-.39,.503), smoothstep(13.,15.,GameTime));
		f = lerp(f, float3(-.189,-.502,.343), smoothstep(15.,17.,GameTime));
		f = lerp(f, float3(-.223,-.594,.1), smoothstep(17.,19.,GameTime));
		f = lerp(f, float3(0.,0.,-.61), smoothstep(19.,24.,GameTime));
		f = normalize(f);  	
		
   float3 df0 = lerp(0.70*float3(0.90, 0.95, 1.02), 0.70*float3(0.90, 0.95, 1.02), x1);
          df0 = lerp(df0, 0.72*float3(0.90, 0.95, 1.02), x2);
          df0 = lerp(df0, 1.75*float3(1.15, 0.95, 0.75), x3);
          df0 = lerp(df0, 2.1*float3(1.10, 0.99, 0.90), x4);
          df0 = lerp(df0, 2.2*float3(1.02, 0.99, 0.95), xE);
          df0 = lerp(df0, 2.2*float3(1.02, 0.99, 0.95), x5);
          df0 = lerp(df0, 1.95*float3(1.20, 0.99, 0.70), x6);
          df0 = lerp(df0, 1.80*float3(1.10, 0.95, 0.80), x7);
          df0 = lerp(df0, 0.80*float3(0.95, 0.92, 0.90), xG);	
          df0 = lerp(df0, 0.75*float3(0.90, 0.95, 1.02), xZ);	  
          df0 = lerp(df0, 0.70*float3(0.90, 0.95, 1.02), x8); 
		  
   float3 df1 = 0.70;
   
    if (wx.x==2) df0 = df1; 
    if (wx.x==3) df0 = df1;   
    if (wx.x==4) df0 = df1;
    if (wx.x==7) df0 = df1;
    if (wx.x==8) df0 = df1;
    if (wx.x==9) df0 = df1;
    if (wx.x==12) df0 = df1;
    if (wx.x==15) df0 = df1;
    if (wx.x==16) df0 = df1;		

	
   float3 sh0 = lerp(0.70, 0.70, x1);
          sh0 = lerp(sh0, 0.70, x2);
          sh0 = lerp(sh0, 0.95, x3);
          sh0 = lerp(sh0, 0.95, x4);
          sh0 = lerp(sh0, 0.95, xE);
          sh0 = lerp(sh0, 0.95, x5);
          sh0 = lerp(sh0, 0.80, x6);
          sh0 = lerp(sh0, 0.80, x7);
          sh0 = lerp(sh0, 0.80, xG);	
          sh0 = lerp(sh0, 0.75, xZ);		  		  
          sh0 = lerp(sh0, 0.70, x8); 
		  
float3 shadowColor = float3(0.90, 0.93, 1.025);			  
    if (wx.x==4) shadowColor = 1.0;
    if (wx.x==7) shadowColor = 1.0;
    if (wx.x==8) shadowColor = 1.0;
    if (wx.x==9) shadowColor = 1.0;
    if (wx.x==12) shadowColor = 1.0;
    if (wx.x==15) shadowColor = 1.0;
    if (wx.x==16) shadowColor = 1.0;


    float3 Color0 = float3(1, 0.9, 0.75);
    float3 Color1 = float3(1.25, 1.25, 0.85);
    
     if (wx.x==2) Color0 = Color1;
     if (wx.x==3) Color0 = Color1;		 
     if (wx.x==4) Color0 = Color1;
     if (wx.x==7) Color0 = Color1;
     if (wx.x==8) Color0 = Color1;
     if (wx.x==9) Color0 = Color1;
     if (wx.x==12) Color0 = Color1;
     if (wx.x==15) Color0 = Color1;
     if (wx.x==16) Color0 = Color1;	
 
    float3 bl0 = lerp(0.0, 0.0, x1);
           bl0 = lerp(bl0, 0.0, x2);
           bl0 = lerp(bl0, 0.5*Color0, x3);
           bl0 = lerp(bl0, 1.5*Color0, x4);
           bl0 = lerp(bl0, 1.5*Color0, xE);
           bl0 = lerp(bl0, 0.75*Color0, x5);
           bl0 = lerp(bl0, 0.5*Color0, x6);
           bl0 = lerp(bl0, 0.3*Color0, x7);
           bl0 = lerp(bl0, 0.0, xG);		
           bl0 = lerp(bl0, 0.0, xZ);		  
           bl0 = lerp(bl0, 0.0, x8);

		  
		 
   float sp0 = lerp(0.0, 0.0, x1);
         sp0 = lerp(sp0, 0.0, x2);
         sp0 = lerp(sp0, 1.0, x3);
         sp0 = lerp(sp0, 1.0, x4);
         sp0 = lerp(sp0, 1.0, xE);
         sp0 = lerp(sp0, 1.0, x5);
         sp0 = lerp(sp0, 1.0, x6);
         sp0 = lerp(sp0, 1.0, x7);
         sp0 = lerp(sp0, 0.0, xG);	
         sp0 = lerp(sp0, 0.0, xZ);			 
         sp0 = lerp(sp0, 0.0, x8);	
		 
    if (wx.x==2) sp0 = 0.0;
    if (wx.x==3) sp0 = 0.0;		 
    if (wx.x==4) sp0 = 0.0;
    if (wx.x==7) sp0 = 0.0;
    if (wx.x==8) sp0 = 0.0;
    if (wx.x==9) sp0 = 0.0;
    if (wx.x==12) sp0 = 0.0;
    if (wx.x==15) sp0 = 0.0;
    if (wx.x==16) sp0 = 0.0;			 
		 
 		   
   float3 X2 = normalize(f+camdir);	
   float specular3 = pow(0.01-dot(npos.xyz, X2.xyz), 0.35);
         specular3 = pow(specular3, 50.0*1.8);
         specular3 = (specular3*specular3)*10.5;
         specular3/= 5.5*1.5; 	
		 
    float df2 = 0.01*0.001 + dot(npos.xyz, X2);	
		  df2 = pow(df2, 2500.0*2);
	float gl = (df2/0.01)* 0.01;
          gl = saturate(gl)*10.0;		   
		   
 	float4 ColorCar = Color;	
    float4 texel = tex2D(Sampler0, PS.TexCoord);
	       texel.rgb*= ColorCar*float3(0.97, 1.0, 1.05);
		   
    float texelA = saturate(texel.rgb);	
    float mix = lerp(0.7, 2.2, texelA);	
    float diff = saturate(0.1-dot(npos, -f)); 
		  diff = pow(diff, 0.7);

    float3 sv3 = normalize(float3(0.0, 0.0, 0.7)+vView.xyz); 	
	float fresnelz = (0.05-dot(-sv3, npos));		
		  fresnelz = pow(fresnelz, 5.0);
		  fresnelz = fresnelz*fresnelz;
          fresnelz/= 2.5;	
          fresnelz*= 0.7;		  		  		  
		  
	float3 lighting = lerp(sh0*shadowColor, df0, saturate(diff));			   
	
    float3 refl = reflect(vView, npos);	
	
    float4 CubeD = texCUBE(ReflDaySampler, -refl.xzy);
	       CubeD*= 2.0;	
    float4 CubeDV = texCUBE(VReflDaySampler, -refl.xzy);
	       CubeDV*= 2.1; //1
			   
	float3 CurrentRefl =  CubeDV.rgb;

	if (wx.x==0) CurrentRefl = CubeD.rgb;
	if (wx.x==1) CurrentRefl = CubeD.rgb;
	if (wx.x==2) CurrentRefl = CubeD.rgb;
	if (wx.x==3) CurrentRefl = CubeD.rgb;
	if (wx.x==4) CurrentRefl = CubeD.rgb;
	
	
    float4 CubeN = texCUBE(ReflNightSampler, -refl.xzy);
	       CubeN.rgb*= 2.2*float3(0.82, 0.95, 1.05);

	float3 cb = lerp(CubeN.xyz, CubeN.xyz, x1);
		   cb = lerp(cb, CubeN.xyz, x2);
		   cb = lerp(cb, CurrentRefl.xyz*0.92, x3);
		   cb = lerp(cb, CurrentRefl.xyz, x6);
		   cb = lerp(cb, CurrentRefl.xyz*0.85, x7);
		   cb = lerp(cb, CurrentRefl.xyz*0.8, xG);		   
		   cb = lerp(cb, CubeN.xyz, xZ);		   
		   cb = lerp(cb, CubeN.xyz, x8);
		   
	float3 n0 = normalize(cb.xyz);
	float3 ct0=cb.xyz/n0.xyz;
	       ct0=pow(ct0, 2.0);
           n0.xyz = pow(n0.xyz, 1.8);   
           cb.xyz = ct0*n0.xyz;  
           cb.xyz*= 1.25;			   
	
	float fresnel = 0.001*1.0-dot(npos, -camdir);		
		  fresnel = saturate(pow(fresnel, 0.37*0.15));		  
  		  
   float m0 = lerp(0.20, 0.20, x1);
         m0 = lerp(m0, 0.10, x2);
         m0 = lerp(m0, 0.0, x3);
         m0 = lerp(m0, 0.0, x4);
         m0 = lerp(m0, 0.0, x5);
         m0 = lerp(m0, 0.0, x6);
         m0 = lerp(m0, 0.0, x7);		 
         m0 = lerp(m0, 0.20, x8);
		
    float3 MoonVector = normalize(float3(-0.00732, -0.39, 0.317));
    float m1 = saturate(0.001 + dot(normalize(-MoonVector-camdir), -npos.xyz));	
		  m1 = pow(m1, 35.0);
    float3 moon = (m1*m1)*m0*2.0;		  
	   
    float mix2 = lerp(0.9, 5.0, texelA);		 
    float4 texel2 = tex2D(Sampler0, PS.TexCoord);	
	
	float4 Lighting1 = ColorCar*PS.Light*0.9;

  	float4 diffuse  = gDiffuseMaterialSource  == 0 ? ColorCar  : 1;

/*	
  float3 CL1 = float3(0.6, 0.8, 1.1)*1.1;
  float3 CL2 = float3(0.9, 0.95, 1.0); 
  float3 CL0 = lerp(CL1, CL1, x1);
         CL0 = lerp(CL0, float3(0.65, 0.83, 1.05), x2);
         CL0 = lerp(CL0, CL2, x3);
         CL0 = lerp(CL0, 1.0, x4);
         CL0 = lerp(CL0, 1.0, xE);
         CL0 = lerp(CL0, 1.0, x5);
         CL0 = lerp(CL0, float3(0.90, 0.95, 1.0), x6);
         CL0 = lerp(CL0, float3(0.66, 0.84, 1.04)*0.9, x7);
         CL0 = lerp(CL0, CL1, x8);
		 
  float3 CV0 = lerp(float3(0.75, 0.85, 1.0), float3(0.75, 0.85, 1.0), x1);
         CV0 = lerp(CV0, float3(0.75, 0.85, 1.0), x2);
         CV0 = lerp(CV0, 1.0, x3);
         CV0 = lerp(CV0, 1.0, x4);
         CV0 = lerp(CV0, 1.0, xE);
         CV0 = lerp(CV0, 1.0, x5);
         CV0 = lerp(CV0, 1.0, x6);
         CV0 = lerp(CV0, 1.0, x7);
         CV0 = lerp(CV0, float3(0.75, 0.85, 1.0), x8);		 
		 

float3 CurrentWeather = 1.0;

if (wx.x==0) CurrentWeather = CL0;
if (wx.x==1) CurrentWeather = CL0;
if (wx.x==2) CurrentWeather = CL0;
if (wx.x==3) CurrentWeather = CL0;
if (wx.x==4) CurrentWeather = CL0; 	

if (wx.x==7) CurrentWeather = CL0;
if (wx.x==8) CurrentWeather = CL0;
if (wx.x==9) CurrentWeather = CL0;

if (wx.x==12) CurrentWeather = CL0;
if (wx.x==15) CurrentWeather = CL0;
if (wx.x==16) CurrentWeather = CL0;	  

if (wx.x==5) CurrentWeather = CV0;
if (wx.x==6) CurrentWeather = CV0;
 
if (wx.x==10) CurrentWeather = CV0; 		 
if (wx.x==11) CurrentWeather = CV0; 
if (wx.x==13) CurrentWeather = CV0; 	
if (wx.x==14) CurrentWeather = CV0; 
if (wx.x==17) CurrentWeather = CV0; 
*/
    float Stg = ((texel.a <=0.9999) || PS.Material);

    float4 DiffAmb = PS.AmbC*2.0;
  if (Stg) DiffAmb = ColorCar*0.3;
	   
	float4 finalColor2 = float4((DiffAmb.rgb+Lighting1.rgb)*texel2.rgb*0.9, min(diffuse.a, texel2.a));	
	   
    float3 specmix2 = lerp(specular3*1.5, specular3*finalColor2*1.5, 0.80);	
		

   float factor3 = 0.1 - dot(-vView, npos);
         factor3 = pow(factor3, 0.65);
   float fr3 = (factor3*factor3); 
         fr3/= 2.5;	
         fr3 = saturate(fr3*2.6);	
         fr3 = lerp(1.0, fr3, 0.35);		

           finalColor2.rgb*= fr3;			
		
           finalColor2.rgb*= (lighting);				   
           finalColor2.rgb+= specmix2*bl0*0.7; 
           finalColor2.rgb+= moon*float3(0.85, 0.95, 1.1)*0.5;	
           finalColor2.rgb+= saturate(lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92)*0.7);				   


		   
    //finalColor2.rgb+= lerp(lerp(fresnelz*2.4, finalColor2.xyz*fresnelz*1.2, 0.92), 0.0, saturate(lighting2));			
    //finalColor2.rgb+= lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92);		
	
	float fresnelx = 0.001-dot(-vView, npos);		
		  fresnelx = saturate(pow(fresnelx, 0.37));
		  fresnelx = lerp(1.0, 0.0, 0.92*fresnelx);	

   float sp1 = lerp(0.2, 0.2, x1);
         sp1 = lerp(sp1, 0.2, x2);
         sp1 = lerp(sp1, 0.6, x3);
         sp1 = lerp(sp1, 0.8, x4);
         sp1 = lerp(sp1, 0.9, x5);
         sp1 = lerp(sp1, 0.6, x6);
         sp1 = lerp(sp1, 0.5, x7);
         sp1 = lerp(sp1, 0.2, xG);	
         sp1 = lerp(sp1, 0.2, xZ);			 
         sp1 = lerp(sp1, 0.2, x8);	
		  		   

		   
	
  float3 v = {0.6, 0.6, 0.95};
  float3 v2 = {0.9, 0.9, 1.0};  
  
  float3 n = normalize(npos.xyz*v);		 
  float3 ref0 = reflect(vView.xyz, n.xyz);		 
  //float3 n1 = ((1000.0/0.01)*n0)/1000.0;		
  float3 ref2 = (1.0*ref0)/0.5;	  
  
  float3 r0 = (vView.xyz+ref2)*0.95;	
  float2 r1 = wpd2(r0.xyz);		
	
	float2 rc = r1.xy;		
	
    float4 envMap = tex2D(SamplerColor, rc);
	       envMap.w = rc.y<0.0||rc.y>1.0 ? 0.0:1.0; 
	       envMap.w*= rc.x<0.0||rc.x>1.0 ? 0.0:1.0;

	float c08 = 6.7;
	float c07 = 1.0;

	float nf02 = saturate(c08*(r1.y));
          nf02*= saturate(c08*(r1.x));					
	      nf02 = pow(nf02, c07);			
	float nf03 = saturate(c08+r1.y*(-c08));
          nf03*= saturate(c08+r1.x*(-c08));					
	      nf03 = pow(nf03, c07);
	
	float fresnelR = 0.01-dot(npos, -camdir);		
		  fresnelR = saturate(pow(fresnelR, 4.0));	

		    cb = lerp(cb, envMap.xyz*3.3,  envMap.w*nf02*nf03*pow(0.01*0.5, fresnelR));	
    float3 reflection = lerp(1.12*cb+(gl*sp0*4.0), finalColor2.rgb, 0.97*fresnel);

    //float3 AtmSky = getSky(GameTime, wx, wpos, wpos2);	
		   
           finalColor2.rgb = lerp(finalColor2.rgb+fresnelx*0.27*sp1*float3(0.92, 0.96, 1.0), reflection, Stg); //
		   
    //finalColor2.rgb = GetCorrection(finalColor2.rgb*2.0);		   

		   
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////  Снег  ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
	float4 objspacepos	= PS.invTex;
	// Triplanar uvs
    float2 uvX = objspacepos.yz; // x facing plane
    float2 uvY = objspacepos.xz; // y facing plane	
    float2 uvZ = objspacepos.xy; // z facing plane   

	float3 wnorm = normalize(cross(ddx(objspacepos.xyz),ddy(objspacepos.xyz)));  

    float3 blending = pow(abs(wnorm.xyz), 3.0);
 	       blending = blending / (blending.x + blending.y + blending.z);	
		   
    float3 blending2 = pow(abs(npos.xyz*float3(22.0, 22.0, 10.0)), 2.2);
 	       blending2 = blending2 / (blending2.x + blending2.y + blending2.z);		
		   	   
		float3 R1x = tex2D(SamplerSnow, uvX);
		float3 R1y = tex2D(SamplerSnow, uvY);		
		float3 R1z = tex2D(SamplerSnow, uvZ);

		float3 Ax = tex2D(SamplerSnowA, uvX);
		float3 Ay = tex2D(SamplerSnowA, uvY);		
		float3 Az = tex2D(SamplerSnowA, uvZ);
		
		float3 Shx = tex2D(SamplerShine, uvX);
		float3 Shy = tex2D(SamplerShine, uvY);		
		float3 Shz = tex2D(SamplerShine, uvZ);	
		
	float ShineMix = Shx*blending.x + Shy*blending.y + Shz*blending.z; 		   

    float3 vw = normalize(float3(0,0,1));
    float sAl = saturate(0.01-dot(vw, -npos));
		  sAl = pow(sAl, 0.2);	//1		   

		  
	float3 SnowMix = R1x*blending.x + R1y*blending.y + R1z*blending.z; 	 		
	float SnowMixA = Ax*blending.x + Ay*blending.y + Az*blending.z; 

	float Glass = pow(ColorCar.a, 0.5);
	float3 Lighting2 = PS.Light*0.9; 
	
   float3 dfsn = lerp(0.45*float3(0.78, 0.90, 1.02), 0.45*float3(0.78, 0.90, 1.02), x1);
          dfsn = lerp(dfsn, 0.8*float3(0.90, 0.95, 1.02), x2);
          dfsn = lerp(dfsn, 1.05*float3(1.0, 0.99, 0.95), x3);
          dfsn = lerp(dfsn, 1.11*float3(1.0, 0.99, 0.95), x4);
          dfsn = lerp(dfsn, 1.15*float3(1.02, 0.99, 0.95), xE);
          dfsn = lerp(dfsn, 1.15*float3(1.02, 0.99, 0.95), x5);
          dfsn = lerp(dfsn, 1.12*float3(1.05, 0.90, 0.80), x6);
          dfsn = lerp(dfsn, 0.9*float3(0.93, 0.90, 0.95), x7);
          dfsn = lerp(dfsn, 0.6*float3(0.90, 0.95, 1.02), xG);	
          dfsn = lerp(dfsn, 0.5*float3(0.90, 0.95, 1.02), xZ);			  
          dfsn = lerp(dfsn, 0.45*float3(0.82, 0.90, 1.02), x8); 
		  
   float3 dfn = lerp(0.45*float3(0.92, 0.96, 1.03), 0.45*float3(0.92, 0.96, 1.03), x1);
          dfn = lerp(dfn, 0.52*float3(0.92, 0.96, 1.02), x2);
          dfn = lerp(dfn, 0.8*float3(0.95, 0.97, 1.00), x3);
          dfn = lerp(dfn, 0.85, x4);
          dfn = lerp(dfn, 0.85, xE);
          dfn = lerp(dfn, 0.85, x5);
          dfn = lerp(dfn, 0.85, x6);
          dfn = lerp(dfn, 0.7*float3(0.94, 0.96, 1.01), x7);
          dfn = lerp(dfn, 0.6*float3(0.92, 0.96, 1.02), xG);	
          dfn = lerp(dfn, 0.5*float3(0.90, 0.96, 1.02), xZ);			  
          dfn = lerp(dfn, 0.45*float3(0.90, 0.96, 1.02), x8); 		  
		  dfn*=float3(0.92, 0.96, 1.03);

    if (wx.x==2) dfsn = dfn;
    if (wx.x==3) dfsn = dfn;		  
    if (wx.x==4) dfsn = dfn;
    if (wx.x==7) dfsn = dfn;
    if (wx.x==8) dfsn = dfn;
    if (wx.x==9) dfsn = dfn;
    if (wx.x==12) dfsn = dfn;
    if (wx.x==15) dfsn = dfn;
    if (wx.x==16) dfsn = dfn;	
		  
 if (Stg) finalColor2.rgb+= lerp(0.0, 1.6*(moon*float3(0.85, 0.95, 1.1)*3.5) + specular3*bl0*4.5, ShineMix*saturate(blending2.z+SnowMixA*2.0*blending2.z)*Glass*sAl);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////  Снег  ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

	float3 TM0 = GetCorrection(finalColor2.rgb*0.9);
	float3 TM1 = Uncharted2Tonemap(finalColor2.rgb*0.9);	
	       finalColor2.rgb = lerp(TM0, TM1, 0.00);			   
	
           finalColor2.rgb = saturate(finalColor2.rgb);
           finalColor2.rgb = pow(finalColor2.rgb, 1.25);

           finalColor2.a*= ColorCar.a; //1
    return finalColor2;
}

////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

technique tec0
{
    pass P0
    {
        VertexShader = compile vs_3_0 VertexShaderFunction();	
        PixelShader = compile ps_3_0 PS_Reflection();
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
]]

glyanes1 = [[
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    //+++++      _________           __         __________       __               __    __  __      _________       +++++//
    //+++++     |XX|X X XX|          XX        |HH|HHH\HHH\     |XX              |XX|  |XX||XX|    |XX|X X XX|      +++++//
    //+++++     |XX|    |XX|        /XX\       |HH|      \HH\   |XX||XX|     |XX||XX|    |XX|      |XX|    |XX|     +++++//
    //+++++     |XX|    |XX|       /XXXX\      |HH|       |HH|  |XX| |XX|   |XX| |XX|    |XX|      |XX|    |XX|     +++++//
    //+++++     |XX|   |XX|       /XX/\XX\     |HH|       |HH|  |XX|  |XX| |XX|  |XX|    |XX|      |XX|   |XX|      +++++//
    //+++++     |XX|X X X|       /XX/  \XX\    |HH|       |HH|  |XX|     |XX|    |XX|    |XX|      |XX|X X X|       +++++//
    //+++++     |XX|   \XX\     /XXXXXXXXXX\   |HH|       |HH|  |XX|             |XX|    |XX|      |XX|   \XX\      +++++//
    //+++++     |XX|    \XX\   /XX/      \XX\  |HH|      /HH/   |XX|             |XX|    |XX|      |XX|    \XX\     +++++//
    //+++++     |XX|    |XX|  /XX/        \XX\ |HH|    /HHH/    |XX|             |XX|    |XX|      |XX|     |XX|    +++++//
    //+++++     |XX|    |XX| /XX/          \XX\|HHHHHHHHH/      |XX|             |XX|  |XX||XX|    |XX|     |XX|    +++++// 
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    
    //---------------------------------------------------------------------
    // ...
    //---------------------------------------------------------------------
    //int gGameTimeHours : GAME_TIME_HOURS;
    //int gGameTimeMinutes : GAME_TIME_MINUTES;
    //int gWeather : WEATHER;
    //int gStage1ColorOp < string stageState="1,COLOROP"; >;
    
    float2 sEffectFade = float2(50, 40);
    //---------------------------------------------------------------------
    // Textures
    //---------------------------------------------------------------------
    texture gScreenSource : SCREEN_SOURCE;
    texture gDepthBuffer : DEPTHBUFFER;
    
    texture sReflDay;
    texture sReflNight;
    texture sSnow;
    texture sSnowA;
    texture sShine;
    texture sReflDayV;
    //---------------------------------------------------------------------
    // Include some common stuff
    //---------------------------------------------------------------------
    #include "radmir.fx"
    //---------------------------------------------------------------------
    // Sampler
    //---------------------------------------------------------------------
    sampler Sampler0 = sampler_state
    {
        Texture = (gTexture0);
    };
    
    sampler SamplerDepth = sampler_state
    {
        Texture = (gDepthBuffer);
        AddressU = Clamp;
        AddressV = Clamp;
    };
    
    samplerCUBE VReflDaySampler = sampler_state
    {
        Texture = (sReflDay);
        MAGFILTER = LINEAR;
        MINFILTER = LINEAR;
        MIPFILTER = LINEAR;
        SRGBTexture=FALSE; //FALSE		
        MaxMipLevel=0;
        MipMapLodBias=0;
    };
    
    samplerCUBE ReflDaySampler = sampler_state
    {
        Texture = (sReflDay);
        MAGFILTER = LINEAR;
        MINFILTER = LINEAR;
        MIPFILTER = LINEAR;
        SRGBTexture=FALSE;		
        MaxMipLevel=0;
        MipMapLodBias=0;
    };
    
    samplerCUBE ReflNightSampler = sampler_state
    {
        Texture = (sReflNight);
        MAGFILTER = LINEAR;
        MINFILTER = LINEAR;
        MIPFILTER = LINEAR;
        SRGBTexture=FALSE;//FALSE
        MaxMipLevel=0;
        MipMapLodBias=0;
    };
    
    sampler2D SamplerSnow = sampler_state
    {
       Texture   = <sSnow>;
        MinFilter = Linear;
        MagFilter = Linear;
        MipFilter = Linear;
        AddressU = Wrap;
        AddressV = Wrap;
        AddressW = Wrap;
    };
    
    sampler2D SamplerSnowA = sampler_state
    {
       Texture   = <sSnowA>;
        MinFilter = Linear;
        MagFilter = Linear;
        MipFilter = Linear;
        AddressU = Wrap;
        AddressV = Wrap;
        AddressW = Wrap;
    };
    
    sampler2D SamplerShine = sampler_state
    {
       Texture   = <sShine>;
        MinFilter = Linear;
        MagFilter = Linear;
        MipFilter = Linear;
        AddressU = Wrap;
        AddressV = Wrap;
        AddressW = Wrap;
    };
    
    sampler SamplerColor = sampler_state
    {
        Texture = (gScreenSource);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;
        AddressU  = Clamp;
        AddressV  = Clamp;
        SRGBTexture=FALSE;	
    };
    
    //---------------------------------------------------------------------
    // Structure of data sent to the vertex shader
    //---------------------------------------------------------------------
    struct VSInput
    {
        float4 Position : POSITION0;
        float2 TexCoord : TEXCOORD0;
        float3 Normal : NORMAL0;
        
        float4 Color : COLOR0;	
    };
    
    //---------------------------------------------------------------------
    // Structure of data sent to the pixel shader ( from the vertex shader )
    //---------------------------------------------------------------------
    struct PSInput
    {
        float4 Position : POSITION0;
        float4 Position2 : POSITION1;	
        float2 TexCoord : TEXCOORD0;
        float4 Color : COLOR0;
        float4 AmbC : TEXCOORD1;
        float4 invTex : TEXCOORD2;
        float3 Material : TEXCOORD3;	
        float3 Normal : TEXCOORD4;
        float4 View : TEXCOORD5;
        float4 Light : TEXCOORD6;	
        float4 Diffuse : TEXCOORD7;		
    };
    
    
    ////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////RADMIR/////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////
    
    PSInput VertexShaderFunction(VSInput VS)
    {
        PSInput PS = (PSInput)0;
    
       // FixUpNormal( VS.Normal );
        
        // Set information to do specular calculation
        float3 Normal = mul(VS.Normal, (float3x3)gWorld);
        PS.Normal = Normal;
        Normal = normalize(Normal);	
    
        float4 worldPos = mul( float4(VS.Position.xyz,1) , gWorld );
    
        PS.Position = mul(float4(VS.Position.xyz , 1.0), gWorldViewProjection);
        PS.Position2 = PS.Position;
        
        PS.AmbC = gMaterialAmbient;
        PS.Material = AlphaMaterial();
        PS.View.xyz = gCameraPosition - worldPos.xyz;
        
        //PS.Color = CalcGTACompleteDiffuse(Normal, VS.Color);
        PS.Diffuse = gMaterialDiffuse;	
        PS.Light = CalcGTADynamicDiffuse(Normal); //1
        PS.TexCoord.xy = VS.TexCoord.xy;
    
        float refMask = pow(2 * dot(Normal, normalize(PS.View.xyz)), 3);
        PS.View.w = saturate(1 - refMask) * pow(dot(Normal, float3(0,0,1)), 1);
    
        float4x4 gWVPI =  inverse(gWorldViewProjection);
        float4 objspacepos	= mul(PS.Position2, gWVPI);
               objspacepos.xyz/=objspacepos.w;
               
        PS.invTex = objspacepos;
    /**/	
        // Distance fade calculation
        float DistanceFromCamera = distance(gCameraPosition, worldPos.xyz);
        PS.View.w *= saturate(1 - ((DistanceFromCamera - sEffectFade.y) / (sEffectFade.x - sEffectFade.y)));
        
        return PS;
    }
    
    float3 GetCorrection(float3 color)
    {
        float3 n0 = normalize(color.xyz);
        float3 ct0=color.xyz/n0.xyz;
               ct0=pow(ct0, 1.0);
               n0.xyz = pow(n0.xyz, 1.1);   
               color.xyz = ct0*n0.xyz;  
               color.xyz*= 1.0;
         
        float mC = max(color.x, max(color.y, color.z));		 		 
        float3 x1 = 1.0 - exp(-mC);	
        float3 rg =  float3(x1.x, x1.y, x1.z);
        float3 x2 = 1.0 - exp(-color);	
        float3 rg2 =  float3(x2.x, x2.y, x2.z);	
             
        float mm = rg;
        float3 c1 = color * mm / mC;
        float3 p2 = rg2;
        color.xyz = lerp(p2, c1, 0.2);		 
    
        return color;	
    }
    
    float3 Uncharted2Tonemap(float3 x)
    {
        float A = 1.0;
        float B = 0.25;
        float C = 0.52;
        float D = 0.34;
        float E = 0.0;
        float F = 1.0;
    
        return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
    }
    
    /*
    */
    
    float2 wpd2(float3 cd)
    {
       float4 tv = float4(cd.xyz, 1.0);
       float4 wp = mul(tv, gViewInverseTranspose);
              //wp.xyz/= wp.w;   
              
              wp.x = -wp.x;  		  
              wp.xy = wp.xy*0.0+0.0;
       return wp.xy;
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////RADMIR/////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////
    
    float4 PS_Reflection(PSInput PS) : COLOR0
    {
        float3 vView = normalize(PS.View.xyz);	
    
        float wx = gWeather;
        
        float  wpos2 = length(vView.xyz);
        float3 camdir = vView.xyz / wpos2;	
        float3 npos = normalize(PS.Normal);
        
      float hourMinutes = (1 / 59) * 15;
      float GameTime = 15 + hourMinutes;
    
       float t0 = GameTime;
       float x1 = smoothstep(0.0, 4.0, t0);
       float x2 = smoothstep(4.0, 5.0, t0);
       float x3 = smoothstep(5.0, 6.0, t0);
       float x4 = smoothstep(6.0, 7.0, t0);
       float xE = smoothstep(8.0, 11.0, t0);
       float x5 = smoothstep(16.0, 17.0, t0);
       float x6 = smoothstep(18.0, 19.0, t0);
       float x7 = smoothstep(19.0, 20.0, t0);
       float xG = smoothstep(20.0, 21.0, t0);  
       float xZ = smoothstep(21.0, 22.0, t0);
       float x8 = smoothstep(22.0, 24.0, t0);	
       
     //SunDirection--------------------
    float3  f = lerp(float3(0.,0.,-.61), float3(.583,-.257,-.0108), smoothstep(0.,5.,GameTime));
            f = lerp(f, float3(.569,-.242,.151), smoothstep(5.,7.,GameTime));
            f = lerp(f, float3(.49,-.247,.323), smoothstep(7.,9.,GameTime));
            f = lerp(f, float3(.373,-.262,.445), smoothstep(9.,11.,GameTime));
            f = lerp(f, float3(.201,-.312,.517), smoothstep(11.,13.,GameTime));
            f = lerp(f, float3(-.00732,-.39,.503), smoothstep(13.,15.,GameTime));
            f = lerp(f, float3(-.189,-.502,.343), smoothstep(15.,17.,GameTime));
            f = lerp(f, float3(-.223,-.594,.1), smoothstep(17.,19.,GameTime));
            f = lerp(f, float3(0.,0.,-.61), smoothstep(19.,24.,GameTime));
            f = normalize(f);  	
            
       float3 df0 = lerp(0.70*float3(0.90, 0.95, 1.02), 0.70*float3(0.90, 0.95, 1.02), x1);
              df0 = lerp(df0, 0.72*float3(0.90, 0.95, 1.02), x2);
              df0 = lerp(df0, 1.75*float3(1.15, 0.95, 0.75), x3);
              df0 = lerp(df0, 2.1*float3(1.10, 0.99, 0.90), x4);
              df0 = lerp(df0, 2.2*float3(1.02, 0.99, 0.95), xE);
              df0 = lerp(df0, 2.2*float3(1.02, 0.99, 0.95), x5);
              df0 = lerp(df0, 1.95*float3(1.20, 0.99, 0.70), x6);
              df0 = lerp(df0, 1.80*float3(1.10, 0.95, 0.80), x7);
              df0 = lerp(df0, 0.80*float3(0.95, 0.92, 0.90), xG);	
              df0 = lerp(df0, 0.75*float3(0.90, 0.95, 1.02), xZ);	  
              df0 = lerp(df0, 0.70*float3(0.90, 0.95, 1.02), x8); 
              
       float3 df1 = 0.70;
       
        if (wx.x==2) df0 = df1; 
        if (wx.x==3) df0 = df1;   
        if (wx.x==4) df0 = df1;
        if (wx.x==7) df0 = df1;
        if (wx.x==8) df0 = df1;
        if (wx.x==9) df0 = df1;
        if (wx.x==12) df0 = df1;
        if (wx.x==15) df0 = df1;
        if (wx.x==16) df0 = df1;		
    
        
       float3 sh0 = lerp(0.70, 0.70, x1);
              sh0 = lerp(sh0, 0.70, x2);
              sh0 = lerp(sh0, 0.95, x3);
              sh0 = lerp(sh0, 0.95, x4);
              sh0 = lerp(sh0, 0.95, xE);
              sh0 = lerp(sh0, 0.95, x5);
              sh0 = lerp(sh0, 0.80, x6);
              sh0 = lerp(sh0, 0.80, x7);
              sh0 = lerp(sh0, 0.80, xG);	
              sh0 = lerp(sh0, 0.75, xZ);		  		  
              sh0 = lerp(sh0, 0.70, x8); 
              
    float3 shadowColor = float3(0.90, 0.93, 1.025);			  
        if (wx.x==4) shadowColor = 1.0;
        if (wx.x==7) shadowColor = 1.0;
        if (wx.x==8) shadowColor = 1.0;
        if (wx.x==9) shadowColor = 1.0;
        if (wx.x==12) shadowColor = 1.0;
        if (wx.x==15) shadowColor = 1.0;
        if (wx.x==16) shadowColor = 1.0;
    
    
        float3 Color0 = float3(1, 0.9, 0.75);
        float3 Color1 = float3(1.25, 1.25, 0.85);
        
         if (wx.x==2) Color0 = Color1;
         if (wx.x==3) Color0 = Color1;		 
         if (wx.x==4) Color0 = Color1;
         if (wx.x==7) Color0 = Color1;
         if (wx.x==8) Color0 = Color1;
         if (wx.x==9) Color0 = Color1;
         if (wx.x==12) Color0 = Color1;
         if (wx.x==15) Color0 = Color1;
         if (wx.x==16) Color0 = Color1;	
     
        float3 bl0 = lerp(0.0, 0.0, x1);
               bl0 = lerp(bl0, 0.0, x2);
               bl0 = lerp(bl0, 0.5*Color0, x3);
               bl0 = lerp(bl0, 1.5*Color0, x4);
               bl0 = lerp(bl0, 1.5*Color0, xE);
               bl0 = lerp(bl0, 0.75*Color0, x5);
               bl0 = lerp(bl0, 0.5*Color0, x6);
               bl0 = lerp(bl0, 0.3*Color0, x7);
               bl0 = lerp(bl0, 0.0, xG);		
               bl0 = lerp(bl0, 0.0, xZ);		  
               bl0 = lerp(bl0, 0.0, x8);
    
              
             
       float sp0 = lerp(0.0, 0.0, x1);
             sp0 = lerp(sp0, 0.0, x2);
             sp0 = lerp(sp0, 1.0, x3);
             sp0 = lerp(sp0, 1.0, x4);
             sp0 = lerp(sp0, 1.0, xE);
             sp0 = lerp(sp0, 1.0, x5);
             sp0 = lerp(sp0, 1.0, x6);
             sp0 = lerp(sp0, 1.0, x7);
             sp0 = lerp(sp0, 0.0, xG);	
             sp0 = lerp(sp0, 0.0, xZ);			 
             sp0 = lerp(sp0, 0.0, x8);	
             
        if (wx.x==2) sp0 = 0.0;
        if (wx.x==3) sp0 = 0.0;		 
        if (wx.x==4) sp0 = 0.0;
        if (wx.x==7) sp0 = 0.0;
        if (wx.x==8) sp0 = 0.0;
        if (wx.x==9) sp0 = 0.0;
        if (wx.x==12) sp0 = 0.0;
        if (wx.x==15) sp0 = 0.0;
        if (wx.x==16) sp0 = 0.0;			 
             
                
       float3 X2 = normalize(f+camdir);	
       float specular3 = pow(0.01-dot(npos.xyz, X2.xyz), 0.35);
             specular3 = pow(specular3, 50.0*1.8);
             specular3 = (specular3*specular3)*10.5;
             specular3/= 5.5*1.5; 	
             
        float df2 = 0.01*0.001 + dot(npos.xyz, X2);	
              df2 = pow(df2, 2500.0*2);
        float gl = (df2/0.01)* 0.01;
              gl = saturate(gl)*10.0;		   
               
         float4 ColorCar = PS.Diffuse;	
        float4 texel = tex2D(Sampler0, PS.TexCoord);
               texel.rgb*= ColorCar*float3(0.97, 1.0, 1.05);
               
        float texelA = saturate(texel.rgb);	
        float mix = lerp(0.7, 2.2, texelA);	
        float diff = saturate(0.1-dot(npos, -f)); 
              diff = pow(diff, 0.7);
    
        float3 sv3 = normalize(float3(0.0, 0.0, 0.7)+vView.xyz); 	
        float fresnelz = (0.05-dot(-sv3, npos));		
              fresnelz = pow(fresnelz, 5.0);
              fresnelz = fresnelz*fresnelz;
              fresnelz/= 2.5;	
              fresnelz*= 0.7;		  		  		  
              
        float3 lighting = lerp(sh0*shadowColor, df0, saturate(diff));			   
        
        float3 refl = reflect(vView, npos*1.05);	
        
        float4 CubeD = texCUBE(ReflDaySampler, -refl.xzy);
               CubeD*= 2.0;	
        float4 CubeDV = texCUBE(VReflDaySampler, -refl.xzy);
               CubeDV*= 2.1; //1
                   
        float3 CurrentRefl =  CubeDV.rgb;
    
        if (wx.x==0) CurrentRefl = CubeD.rgb;
        if (wx.x==1) CurrentRefl = CubeD.rgb;
        if (wx.x==2) CurrentRefl = CubeD.rgb;
        if (wx.x==3) CurrentRefl = CubeD.rgb;
        if (wx.x==4) CurrentRefl = CubeD.rgb;
        
        
        float4 CubeN = texCUBE(ReflNightSampler, -refl.xzy);
               CubeN.rgb*= 2.2*float3(0.82, 0.95, 1.05);
    
        float3 cb = lerp(CubeN.xyz, CubeN.xyz, x1);
               cb = lerp(cb, CubeN.xyz, x2);
               cb = lerp(cb, CurrentRefl.xyz*1.1, x3);
               cb = lerp(cb, CurrentRefl.xyz, x6);
               cb = lerp(cb, CurrentRefl.xyz*0.85, x7);
               cb = lerp(cb, CurrentRefl.xyz*0.8, xG);		   
               cb = lerp(cb, CubeN.xyz, xZ);		   
               cb = lerp(cb, CubeN.xyz, x8);
               
        float3 n0 = normalize(cb.xyz);
        float3 ct0=cb.xyz/n0.xyz;
               ct0=pow(ct0, 2.0);
               n0.xyz = pow(n0.xyz, 1.8);   
               cb.xyz = ct0*n0.xyz;  
               cb.xyz*= 1.25;			   
        
        float fresnel = 0.001*1.0-dot(npos, -camdir);		
              fresnel = saturate(pow(fresnel, 0.37*0.15));		  
                
       float m0 = lerp(0.20, 0.20, x1);
             m0 = lerp(m0, 0.10, x2);
             m0 = lerp(m0, 0.0, x3);
             m0 = lerp(m0, 0.0, x4);
             m0 = lerp(m0, 0.0, x5);
             m0 = lerp(m0, 0.0, x6);
             m0 = lerp(m0, 0.0, x7);		 
             m0 = lerp(m0, 0.20, x8);
            
        float3 MoonVector = normalize(float3(-0.00732, -0.39, 0.317));
        float m1 = saturate(0.001 + dot(normalize(-MoonVector-camdir), -npos.xyz));	
              m1 = pow(m1, 35.0);
        float3 moon = (m1*m1)*m0*2.0;		  
           
        float mix2 = lerp(0.9, 5.0, texelA);		 
        float4 texel2 = tex2D(Sampler0, PS.TexCoord);	
        
        float4 Lighting1 = ColorCar*PS.Light*0.9;
    
          float4 diffuse  = gDiffuseMaterialSource  == 0 ? ColorCar  : 1;
    
    /*	
      float3 CL1 = float3(0.6, 0.8, 1.1)*1.1;
      float3 CL2 = float3(0.9, 0.95, 1.0); 
      float3 CL0 = lerp(CL1, CL1, x1);
             CL0 = lerp(CL0, float3(0.65, 0.83, 1.05), x2);
             CL0 = lerp(CL0, CL2, x3);
             CL0 = lerp(CL0, 1.0, x4);
             CL0 = lerp(CL0, 1.0, xE);
             CL0 = lerp(CL0, 1.0, x5);
             CL0 = lerp(CL0, float3(0.90, 0.95, 1.0), x6);
             CL0 = lerp(CL0, float3(0.66, 0.84, 1.04)*0.9, x7);
             CL0 = lerp(CL0, CL1, x8);
             
      float3 CV0 = lerp(float3(0.75, 0.85, 1.0), float3(0.75, 0.85, 1.0), x1);
             CV0 = lerp(CV0, float3(0.75, 0.85, 1.0), x2);
             CV0 = lerp(CV0, 1.0, x3);
             CV0 = lerp(CV0, 1.0, x4);
             CV0 = lerp(CV0, 1.0, xE);
             CV0 = lerp(CV0, 1.0, x5);
             CV0 = lerp(CV0, 1.0, x6);
             CV0 = lerp(CV0, 1.0, x7);
             CV0 = lerp(CV0, float3(0.75, 0.85, 1.0), x8);		 
             
    
    float3 CurrentWeather = 1.0;
    
    if (wx.x==0) CurrentWeather = CL0;
    if (wx.x==1) CurrentWeather = CL0;
    if (wx.x==2) CurrentWeather = CL0;
    if (wx.x==3) CurrentWeather = CL0;
    if (wx.x==4) CurrentWeather = CL0; 	
    
    if (wx.x==7) CurrentWeather = CL0;
    if (wx.x==8) CurrentWeather = CL0;
    if (wx.x==9) CurrentWeather = CL0;
    
    if (wx.x==12) CurrentWeather = CL0;
    if (wx.x==15) CurrentWeather = CL0;
    if (wx.x==16) CurrentWeather = CL0;	  
    
    if (wx.x==5) CurrentWeather = CV0;
    if (wx.x==6) CurrentWeather = CV0;
     
    if (wx.x==10) CurrentWeather = CV0; 		 
    if (wx.x==11) CurrentWeather = CV0; 
    if (wx.x==13) CurrentWeather = CV0; 	
    if (wx.x==14) CurrentWeather = CV0; 
    if (wx.x==17) CurrentWeather = CV0; 
    */
        float Stg = ((texel.a <=0.9999) || PS.Material);
    
        float4 DiffAmb = PS.AmbC*2.0;
      if (Stg) DiffAmb = ColorCar*0.3;
           
        float4 finalColor2 = float4((DiffAmb.rgb+Lighting1.rgb)*texel2.rgb*0.9, min(diffuse.a, texel2.a));	
           
        float3 specmix2 = lerp(specular3*1.5, specular3*finalColor2*1.5, 0.80);	
            
    
       float factor3 = 0.1 - dot(-vView, npos);
             factor3 = pow(factor3, 0.65);
       float fr3 = (factor3*factor3); 
             fr3/= 2.5;	
             fr3 = saturate(fr3*2.6);	
             fr3 = lerp(1.0, fr3, 0.35);		
    
               finalColor2.rgb*= fr3;			
            
               finalColor2.rgb*= (lighting);				   
               finalColor2.rgb+= specmix2*bl0*0.7; 
               finalColor2.rgb+= moon*float3(0.85, 0.95, 1.1)*0.5;	
               finalColor2.rgb+= saturate(lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92)*0.7);				   
    
    
               
        //finalColor2.rgb+= lerp(lerp(fresnelz*2.4, finalColor2.xyz*fresnelz*1.2, 0.92), 0.0, saturate(lighting2));			
        //finalColor2.rgb+= lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92);		
        
        float fresnelx = 0.001-dot(-vView, npos);		
              fresnelx = saturate(pow(fresnelx, 0.37));
              fresnelx = lerp(1.0, 0.0, 0.92*fresnelx);	
    
       float sp1 = lerp(0.2, 0.2, x1);
             sp1 = lerp(sp1, 0.2, x2);
             sp1 = lerp(sp1, 0.6, x3);
             sp1 = lerp(sp1, 0.8, x4);
             sp1 = lerp(sp1, 0.9, x5);
             sp1 = lerp(sp1, 0.6, x6);
             sp1 = lerp(sp1, 0.5, x7);
             sp1 = lerp(sp1, 0.2, xG);	
             sp1 = lerp(sp1, 0.2, xZ);			 
             sp1 = lerp(sp1, 0.2, x8);	
                         
    
               
        
      float3 v = {0.6, 0.6, 0.95};
      float3 v2 = {0.9, 0.9, 1.0};  
      
      float3 n = normalize(npos.xyz*v);		 
      float3 ref0 = reflect(vView.xyz, n.xyz);		 
      //float3 n1 = ((1000.0/0.01)*n0)/1000.0;		
      float3 ref2 = (1.0*ref0)/0.5;	  
      
      float3 r0 = (vView.xyz+ref2)*0.95;	
      float2 r1 = wpd2(r0.xyz);		
        
        float2 rc = r1.xy;		
        
        float4 envMap = tex2D(SamplerColor, rc);
               envMap.w = rc.y<0.0||rc.y>1.0 ? 0.0:1.0; 
               envMap.w*= rc.x<0.0||rc.x>1.0 ? 0.0:1.0;
    
        float c08 = 6.7;
        float c07 = 1.0;
    
        float nf02 = saturate(c08*(r1.y));
              nf02*= saturate(c08*(r1.x));					
              nf02 = pow(nf02, c07);			
        float nf03 = saturate(c08+r1.y*(-c08));
              nf03*= saturate(c08+r1.x*(-c08));					
              nf03 = pow(nf03, c07);
        
        float fresnelR = 0.01-dot(npos, -camdir);		
              fresnelR = saturate(pow(fresnelR, 4.0));	
    
                cb = lerp(cb, envMap.xyz*3.3,  envMap.w*nf02*nf03*pow(0.01*0.5, fresnelR));	
        float3 reflection = lerp(1.12*cb+(gl*sp0*4.0), finalColor2.rgb, 0.97*fresnel);
    
        //float3 AtmSky = getSky(GameTime, wx, wpos, wpos2);	
               
               finalColor2.rgb = lerp(finalColor2.rgb+fresnelx*0.27*sp1*float3(0.92, 0.96, 1.0), reflection, Stg); //
               
        //finalColor2.rgb = GetCorrection(finalColor2.rgb*2.0);		   
    
               
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////  Снег  ////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
        float4 objspacepos	= PS.invTex;
        // Triplanar uvs
        float2 uvX = objspacepos.yz; // x facing plane
        float2 uvY = objspacepos.xz; // y facing plane	
        float2 uvZ = objspacepos.xy; // z facing plane   
    
        float3 wnorm = normalize(cross(ddx(objspacepos.xyz),ddy(objspacepos.xyz)));  
    
        float3 blending = pow(abs(wnorm.xyz), 3.0);
                blending = blending / (blending.x + blending.y + blending.z);	
               
        float3 blending2 = pow(abs(npos.xyz*float3(22.0, 22.0, 10.0)), 2.2);
                blending2 = blending2 / (blending2.x + blending2.y + blending2.z);		
                      
            float3 R1x = tex2D(SamplerSnow, uvX);
            float3 R1y = tex2D(SamplerSnow, uvY);		
            float3 R1z = tex2D(SamplerSnow, uvZ);
    
            float3 Ax = tex2D(SamplerSnowA, uvX);
            float3 Ay = tex2D(SamplerSnowA, uvY);		
            float3 Az = tex2D(SamplerSnowA, uvZ);
            
            float3 Shx = tex2D(SamplerShine, uvX);
            float3 Shy = tex2D(SamplerShine, uvY);		
            float3 Shz = tex2D(SamplerShine, uvZ);	
            
        float ShineMix = Shx*blending.x + Shy*blending.y + Shz*blending.z; 		   
    
        float3 vw = normalize(float3(0,0,1));
        float sAl = saturate(0.01-dot(vw, -npos));
              sAl = pow(sAl, 0.2);	//1		   
    
              
        float3 SnowMix = R1x*blending.x + R1y*blending.y + R1z*blending.z; 	 		
        float SnowMixA = Ax*blending.x + Ay*blending.y + Az*blending.z; 
    
        float Glass = pow(ColorCar.a, 0.5);
        float3 Lighting2 = PS.Light*0.9; 
        
       float3 dfsn = lerp(0.45*float3(0.78, 0.90, 1.02), 0.45*float3(0.78, 0.90, 1.02), x1);
              dfsn = lerp(dfsn, 0.8*float3(0.90, 0.95, 1.02), x2);
              dfsn = lerp(dfsn, 1.05*float3(1.0, 0.99, 0.95), x3);
              dfsn = lerp(dfsn, 1.11*float3(1.0, 0.99, 0.95), x4);
              dfsn = lerp(dfsn, 1.15*float3(1.02, 0.99, 0.95), xE);
              dfsn = lerp(dfsn, 1.15*float3(1.02, 0.99, 0.95), x5);
              dfsn = lerp(dfsn, 1.12*float3(1.05, 0.90, 0.80), x6);
              dfsn = lerp(dfsn, 0.9*float3(0.93, 0.90, 0.95), x7);
              dfsn = lerp(dfsn, 0.6*float3(0.90, 0.95, 1.02), xG);	
              dfsn = lerp(dfsn, 0.5*float3(0.90, 0.95, 1.02), xZ);			  
              dfsn = lerp(dfsn, 0.45*float3(0.82, 0.90, 1.02), x8); 
              
       float3 dfn = lerp(0.45*float3(0.92, 0.96, 1.03), 0.45*float3(0.92, 0.96, 1.03), x1);
              dfn = lerp(dfn, 0.52*float3(0.92, 0.96, 1.02), x2);
              dfn = lerp(dfn, 0.8*float3(0.95, 0.97, 1.00), x3);
              dfn = lerp(dfn, 0.85, x4);
              dfn = lerp(dfn, 0.85, xE);
              dfn = lerp(dfn, 0.85, x5);
              dfn = lerp(dfn, 0.85, x6);
              dfn = lerp(dfn, 0.7*float3(0.94, 0.96, 1.01), x7);
              dfn = lerp(dfn, 0.6*float3(0.92, 0.96, 1.02), xG);	
              dfn = lerp(dfn, 0.5*float3(0.90, 0.96, 1.02), xZ);			  
              dfn = lerp(dfn, 0.45*float3(0.90, 0.96, 1.02), x8); 		  
              dfn*=float3(0.92, 0.96, 1.03);
    
        if (wx.x==2) dfsn = dfn;
        if (wx.x==3) dfsn = dfn;		  
        if (wx.x==4) dfsn = dfn;
        if (wx.x==7) dfsn = dfn;
        if (wx.x==8) dfsn = dfn;
        if (wx.x==9) dfsn = dfn;
        if (wx.x==12) dfsn = dfn;
        if (wx.x==15) dfsn = dfn;
        if (wx.x==16) dfsn = dfn;	
              
     if (Stg) finalColor2.rgb+= lerp(0.0, 1.6*(moon*float3(0.85, 0.95, 1.1)*3.5) + specular3*bl0*4.5, (ShineMix*0.2)*saturate(blending2.z+SnowMixA*2.0*blending2.z)*Glass*sAl);
    
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////  Снег  ////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    
    float3 TM0 = GetCorrection(finalColor2.rgb*0.9);
	float3 TM1 = Uncharted2Tonemap(finalColor2.rgb*0.9);	
	       finalColor2.rgb = lerp(TM0, TM1, 0.00);			   
	
           finalColor2.rgb = saturate(finalColor2.rgb);
           finalColor2.rgb = pow(finalColor2.rgb, 1.25);

           finalColor2.a*= ColorCar.a; //1
    return finalColor2;
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////RADMIR/////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////
    
    technique tec0
    {
        pass P0
        {
            VertexShader = compile vs_3_0 VertexShaderFunction();	
            PixelShader = compile ps_3_0 PS_Reflection();
        }
    }
    
    // Fallback
    technique fallback
    {
        pass P0
        {
            // Just draw normally
        }
    }
]]

matte = [[
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++      _________           __         __________       __               __    __  __      _________       +++++//
//+++++     |XX|X X XX|          XX        |HH|HHH\HHH\     |XX              |XX|  |XX||XX|    |XX|X X XX|      +++++//
//+++++     |XX|    |XX|        /XX\       |HH|      \HH\   |XX||XX|     |XX||XX|    |XX|      |XX|    |XX|     +++++//
//+++++     |XX|    |XX|       /XXXX\      |HH|       |HH|  |XX| |XX|   |XX| |XX|    |XX|      |XX|    |XX|     +++++//
//+++++     |XX|   |XX|       /XX/\XX\     |HH|       |HH|  |XX|  |XX| |XX|  |XX|    |XX|      |XX|   |XX|      +++++//
//+++++     |XX|X X X|       /XX/  \XX\    |HH|       |HH|  |XX|     |XX|    |XX|    |XX|      |XX|X X X|       +++++//
//+++++     |XX|   \XX\     /XXXXXXXXXX\   |HH|       |HH|  |XX|             |XX|    |XX|      |XX|   \XX\      +++++//
//+++++     |XX|    \XX\   /XX/      \XX\  |HH|      /HH/   |XX|             |XX|    |XX|      |XX|    \XX\     +++++//
//+++++     |XX|    |XX|  /XX/        \XX\ |HH|    /HHH/    |XX|             |XX|    |XX|      |XX|     |XX|    +++++//
//+++++     |XX|    |XX| /XX/          \XX\|HHHHHHHHH/      |XX|             |XX|  |XX||XX|    |XX|     |XX|    +++++// 
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

//---------------------------------------------------------------------
// ...
//---------------------------------------------------------------------
//int gGameTimeHours : GAME_TIME_HOURS;
//int gGameTimeMinutes : GAME_TIME_MINUTES;
//int gWeather : WEATHER;
//int gStage1ColorOp < string stageState="1,COLOROP"; >;

float2 sEffectFade = float2(50, 50);
//---------------------------------------------------------------------
// Textures
//---------------------------------------------------------------------
texture gScreenSource : SCREEN_SOURCE;
texture gDepthBuffer : DEPTHBUFFER;

texture sReflDay;
texture sReflNight;
texture sSnow;
texture sSnowA;
texture sShine;
texture sReflDayV;
texture sReflectionTexture;
texture sRandomTexture;
//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
#include "radmir.fx"
//---------------------------------------------------------------------
// Sampler
//---------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
};

sampler SamplerDepth = sampler_state
{
    Texture = (gDepthBuffer);
    AddressU = Clamp;
    AddressV = Clamp;
};

sampler3D RandomSampler = sampler_state
{
   Texture = (sRandomTexture);
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = POINT;
   MIPMAPLODBIAS = 0.000000;
};

samplerCUBE VReflDaySampler = sampler_state
{
	Texture = (sReflectionTexture);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE; //FALSE		
    MaxMipLevel=0;
    MipMapLodBias=0;
};

samplerCUBE ReflDaySampler = sampler_state
{
	Texture = (sReflectionTexture);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE;		
    MaxMipLevel=0;
    MipMapLodBias=0;
};

samplerCUBE ReflNightSampler = sampler_state
{
	Texture = (sReflectionTexture);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE;//FALSE
    MaxMipLevel=0;
    MipMapLodBias=0;
};

samplerCUBE ReflectionSampler = sampler_state
{
   Texture = (sReflectionTexture);
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = LINEAR;
   MIPMAPLODBIAS = 0.000000;
};

sampler2D SamplerSnow = sampler_state
{
   Texture   = <sSnow>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerSnowA = sampler_state
{
   Texture   = <sSnowA>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerShine = sampler_state
{
   Texture   = <sShine>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler SamplerColor = sampler_state
{
    Texture = (gScreenSource);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU  = Clamp;
	AddressV  = Clamp;
	SRGBTexture=FALSE;	
};

//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
	float3 Normal : NORMAL0;
	
    float4 Color : COLOR0;	
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
	float4 Position2 : POSITION1;	
    float2 TexCoord : TEXCOORD0;
    float4 Color : COLOR0;
	float4 AmbC : TEXCOORD1;
    float4 invTex : TEXCOORD2;
    float3 Material : TEXCOORD3;	
    float3 Normal : TEXCOORD4;
    float4 View : TEXCOORD5;
    float4 Light : TEXCOORD6;	
    float4 Diffuse : TEXCOORD7;		
};


////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

   // FixUpNormal( VS.Normal );
	
    // Set information to do specular calculation
    float3 Normal = mul(VS.Normal, (float3x3)gWorld);
    PS.Normal = Normal;
    Normal = normalize(Normal);	

    float4 worldPos = mul( float4(VS.Position.xyz,1) , gWorld );

	PS.Position = mul(float4(VS.Position.xyz , 1.0), gWorldViewProjection);
	PS.Position2 = PS.Position;
	
    PS.AmbC = gMaterialAmbient;
    PS.Material = AlphaMaterial();
    PS.View.xyz = gCameraPosition - worldPos.xyz;
	
    //PS.Color = CalcGTACompleteDiffuse(Normal, VS.Color);
    PS.Diffuse = gMaterialDiffuse;	
	PS.Light = CalcGTADynamicDiffuse(Normal); //1
	PS.TexCoord.xy = VS.TexCoord.xy;

    float refMask = pow(2 * dot(Normal, normalize(PS.View.xyz)), 3);
    PS.View.w = saturate(1 - refMask) * pow(dot(Normal, float3(0,0,1)), 1);

    float4x4 gWVPI =  inverse(gWorldViewProjection);
	float4 objspacepos	= mul(PS.Position2, gWVPI);
	       objspacepos.xyz/=objspacepos.w;
		   
    PS.invTex = objspacepos;
/**/	
    // Distance fade calculation
    float DistanceFromCamera = distance(gCameraPosition, worldPos.xyz);
    PS.View.w *= saturate(1 - ((DistanceFromCamera - sEffectFade.y) / (sEffectFade.x - sEffectFade.y)));
	
    return PS;
}

float3 GetCorrection(float3 color)
{
	float3 n0 = normalize(color.xyz);
	float3 ct0=color.xyz/n0.xyz;
	       ct0=pow(ct0, 1.0);
           n0.xyz = pow(n0.xyz, 1.0);   
           color.xyz = ct0*n0.xyz;  
           color.xyz*= 1.0;
	 
	float mC = max(color.x, max(color.y, color.z));		 		 
	float3 x1 = 1.0 - exp(-mC);	
	float3 rg =  float3(x1.x, x1.y, x1.z);
	float3 x2 = 1.0 - exp(-color);	
	float3 rg2 =  float3(x2.x, x2.y, x2.z);	
		 
	float mm = rg;
	float3 c1 = color * mm / mC;
	float3 p2 = rg2;
	color.xyz = lerp(p2, c1, 0.2);		 

	return color;	
}

float3 Uncharted2Tonemap(float3 x)
{
    float A = 1.0;
	float B = 0.25;
	float C = 0.52;
	float D = 0.34;
	float E = 0.0;
	float F = 1.0;

    return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
}

/*
*/

float2 wpd2(float3 cd)
{
   float4 tv = float4(cd.xyz, 1.0);
   float4 wp = mul(tv, gViewInverseTranspose);
		  //wp.xyz/= wp.w;   
		  
		  wp.x = -wp.x;  		  
		  wp.xy = wp.xy*0.0+0.0;
   return wp.xy;
}

////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

float4 PS_Reflection(PSInput PS) : COLOR0
{
    float3 vView = normalize(PS.View.xyz);	

	float wx = gWeather;
	
    float  wpos2 = length(vView.xyz);
    float3 camdir = vView.xyz / wpos2;	
    float3 npos = normalize(PS.Normal);
	
  float hourMinutes = (1 / 59) * 15;
  float GameTime = 15 + hourMinutes;

   float t0 = GameTime;
   float x1 = smoothstep(0.0, 4.0, t0);
   float x2 = smoothstep(4.0, 5.0, t0);
   float x3 = smoothstep(5.0, 6.0, t0);
   float x4 = smoothstep(6.0, 7.0, t0);
   float xE = smoothstep(8.0, 11.0, t0);
   float x5 = smoothstep(22, 24, t0);
   float x6 = smoothstep(22.0, 24.0, t0);
   float x7 = smoothstep(22.0, 24.0, t0);
   float xG = smoothstep(20.0, 21.0, t0);  
   float xZ = smoothstep(21.0, 22.0, t0);
   float x8 = smoothstep(22.0, 24.0, t0);	
   
 //SunDirection--------------------
float3  f = lerp(float3(0.,0.,-.61), float3(.583,-.257,-.0108), smoothstep(0.,5.,GameTime));
        f = lerp(f, float3(.569,-.242,.151), smoothstep(5.,7.,GameTime));
		f = lerp(f, float3(.49,-.247,.323), smoothstep(7.,9.,GameTime));
		f = lerp(f, float3(.373,-.262,.445), smoothstep(9.,11.,GameTime));
		f = lerp(f, float3(.201,-.312,.517), smoothstep(11.,13.,GameTime));
		f = lerp(f, float3(-.00732,-.39,.503), smoothstep(13.,15.,GameTime));
		f = lerp(f, float3(-.189,-.502,.343), smoothstep(15.,17.,GameTime));
		f = lerp(f, float3(-.223,-.594,.1), smoothstep(17.,19.,GameTime));
		f = lerp(f, float3(0.,0.,-.61), smoothstep(19.,24.,GameTime));
		f = normalize(f);  	
		
   float3 df0 = lerp(0.70*float3(0.90, 0.95, 1.02), 0.70*float3(0.90, 0.95, 1.02), x1);
          df0 = lerp(df0, 0.72*float3(0.90, 0.95, 1.02), x2);
          df0 = lerp(df0, 1.75*float3(1.15, 0.95, 0.75), x3);
          df0 = lerp(df0, 2.1*float3(1.10, 0.99, 0.90), x4);
          df0 = lerp(df0, 4*float3(1, 1, 1), xE);
          df0 = lerp(df0, 4*float3(1.02, 1, 1), x5);
          df0 = lerp(df0, 4*float3(1, 1, 1), x6);
          df0 = lerp(df0, 1.80*float3(1.10, 0.95, 0.80), x7);
          df0 = lerp(df0, 0.80*float3(0.95, 0.92, 0.90), xG);	
          df0 = lerp(df0, 0.75*float3(0.90, 0.95, 1.02), xZ);	  
          df0 = lerp(df0, 0.70*float3(0.90, 0.95, 1.02), x8); 
		  
   float3 df1 = 0.70;
   
    if (wx.x==2) df0 = df1; 
    if (wx.x==3) df0 = df1;   
    if (wx.x==4) df0 = df1;
    if (wx.x==7) df0 = df1;
    if (wx.x==8) df0 = df1;
    if (wx.x==9) df0 = df1;
    if (wx.x==12) df0 = df1;
    if (wx.x==15) df0 = df1;
    if (wx.x==16) df0 = df1;		

	
   float3 sh0 = lerp(0.70, 0.70, x1);
          sh0 = lerp(sh0, 0.70, x2);
          sh0 = lerp(sh0, 0.95, x3);
          sh0 = lerp(sh0, 0.95, x4);
          sh0 = lerp(sh0, 2, xE);
          sh0 = lerp(sh0, 2, x5);
          sh0 = lerp(sh0, 2, x6);
          sh0 = lerp(sh0, 0.80, x7);
          sh0 = lerp(sh0, 0.80, xG);	
          sh0 = lerp(sh0, 0.75, xZ);		  		  
          sh0 = lerp(sh0, 0.70, x8); 
		  
float3 shadowColor = float3(0.90, 0.93, 1.025);			  
    if (wx.x==4) shadowColor = 1.0;
    if (wx.x==7) shadowColor = 1.0;
    if (wx.x==8) shadowColor = 1.0;
    if (wx.x==9) shadowColor = 1.0;
    if (wx.x==12) shadowColor = 1.0;
    if (wx.x==15) shadowColor = 1.0;
    if (wx.x==16) shadowColor = 1.0;


    float3 Color0 = float3(1.5, 1.3, 0.90);
   float3 Color1 = float3(0.90, 0.92, 0.99)*0.9;
   
    if (wx.x==2) Color0 = Color1;
    if (wx.x==3) Color0 = Color1;		 
    if (wx.x==4) Color0 = Color1;
    if (wx.x==7) Color0 = Color1;
    if (wx.x==8) Color0 = Color1;
    if (wx.x==9) Color0 = Color1;
    if (wx.x==12) Color0 = Color1;
    if (wx.x==15) Color0 = Color1;
    if (wx.x==16) Color0 = Color1;	

   float3 bl0 = lerp(0.0, 0.0, x1);
          bl0 = lerp(bl0, 0.0, x2);
          bl0 = lerp(bl0, 1.5*Color0, x3);
          bl0 = lerp(bl0, 1.7*Color0, x4);
          bl0 = lerp(bl0, 1*Color0, xE);
          bl0 = lerp(bl0, 1*Color0, x5);
          bl0 = lerp(bl0, 1*Color0, x6);
          bl0 = lerp(bl0, 0.7*Color0, x7);
          bl0 = lerp(bl0, 0.0, xG);		
          bl0 = lerp(bl0, 0.0, xZ);		  
          bl0 = lerp(bl0, 0.0, x8); 

		  
		 
   float sp0 = lerp(0.0, 0.0, x1);
         sp0 = lerp(sp0, 0.0, x2);
         sp0 = lerp(sp0, 1.0, x3);
         sp0 = lerp(sp0, 1.0, x4);
         sp0 = lerp(sp0, 0.0, xE);
         sp0 = lerp(sp0, 0.0, x5);
         sp0 = lerp(sp0,0.0, x6);
         sp0 = lerp(sp0, 1.0, x7);
         sp0 = lerp(sp0, 0.0, xG);	
         sp0 = lerp(sp0, 0.0, xZ);			 
         sp0 = lerp(sp0, 0.0, x8);	
		 
    if (wx.x==2) sp0 = 0.0;
    if (wx.x==3) sp0 = 0.0;		 
    if (wx.x==4) sp0 = 0.0;
    if (wx.x==7) sp0 = 0.0;
    if (wx.x==8) sp0 = 0.0;
    if (wx.x==9) sp0 = 0.0;
    if (wx.x==12) sp0 = 0.0;
    if (wx.x==15) sp0 = 0.0;
    if (wx.x==16) sp0 = 0.0;			 
		 
 		   
   float3 X2 = normalize(f+camdir);	
   float specular3 = pow(0.01-dot(npos.xyz, X2.xyz), 0.05);
         specular3 = pow(specular3, 100.0*0.8);
         specular3 = (specular3*specular3)*1.5;
         specular3/= 2.5*1.5; 	
		 
    float df2 = 0.01*0.01 + dot(npos.xyz, X2);	
		  df2 = pow(df2, 1500.0*15.3);
	float gl = (df2/0.01)* 0.01;
          gl = saturate(gl)*7.0;		   
		   
 	float4 ColorCar = PS.Diffuse;	
    float4 texel = tex2D(Sampler0, PS.TexCoord);
	       texel.rgb*= ColorCar*float3(0.97, 1.0, 1.05);
		   
    float texelA = saturate(texel.rgb);	
    float mix = lerp(0.7, 2.2, texelA);	
    float diff = saturate(0.1-dot(npos, -f)); 
		  diff = pow(diff, 0.7);

    float3 sv3 = normalize(float3(0.0, 0.0, 0.7)+vView.xyz); 	
	float fresnelz = (0.05-dot(-sv3, npos));		
		  fresnelz = pow(fresnelz, 5.0);
		  fresnelz = fresnelz*fresnelz;
          fresnelz/= 2.5;	
          fresnelz*= 0.7;		  		  		  
		  
	float3 lighting = lerp(sh0*shadowColor, df0, saturate(diff));			   
	
    float3 refl = reflect(vView, npos);	
	
    float4 CubeD = texCUBE(ReflDaySampler, -refl.xzy);
	       CubeD*= 1.5;	
    float4 CubeDV = texCUBE(VReflDaySampler, -refl.xzy);
	       CubeDV*= 1.5; //1
			   
	float3 CurrentRefl =  CubeDV.rgb;

	if (wx.x==0) CurrentRefl = CubeD.rgb;
	if (wx.x==1) CurrentRefl = CubeD.rgb;
	if (wx.x==2) CurrentRefl = CubeD.rgb;
	if (wx.x==3) CurrentRefl = CubeD.rgb;
	if (wx.x==4) CurrentRefl = CubeD.rgb;
	
	
    float4 CubeN = texCUBE(ReflDaySampler, -refl.xzy);
	       CubeN.rgb*= 1*float3(0.82, 0.95, 1.05);

	float3 cb = lerp(CubeN.xyz, CubeN.xyz, x1);
		   cb = lerp(cb, CubeN.xyz, x2);
		   cb = lerp(cb, CurrentRefl.xyz*0.92, x3);
		   cb = lerp(cb, CurrentRefl.xyz, x6);
		   cb = lerp(cb, CurrentRefl.xyz*0.85, x7);
		   cb = lerp(cb, CurrentRefl.xyz*0.8, xG);		   
		   cb = lerp(cb, CubeN.xyz, xZ);		   
		   cb = lerp(cb, CubeN.xyz, x8);
		   
	float3 n0 = normalize(cb.xyz);
	float3 ct0=cb.xyz/n0.xyz;
	       ct0=pow(ct0, 2.0);
           n0.xyz = pow(n0.xyz, 0.8);   
           cb.xyz = ct0*n0.xyz;  
           cb.xyz*= 1.25;			   
	
	float fresnel = 0.001*1.0-dot(npos, -camdir);		
		  fresnel = saturate(pow(fresnel, 0.15));		  
  		  
   float m0 = lerp(0.20, 0.20, x1);
         m0 = lerp(m0, 0.10, x2);
         m0 = lerp(m0, 0.0, x3);
         m0 = lerp(m0, 1.0, x4);
         m0 = lerp(m0, 1.0, x5);
         m0 = lerp(m0, 1.0, x6);
         m0 = lerp(m0, 0.0, x7);		 
         m0 = lerp(m0, 0.20, x8);
		
    float3 MoonVector = normalize(float3(-0.00732, -0.39, 0.317));
    float m1 = saturate(0.001 + dot(normalize(-MoonVector-camdir), -npos.xyz));	
		  m1 = pow(m1, 35.0);
    float3 moon = (m1*m1)*m0*2.0;		  
	   
    float mix2 = lerp(0.9, 5.0, texelA);		 
    float4 texel2 = tex2D(Sampler0, PS.TexCoord);	
	
	float4 Lighting1 = ColorCar*PS.Light*0.9;

  	float4 diffuse  = gDiffuseMaterialSource  == 0 ? ColorCar  : 1;

/*	
  float3 CL1 = float3(0.6, 0.8, 1.1)*1.1;
  float3 CL2 = float3(0.9, 0.95, 1.0); 
  float3 CL0 = lerp(CL1, CL1, x1);
         CL0 = lerp(CL0, float3(0.65, 0.83, 1.05), x2);
         CL0 = lerp(CL0, CL2, x3);
         CL0 = lerp(CL0, 1.0, x4);
         CL0 = lerp(CL0, 1.0, xE);
         CL0 = lerp(CL0, 1.0, x5);
         CL0 = lerp(CL0, float3(0.90, 0.95, 1.0), x6);
         CL0 = lerp(CL0, float3(0.66, 0.84, 1.04)*0.9, x7);
         CL0 = lerp(CL0, CL1, x8);
		 
  float3 CV0 = lerp(float3(0.75, 0.85, 1.0), float3(0.75, 0.85, 1.0), x1);
         CV0 = lerp(CV0, float3(0.75, 0.85, 1.0), x2);
         CV0 = lerp(CV0, 1.0, x3);
         CV0 = lerp(CV0, 1.0, x4);
         CV0 = lerp(CV0, 1.0, xE);
         CV0 = lerp(CV0, 1.0, x5);
         CV0 = lerp(CV0, 1.0, x6);
         CV0 = lerp(CV0, 1.0, x7);
         CV0 = lerp(CV0, float3(0.75, 0.85, 1.0), x8);		 
		 

float3 CurrentWeather = 1.0;

if (wx.x==0) CurrentWeather = CL0;
if (wx.x==1) CurrentWeather = CL0;
if (wx.x==2) CurrentWeather = CL0;
if (wx.x==3) CurrentWeather = CL0;
if (wx.x==4) CurrentWeather = CL0; 	

if (wx.x==7) CurrentWeather = CL0;
if (wx.x==8) CurrentWeather = CL0;
if (wx.x==9) CurrentWeather = CL0;

if (wx.x==12) CurrentWeather = CL0;
if (wx.x==15) CurrentWeather = CL0;
if (wx.x==16) CurrentWeather = CL0;	  

if (wx.x==5) CurrentWeather = CV0;
if (wx.x==6) CurrentWeather = CV0;
 
if (wx.x==10) CurrentWeather = CV0; 		 
if (wx.x==11) CurrentWeather = CV0; 
if (wx.x==13) CurrentWeather = CV0; 	
if (wx.x==14) CurrentWeather = CV0; 
if (wx.x==17) CurrentWeather = CV0; 
*/
    float Stg = ((texel.a <=0.9999) || PS.Material);

    float4 DiffAmb = PS.AmbC*2.0;
  if (Stg) DiffAmb = ColorCar*0.6;
	   
	float4 finalColor2 = float4((DiffAmb.rgb+Lighting1.rgb)*texel2.rgb*0.9, min(diffuse.a, texel2.a));	
	   
    float3 specmix2 = lerp(specular3*1.5, specular3*finalColor2*1.5, 0.80);	
		

   float factor3 = 0.1 - dot(-vView, npos);
         factor3 = pow(factor3, 0.65);
   float fr3 = (factor3*factor3); 
         fr3/= 2.5;	
         fr3 = saturate(fr3*1.6);	
         fr3 = lerp(1.0, fr3, 0.35);		

           finalColor2.rgb*= fr3;			
		
           finalColor2.rgb*= (lighting);				   
           finalColor2.rgb+= specmix2*bl0*1.25; 
           finalColor2.rgb+= moon*float3(0.85, 0.95, 1.1)*0.5;	
           finalColor2.rgb+= saturate(lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92)*0.7);				   


		   
    //finalColor2.rgb+= lerp(lerp(fresnelz*2.4, finalColor2.xyz*fresnelz*1.2, 0.92), 0.0, saturate(lighting2));			
    //finalColor2.rgb+= lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92);		
	
	float fresnelx = 0.001-dot(-vView, npos);		
		  fresnelx = saturate(pow(fresnelx, 0.37));
		  fresnelx = lerp(1.0, 0.0, 0.92*fresnelx);	

   float sp1 = lerp(0.2, 0.2, x1);
         sp1 = lerp(sp1, 0.2, x2);
         sp1 = lerp(sp1, 0.6, x3);
         sp1 = lerp(sp1, 0.8, x4);
         sp1 = lerp(sp1, 0.9, x5);
         sp1 = lerp(sp1, 0.6, x6);
         sp1 = lerp(sp1, 0.5, x7);
         sp1 = lerp(sp1, 0.2, xG);	
         sp1 = lerp(sp1, 0.2, xZ);			 
         sp1 = lerp(sp1, 0.2, x8);	
		  		   

		   
	
  float3 v = {0.6, 0.6, 0.95};
  float3 v2 = {0.9, 0.9, 1.0};  
  
  float3 n = normalize(npos.xyz*v);		 
  float3 ref0 = reflect(vView.xyz, n.xyz);		 
  //float3 n1 = ((1000.0/0.01)*n0)/1000.0;		
  float3 ref2 = (1.0*ref0)/0.5;	  
  
  float3 r0 = (vView.xyz+ref2)*0.95;	
  float2 r1 = wpd2(r0.xyz);		
	
	float2 rc = r1.xy;		
	
    float4 envMap = tex2D(SamplerColor, rc);
	       envMap.w = rc.y<0.0||rc.y>1.0 ? 0.0:1.0; 
	       envMap.w*= rc.x<0.0||rc.x>1.0 ? 0.0:1.0;

	float c08 = 6.7;
	float c07 = 1.0;

	float nf02 = saturate(c08*(r1.y));
          nf02*= saturate(c08*(r1.x));					
	      nf02 = pow(nf02, c07);			
	float nf03 = saturate(c08+r1.y*(-c08));
          nf03*= saturate(c08+r1.x*(-c08));					
	      nf03 = pow(nf03, c07);
	
	float fresnelR = 0.01-dot(npos, -camdir);		
		  fresnelR = saturate(pow(fresnelR, 4.0));	

		    cb = lerp(cb, envMap.xyz*3.3,  envMap.w*nf02*nf03*pow(0.01*0.5, fresnelR));	
    float3 reflection = lerp(1.12*cb+(gl*sp0*4.0), finalColor2.rgb, 0.97*fresnel);

    //float3 AtmSky = getSky(GameTime, wx, wpos, wpos2);	
		   
           finalColor2.rgb = lerp(finalColor2.rgb+fresnelx*0.27*sp1*float3(0.92, 0.96, 1.0), reflection, Stg); //
		   
    //finalColor2.rgb = GetCorrection(finalColor2.rgb*2.0);		   

		   
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////  Снег  ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
	float4 objspacepos	= PS.invTex;
	// Triplanar uvs
    float2 uvX = objspacepos.yz; // x facing plane
    float2 uvY = objspacepos.xz; // y facing plane	
    float2 uvZ = objspacepos.xy; // z facing plane   

	float3 wnorm = normalize(cross(ddx(objspacepos.xyz),ddy(objspacepos.xyz)));  

    float3 blending = pow(abs(wnorm.xyz), 3.0);
 	       blending = blending / (blending.x + blending.y + blending.z);	
		   
    float3 blending2 = pow(abs(npos.xyz*float3(22.0, 22.0, 10.0)), 2.2);
 	       blending2 = blending2 / (blending2.x + blending2.y + blending2.z);		
		   	   
		float3 Shx = tex2D(SamplerShine, uvX);
		float3 Shy = tex2D(SamplerShine, uvY);		
		float3 Shz = tex2D(SamplerShine, uvZ);	
		
	float ShineMix = Shx*blending.x + Shy*blending.y + Shz*blending.z; 		   

    float3 vw = normalize(float3(0,0,1));
    float sAl = saturate(0.01-dot(vw, -npos));
		  sAl = pow(sAl, 0.2);	//1		   


	float Glass = pow(ColorCar.a, 0.5);
	float3 Lighting2 = PS.Light*0.9; 
	
   float3 dfsn = lerp(0.45*float3(0.78, 0.90, 1.02), 0.45*float3(0.78, 0.90, 1.02), x1);
          dfsn = lerp(dfsn, 0.8*float3(0.90, 0.95, 1.02), x2);
          dfsn = lerp(dfsn, 1.05*float3(1.0, 0.99, 0.95), x3);
          dfsn = lerp(dfsn, 1.11*float3(1.0, 0.99, 0.95), x4);
          dfsn = lerp(dfsn, 1.15*float3(1.02, 0.99, 0.95), xE);
          dfsn = lerp(dfsn, 1.15*float3(1.02, 0.99, 0.95), x5);
          dfsn = lerp(dfsn, 1.12*float3(1.05, 0.90, 0.80), x6);
          dfsn = lerp(dfsn, 0.9*float3(0.93, 0.90, 0.95), x7);
          dfsn = lerp(dfsn, 0.6*float3(0.90, 0.95, 1.02), xG);	
          dfsn = lerp(dfsn, 0.5*float3(0.90, 0.95, 1.02), xZ);			  
          dfsn = lerp(dfsn, 0.45*float3(0.82, 0.90, 1.02), x8); 
		  
   float3 dfn = lerp(0.45*float3(0.92, 0.96, 1.03), 0.45*float3(0.92, 0.96, 1.03), x1);
          dfn = lerp(dfn, 0.52*float3(0.92, 0.96, 1.02), x2);
          dfn = lerp(dfn, 0.8*float3(0.95, 0.97, 1.00), x3);
          dfn = lerp(dfn, 0.85, x4);
          dfn = lerp(dfn, 0.85, xE);
          dfn = lerp(dfn, 0.85, x5);
          dfn = lerp(dfn, 0.85, x6);
          dfn = lerp(dfn, 0.7*float3(0.94, 0.96, 1.01), x7);
          dfn = lerp(dfn, 0.6*float3(0.92, 0.96, 1.02), xG);	
          dfn = lerp(dfn, 0.5*float3(0.90, 0.96, 1.02), xZ);			  
          dfn = lerp(dfn, 0.45*float3(0.90, 0.96, 1.02), x8); 		  
		  dfn*=float3(0.92, 0.96, 1.03);

    if (wx.x==2) dfsn = dfn;
    if (wx.x==3) dfsn = dfn;		  
    if (wx.x==4) dfsn = dfn;
    if (wx.x==7) dfsn = dfn;
    if (wx.x==8) dfsn = dfn;
    if (wx.x==9) dfsn = dfn;
    if (wx.x==12) dfsn = dfn;
    if (wx.x==15) dfsn = dfn;
    if (wx.x==16) dfsn = dfn;	
		  
 
 if (Stg) finalColor2.rgb+= lerp(0.05, 1.6*(moon*float3(0.85, 0.95, 1.1)*3.5) + specular3*bl0*4.5, ShineMix*saturate(blending2.z*2.0*blending2.z)*Glass*sAl);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////  Снег  ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

	float3 TM0 = GetCorrection(finalColor2.rgb*0.25);
	float3 TM1 = Uncharted2Tonemap(finalColor2.rgb*1.2);	
	       finalColor2.rgb = lerp(TM0, TM1, 0.0);			   
	
           finalColor2.rgb = saturate(finalColor2.rgb);
           finalColor2.rgb = pow(finalColor2.rgb, 1.0);

           finalColor2.a*= ColorCar.a; //1
    return finalColor2;
}

////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

technique tec0
{
    pass P0
    {
        VertexShader = compile vs_3_0 VertexShaderFunction();	
        PixelShader = compile ps_3_0 PS_Reflection();
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
]]

chrome = [[//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    //+++++      _________           __         __________       __               __    __  __      _________       +++++//
    //+++++     |XX|X X XX|          XX        |HH|HHH\HHH\     |XX              |XX|  |XX||XX|    |XX|X X XX|      +++++//
    //+++++     |XX|    |XX|        /XX\       |HH|      \HH\   |XX||XX|     |XX||XX|    |XX|      |XX|    |XX|     +++++//
    //+++++     |XX|    |XX|       /XXXX\      |HH|       |HH|  |XX| |XX|   |XX| |XX|    |XX|      |XX|    |XX|     +++++//
    //+++++     |XX|   |XX|       /XX/\XX\     |HH|       |HH|  |XX|  |XX| |XX|  |XX|    |XX|      |XX|   |XX|      +++++//
    //+++++     |XX|X X X|       /XX/  \XX\    |HH|       |HH|  |XX|     |XX|    |XX|    |XX|      |XX|X X X|       +++++//
    //+++++     |XX|   \XX\     /XXXXXXXXXX\   |HH|       |HH|  |XX|             |XX|    |XX|      |XX|   \XX\      +++++//
    //+++++     |XX|    \XX\   /XX/      \XX\  |HH|      /HH/   |XX|             |XX|    |XX|      |XX|    \XX\     +++++//
    //+++++     |XX|    |XX|  /XX/        \XX\ |HH|    /HHH/    |XX|             |XX|    |XX|      |XX|     |XX|    +++++//
    //+++++     |XX|    |XX| /XX/          \XX\|HHHHHHHHH/      |XX|             |XX|  |XX||XX|    |XX|     |XX|    +++++// 
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    
    //---------------------------------------------------------------------
    // ...
    //---------------------------------------------------------------------
    //int gGameTimeHours : GAME_TIME_HOURS;
    //int gGameTimeMinutes : GAME_TIME_MINUTES;
    //int gWeather : WEATHER;
    //int gStage1ColorOp < string stageState="1,COLOROP"; >;
    
    float2 sEffectFade = float2(50, 40);
    //---------------------------------------------------------------------
    // Textures
    //---------------------------------------------------------------------
    texture gScreenSource : SCREEN_SOURCE;
    texture gDepthBuffer : DEPTHBUFFER;
    
    texture sReflDay;
    texture sReflNight;
    texture sSnow;
    texture sSnowA;
    texture sShine;
    texture sReflDayV;
    //---------------------------------------------------------------------
    // Include some common stuff
    //---------------------------------------------------------------------
    #include "radmir.fx"
    //---------------------------------------------------------------------
    // Sampler
    //---------------------------------------------------------------------
    sampler Sampler0 = sampler_state
    {
        Texture = (gTexture0);
    };
    
    sampler SamplerDepth = sampler_state
    {
        Texture = (gDepthBuffer);
        AddressU = Clamp;
        AddressV = Clamp;
    };
    
    samplerCUBE VReflDaySampler = sampler_state
    {
        Texture = (sReflDay);
        MAGFILTER = LINEAR;
        MINFILTER = LINEAR;
        MIPFILTER = LINEAR;
        SRGBTexture=FALSE; //FALSE		
        MaxMipLevel=0;
        MipMapLodBias=0;
    };
    
    samplerCUBE ReflDaySampler = sampler_state
    {
        Texture = (sReflDay);
        MAGFILTER = LINEAR;
        MINFILTER = LINEAR;
        MIPFILTER = LINEAR;
        SRGBTexture=FALSE;		
        MaxMipLevel=0;
        MipMapLodBias=0;
    };
    
    samplerCUBE ReflNightSampler = sampler_state
    {
        Texture = (sReflNight);
        MAGFILTER = LINEAR;
        MINFILTER = LINEAR;
        MIPFILTER = LINEAR;
        SRGBTexture=FALSE;//FALSE
        MaxMipLevel=0;
        MipMapLodBias=0;
    };
    
    sampler2D SamplerSnow = sampler_state
    {
       Texture   = <sSnow>;
        MinFilter = Linear;
        MagFilter = Linear;
        MipFilter = Linear;
        AddressU = Wrap;
        AddressV = Wrap;
        AddressW = Wrap;
    };
    
    sampler2D SamplerSnowA = sampler_state
    {
       Texture   = <sSnowA>;
        MinFilter = Linear;
        MagFilter = Linear;
        MipFilter = Linear;
        AddressU = Wrap;
        AddressV = Wrap;
        AddressW = Wrap;
    };
    
    sampler2D SamplerShine = sampler_state
    {
       Texture   = <sShine>;
        MinFilter = Linear;
        MagFilter = Linear;
        MipFilter = Linear;
        AddressU = Wrap;
        AddressV = Wrap;
        AddressW = Wrap;
    };
    
    sampler SamplerColor = sampler_state
    {
        Texture = (gScreenSource);
        MinFilter = LINEAR;
        MagFilter = LINEAR;
        MipFilter = LINEAR;
        AddressU  = Clamp;
        AddressV  = Clamp;
        SRGBTexture=FALSE;	
    };
    
    //---------------------------------------------------------------------
    // Structure of data sent to the vertex shader
    //---------------------------------------------------------------------
    struct VSInput
    {
        float4 Position : POSITION0;
        float2 TexCoord : TEXCOORD0;
        float3 Normal : NORMAL0;
        
        float4 Color : COLOR0;	
    };
    
    //---------------------------------------------------------------------
    // Structure of data sent to the pixel shader ( from the vertex shader )
    //---------------------------------------------------------------------
    struct PSInput
    {
        float4 Position : POSITION0;
        float4 Position2 : POSITION1;	
        float2 TexCoord : TEXCOORD0;
        float4 Color : COLOR0;
        float4 AmbC : TEXCOORD1;
        float4 invTex : TEXCOORD2;
        float3 Material : TEXCOORD3;	
        float3 Normal : TEXCOORD4;
        float4 View : TEXCOORD5;
        float4 Light : TEXCOORD6;	
        float4 Diffuse : TEXCOORD7;		
    };
    
    
    ////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////RADMIR/////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////
    
    PSInput VertexShaderFunction(VSInput VS)
    {
        PSInput PS = (PSInput)0;
    
       // FixUpNormal( VS.Normal );
        
        // Set information to do specular calculation
        float3 Normal = mul(VS.Normal, (float3x3)gWorld);
        PS.Normal = Normal;
        Normal = normalize(Normal);	
    
        float4 worldPos = mul( float4(VS.Position.xyz,1) , gWorld );
    
        PS.Position = mul(float4(VS.Position.xyz , 1.0), gWorldViewProjection);
        PS.Position2 = PS.Position;
        
        PS.AmbC = gMaterialAmbient;
        PS.Material = AlphaMaterial();
        PS.View.xyz = gCameraPosition - worldPos.xyz;
        
        //PS.Color = CalcGTACompleteDiffuse(Normal, VS.Color);
        PS.Diffuse = gMaterialDiffuse;	
        PS.Light = CalcGTADynamicDiffuse(Normal); //1
        PS.TexCoord.xy = VS.TexCoord.xy;
    
        float refMask = pow(2 * dot(Normal, normalize(PS.View.xyz)), 3);
        PS.View.w = saturate(1 - refMask) * pow(dot(Normal, float3(0,0,1)), 1);
    
        float4x4 gWVPI =  inverse(gWorldViewProjection);
        float4 objspacepos	= mul(PS.Position2, gWVPI);
               objspacepos.xyz/=objspacepos.w;
               
        PS.invTex = objspacepos;
    /**/	
        // Distance fade calculation
        float DistanceFromCamera = distance(gCameraPosition, worldPos.xyz);
        PS.View.w *= saturate(1 - ((DistanceFromCamera - sEffectFade.y) / (sEffectFade.x - sEffectFade.y)));
        
        return PS;
    }
    
    float3 GetCorrection(float3 color)
    {
        float3 n0 = normalize(color.xyz);
        float3 ct0=color.xyz/n0.xyz;
               ct0=pow(ct0, 1.0);
               n0.xyz = pow(n0.xyz, 1.1);   
               color.xyz = ct0*n0.xyz;  
               color.xyz*= 1.0;
         
        float mC = max(color.x, max(color.y, color.z));		 		 
        float3 x1 = 1.0 - exp(-mC);	
        float3 rg =  float3(x1.x, x1.y, x1.z);
        float3 x2 = 1.0 - exp(-color);	
        float3 rg2 =  float3(x2.x, x2.y, x2.z);	
             
        float mm = rg;
        float3 c1 = color * mm / mC;
        float3 p2 = rg2;
        color.xyz = lerp(p2, c1, 0.2);		 
    
        return color;	
    }
    
    float3 Uncharted2Tonemap(float3 x)
    {
        float A = 1.0;
        float B = 0.25;
        float C = 0.52;
        float D = 0.34;
        float E = 0.0;
        float F = 1.0;
    
        return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
    }
    
    /*
    */
    
    float2 wpd2(float3 cd)
    {
       float4 tv = float4(cd.xyz, 1.0);
       float4 wp = mul(tv, gViewInverseTranspose);
              //wp.xyz/= wp.w;   
              
              wp.x = -wp.x;  		  
              wp.xy = wp.xy*0.0+0.0;
       return wp.xy;
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////RADMIR/////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////
    
    float4 PS_Reflection(PSInput PS) : COLOR0
    {
        float3 vView = normalize(PS.View.xyz);	
    
        float wx = gWeather;
        
        float  wpos2 = length(vView.xyz);
        float3 camdir = vView.xyz / wpos2;	
        float3 npos = normalize(PS.Normal);
        
      float hourMinutes = (1 / 59) * 15;
      float GameTime = 15 + hourMinutes;
    
       float t0 = GameTime;
       float x1 = smoothstep(0.0, 4.0, t0);
       float x2 = smoothstep(4.0, 5.0, t0);
       float x3 = smoothstep(5.0, 6.0, t0);
       float x4 = smoothstep(6.0, 7.0, t0);
       float xE = smoothstep(8.0, 11.0, t0);
       float x5 = smoothstep(16.0, 17.0, t0);
       float x6 = smoothstep(18.0, 19.0, t0);
       float x7 = smoothstep(19.0, 20.0, t0);
       float xG = smoothstep(20.0, 21.0, t0);  
       float xZ = smoothstep(21.0, 22.0, t0);
       float x8 = smoothstep(22.0, 24.0, t0);	
       
     //SunDirection--------------------
    float3  f = lerp(float3(0.,0.,-.61), float3(.583,-.257,-.0108), smoothstep(0.,5.,GameTime));
            f = lerp(f, float3(.569,-.242,.151), smoothstep(5.,7.,GameTime));
            f = lerp(f, float3(.49,-.247,.323), smoothstep(7.,9.,GameTime));
            f = lerp(f, float3(.373,-.262,.445), smoothstep(9.,11.,GameTime));
            f = lerp(f, float3(.201,-.312,.517), smoothstep(11.,13.,GameTime));
            f = lerp(f, float3(-.00732,-.39,.503), smoothstep(13.,15.,GameTime));
            f = lerp(f, float3(-.189,-.502,.343), smoothstep(15.,17.,GameTime));
            f = lerp(f, float3(-.223,-.594,.1), smoothstep(17.,19.,GameTime));
            f = lerp(f, float3(0.,0.,-.61), smoothstep(19.,24.,GameTime));
            f = normalize(f);  	
            
       float3 df0 = lerp(0.70*float3(0.90, 0.95, 1.02), 0.70*float3(0.90, 0.95, 1.02), x1);
              df0 = lerp(df0, 0.72*float3(0.90, 0.95, 1.02), x2);
              df0 = lerp(df0, 1.75*float3(1.15, 0.95, 0.75), x3);
              df0 = lerp(df0, 2.1*float3(1.10, 0.99, 0.90), x4);
              df0 = lerp(df0, 2.2*float3(1.02, 0.99, 0.95), xE);
              df0 = lerp(df0, 2.2*float3(1.02, 0.99, 0.95), x5);
              df0 = lerp(df0, 1.95*float3(1.20, 0.99, 0.70), x6);
              df0 = lerp(df0, 1.80*float3(1.10, 0.95, 0.80), x7);
              df0 = lerp(df0, 0.80*float3(0.95, 0.92, 0.90), xG);	
              df0 = lerp(df0, 0.75*float3(0.90, 0.95, 1.02), xZ);	  
              df0 = lerp(df0, 0.70*float3(0.90, 0.95, 1.02), x8); 
              
       float3 df1 = 0.70;
       
        if (wx.x==2) df0 = df1; 
        if (wx.x==3) df0 = df1;   
        if (wx.x==4) df0 = df1;
        if (wx.x==7) df0 = df1;
        if (wx.x==8) df0 = df1;
        if (wx.x==9) df0 = df1;
        if (wx.x==12) df0 = df1;
        if (wx.x==15) df0 = df1;
        if (wx.x==16) df0 = df1;		
    
        
       float3 sh0 = lerp(0.70, 0.70, x1);
              sh0 = lerp(sh0, 0.70, x2);
              sh0 = lerp(sh0, 0.95, x3);
              sh0 = lerp(sh0, 0.95, x4);
              sh0 = lerp(sh0, 0.95, xE);
              sh0 = lerp(sh0, 0.95, x5);
              sh0 = lerp(sh0, 0.80, x6);
              sh0 = lerp(sh0, 0.80, x7);
              sh0 = lerp(sh0, 0.80, xG);	
              sh0 = lerp(sh0, 0.75, xZ);		  		  
              sh0 = lerp(sh0, 0.70, x8); 
              
    float3 shadowColor = float3(0.90, 0.93, 1.025);			  
        if (wx.x==4) shadowColor = 1.0;
        if (wx.x==7) shadowColor = 1.0;
        if (wx.x==8) shadowColor = 1.0;
        if (wx.x==9) shadowColor = 1.0;
        if (wx.x==12) shadowColor = 1.0;
        if (wx.x==15) shadowColor = 1.0;
        if (wx.x==16) shadowColor = 1.0;
    
    
        float3 Color0 = float3(1, 0.9, 0.75);
        float3 Color1 = float3(1.25, 1.25, 0.85);
        
         if (wx.x==2) Color0 = Color1;
         if (wx.x==3) Color0 = Color1;		 
         if (wx.x==4) Color0 = Color1;
         if (wx.x==7) Color0 = Color1;
         if (wx.x==8) Color0 = Color1;
         if (wx.x==9) Color0 = Color1;
         if (wx.x==12) Color0 = Color1;
         if (wx.x==15) Color0 = Color1;
         if (wx.x==16) Color0 = Color1;	
     
        float3 bl0 = lerp(0.0, 0.0, x1);
               bl0 = lerp(bl0, 0.0, x2);
               bl0 = lerp(bl0, 0.5*Color0, x3);
               bl0 = lerp(bl0, 1.5*Color0, x4);
               bl0 = lerp(bl0, 1.5*Color0, xE);
               bl0 = lerp(bl0, 0.75*Color0, x5);
               bl0 = lerp(bl0, 0.5*Color0, x6);
               bl0 = lerp(bl0, 0.3*Color0, x7);
               bl0 = lerp(bl0, 0.0, xG);		
               bl0 = lerp(bl0, 0.0, xZ);		  
               bl0 = lerp(bl0, 0.0, x8);
    
              
             
       float sp0 = lerp(0.0, 0.0, x1);
             sp0 = lerp(sp0, 0.0, x2);
             sp0 = lerp(sp0, 1.0, x3);
             sp0 = lerp(sp0, 1.0, x4);
             sp0 = lerp(sp0, 1.0, xE);
             sp0 = lerp(sp0, 1.0, x5);
             sp0 = lerp(sp0, 1.0, x6);
             sp0 = lerp(sp0, 1.0, x7);
             sp0 = lerp(sp0, 0.0, xG);	
             sp0 = lerp(sp0, 0.0, xZ);			 
             sp0 = lerp(sp0, 0.0, x8);	
             
        if (wx.x==2) sp0 = 0.0;
        if (wx.x==3) sp0 = 0.0;		 
        if (wx.x==4) sp0 = 0.0;
        if (wx.x==7) sp0 = 0.0;
        if (wx.x==8) sp0 = 0.0;
        if (wx.x==9) sp0 = 0.0;
        if (wx.x==12) sp0 = 0.0;
        if (wx.x==15) sp0 = 0.0;
        if (wx.x==16) sp0 = 0.0;			 
             
                
       float3 X2 = normalize(f+camdir);	
       float specular3 = pow(0.01-dot(npos.xyz, X2.xyz), 0.35);
             specular3 = pow(specular3, 50.0*1.8);
             specular3 = (specular3*specular3)*10.5;
             specular3/= 5.5*1.5; 	
             
        float df2 = 0.01*0.001 + dot(npos.xyz, X2);	
              df2 = pow(df2, 2500.0*2);
        float gl = (df2/0.01)* 0.01;
              gl = saturate(gl)*10.0;		   
               
         float4 ColorCar = PS.Diffuse;	
        float4 texel = tex2D(Sampler0, PS.TexCoord);
               texel.rgb*= ColorCar*float3(0.97, 1.0, 1.05);
               
        float texelA = saturate(texel.rgb);	
        float mix = lerp(0.7, 2.2, texelA);	
        float diff = saturate(0.1-dot(npos, -f)); 
              diff = pow(diff, 0.7);
    
        float3 sv3 = normalize(float3(0.0, 0.0, 0.7)+vView.xyz); 	
        float fresnelz = (0.05-dot(-sv3, npos));		
              fresnelz = pow(fresnelz, 5.0);
              fresnelz = fresnelz*fresnelz;
              fresnelz/= 2.5;	
              fresnelz*= 0.7;		  		  		  
              
        float3 lighting = lerp(sh0*shadowColor, df0, saturate(diff));			   
        
        float3 refl = reflect(vView, npos);	
        
        float4 CubeD = texCUBE(ReflDaySampler, -refl.xzy);
               CubeD*= 2.0;	
        float4 CubeDV = texCUBE(VReflDaySampler, -refl.xzy);
               CubeDV*= 2.1; //1
                   
        float3 CurrentRefl =  CubeDV.rgb;
    
        if (wx.x==0) CurrentRefl = CubeD.rgb;
        if (wx.x==1) CurrentRefl = CubeD.rgb;
        if (wx.x==2) CurrentRefl = CubeD.rgb;
        if (wx.x==3) CurrentRefl = CubeD.rgb;
        if (wx.x==4) CurrentRefl = CubeD.rgb;
        
        
        float4 CubeN = texCUBE(ReflNightSampler, -refl.xzy);
               CubeN.rgb*= 2.2*float3(0.82, 0.95, 1.05);
    
        float3 cb = lerp(CubeN.xyz, CubeN.xyz, x1);
               cb = lerp(cb, CubeN.xyz, x2);
               cb = lerp(cb, (CurrentRefl.xyz/1.4)*(ColorCar+1.5), x3);
               cb = lerp(cb, CurrentRefl.xyz, x6);
               cb = lerp(cb, CurrentRefl.xyz*0.85, x7);
               cb = lerp(cb, CurrentRefl.xyz*0.8, xG);		   
               cb = lerp(cb, CubeN.xyz, xZ);		   
               cb = lerp(cb, CubeN.xyz, x8);
               
        float3 n0 = normalize(cb.xyz);
        float3 ct0=cb.xyz/n0.xyz;
               ct0=pow(ct0,2.75);
               n0.xyz = pow(n0.xyz, 2.5);   
               cb.xyz = ct0*n0.xyz;  
               cb.xyz*= 0.6;			   
        
        float fresnel = 0.001*1.0-dot(npos, -camdir);		
              fresnel = saturate(pow(fresnel, 0.37*0.15));		  
                
       float m0 = lerp(0.20, 0.20, x1);
             m0 = lerp(m0, 0.10, x2);
             m0 = lerp(m0, 0.0, x3);
             m0 = lerp(m0, 0.0, x4);
             m0 = lerp(m0, 0.0, x5);
             m0 = lerp(m0, 0.0, x6);
             m0 = lerp(m0, 0.0, x7);		 
             m0 = lerp(m0, 0.20, x8);
            
        float3 MoonVector = normalize(float3(-0.00732, -0.39, 0.317));
        float m1 = saturate(0.001 + dot(normalize(-MoonVector-camdir), -npos.xyz));	
              m1 = pow(m1, 35.0);
        float3 moon = (m1*m1)*m0*2.0;		  
           
        float mix2 = lerp(0.9, 5.0, texelA);		 
        float4 texel2 = tex2D(Sampler0, PS.TexCoord);	
        
        float4 Lighting1 = ColorCar*PS.Light*0.9;
    
          float4 diffuse  = gDiffuseMaterialSource  == 0 ? ColorCar  : 1;
    
    /*	
      float3 CL1 = float3(0.6, 0.8, 1.1)*1.1;
      float3 CL2 = float3(0.9, 0.95, 1.0); 
      float3 CL0 = lerp(CL1, CL1, x1);
             CL0 = lerp(CL0, float3(0.65, 0.83, 1.05), x2);
             CL0 = lerp(CL0, CL2, x3);
             CL0 = lerp(CL0, 1.0, x4);
             CL0 = lerp(CL0, 1.0, xE);
             CL0 = lerp(CL0, 1.0, x5);
             CL0 = lerp(CL0, float3(0.90, 0.95, 1.0), x6);
             CL0 = lerp(CL0, float3(0.66, 0.84, 1.04)*0.9, x7);
             CL0 = lerp(CL0, CL1, x8);
             
      float3 CV0 = lerp(float3(0.75, 0.85, 1.0), float3(0.75, 0.85, 1.0), x1);
             CV0 = lerp(CV0, float3(0.75, 0.85, 1.0), x2);
             CV0 = lerp(CV0, 1.0, x3);
             CV0 = lerp(CV0, 1.0, x4);
             CV0 = lerp(CV0, 1.0, xE);
             CV0 = lerp(CV0, 1.0, x5);
             CV0 = lerp(CV0, 1.0, x6);
             CV0 = lerp(CV0, 1.0, x7);
             CV0 = lerp(CV0, float3(0.75, 0.85, 1.0), x8);		 
             
    
    float3 CurrentWeather = 1.0;
    
    if (wx.x==0) CurrentWeather = CL0;
    if (wx.x==1) CurrentWeather = CL0;
    if (wx.x==2) CurrentWeather = CL0;
    if (wx.x==3) CurrentWeather = CL0;
    if (wx.x==4) CurrentWeather = CL0; 	
    
    if (wx.x==7) CurrentWeather = CL0;
    if (wx.x==8) CurrentWeather = CL0;
    if (wx.x==9) CurrentWeather = CL0;
    
    if (wx.x==12) CurrentWeather = CL0;
    if (wx.x==15) CurrentWeather = CL0;
    if (wx.x==16) CurrentWeather = CL0;	  
    
    if (wx.x==5) CurrentWeather = CV0;
    if (wx.x==6) CurrentWeather = CV0;
     
    if (wx.x==10) CurrentWeather = CV0; 		 
    if (wx.x==11) CurrentWeather = CV0; 
    if (wx.x==13) CurrentWeather = CV0; 	
    if (wx.x==14) CurrentWeather = CV0; 
    if (wx.x==17) CurrentWeather = CV0; 
    */
        float Stg = ((texel.a <=0.9999) || PS.Material);
    
        float4 DiffAmb = PS.AmbC*2.0;
      if (Stg) DiffAmb = ColorCar*0.1;
           
        float4 finalColor2 = float4((DiffAmb.rgb+Lighting1.rgb)*texel2.rgb*0.9, min(diffuse.a, texel2.a));	
           
        float3 specmix2 = lerp(specular3*1.5, specular3*finalColor2*1.5, 0.80);	
            
    
       float factor3 = 0.1 - dot(-vView, npos);
             factor3 = pow(factor3, 0.65);
       float fr3 = (factor3*factor3); 
             fr3/= 2.5;	
             fr3 = saturate(fr3*2.6);	
             fr3 = lerp(1.0, fr3, 0.35);		
    
               finalColor2.rgb*= fr3;			
            
               finalColor2.rgb*= (lighting);				   
               finalColor2.rgb+= specmix2*bl0*0.7; 
               finalColor2.rgb+= moon*float3(0.85, 0.95, 1.1)*0.5;	
               finalColor2.rgb+= saturate(lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92)*0.7);				   
    
    
               
        //finalColor2.rgb+= lerp(lerp(fresnelz*2.4, finalColor2.xyz*fresnelz*1.2, 0.92), 0.0, saturate(lighting2));			
        //finalColor2.rgb+= lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92);		
        
        float fresnelx = 0.001-dot(-vView, npos);		
              fresnelx = saturate(pow(fresnelx, 0.37));
              fresnelx = lerp(1.0, 0.0, 0.92*fresnelx);	
    
       float sp1 = lerp(0.2, 0.2, x1);
             sp1 = lerp(sp1, 0.2, x2);
             sp1 = lerp(sp1, 0.6, x3);
             sp1 = lerp(sp1, 0.8, x4);
             sp1 = lerp(sp1, 0.9, x5);
             sp1 = lerp(sp1, 0.6, x6);
             sp1 = lerp(sp1, 0.5, x7);
             sp1 = lerp(sp1, 0.2, xG);	
             sp1 = lerp(sp1, 0.2, xZ);			 
             sp1 = lerp(sp1, 0.2, x8);	
                         
    
               
        
      float3 v = {0.6, 0.6, 0.95};
      float3 v2 = {0.9, 0.9, 1.0};  
      
      float3 n = normalize(npos.xyz*v);		 
      float3 ref0 = reflect(vView.xyz, n.xyz);		 
      //float3 n1 = ((1000.0/0.01)*n0)/1000.0;		
      float3 ref2 = (1.0*ref0)/0.5;	  
      
      float3 r0 = (vView.xyz+ref2)*0.95;	
      float2 r1 = wpd2(r0.xyz);		
        
        float2 rc = r1.xy;		
        
        float4 envMap = tex2D(SamplerColor, rc);
               envMap.w = rc.y<0.0||rc.y>1.0 ? 0.0:1.0; 
               envMap.w*= rc.x<0.0||rc.x>1.0 ? 0.0:1.0;
    
        float c08 = 6.7;
        float c07 = 1.0;
    
        float nf02 = saturate(c08*(r1.y));
              nf02*= saturate(c08*(r1.x));					
              nf02 = pow(nf02, c07);			
        float nf03 = saturate(c08+r1.y*(-c08));
              nf03*= saturate(c08+r1.x*(-c08));					
              nf03 = pow(nf03, c07);
        
        float fresnelR = 0.01-dot(npos, -camdir);		
              fresnelR = saturate(pow(fresnelR, 4.0));	
    
                cb = lerp(cb, envMap.xyz*3.3,  envMap.w*nf02*nf03*pow(0.01*0.5, fresnelR));	
        float3 reflection = lerp(1.12*cb+(gl*sp0*4.0), finalColor2.rgb, 0.97*fresnel);
    
        //float3 AtmSky = getSky(GameTime, wx, wpos, wpos2);	
               
               finalColor2.rgb = lerp(finalColor2.rgb+fresnelx*0.27*sp1*float3(0.92, 0.96, 1.0), reflection, Stg); //
               
        //finalColor2.rgb = GetCorrection(finalColor2.rgb*2.0);		   
    
               
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////  Снег  ////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
        float4 objspacepos	= PS.invTex;
        // Triplanar uvs
        float2 uvX = objspacepos.yz; // x facing plane
        float2 uvY = objspacepos.xz; // y facing plane	
        float2 uvZ = objspacepos.xy; // z facing plane   
    
        float3 wnorm = normalize(cross(ddx(objspacepos.xyz),ddy(objspacepos.xyz)));  
    
        float3 blending = pow(abs(wnorm.xyz), 3.0);
                blending = blending / (blending.x + blending.y + blending.z);	
               
        float3 blending2 = pow(abs(npos.xyz*float3(22.0, 22.0, 10.0)), 2.2);
                blending2 = blending2 / (blending2.x + blending2.y + blending2.z);		
                      
            float3 R1x = tex2D(SamplerSnow, uvX);
            float3 R1y = tex2D(SamplerSnow, uvY);		
            float3 R1z = tex2D(SamplerSnow, uvZ);
    
            float3 Ax = tex2D(SamplerSnowA, uvX);
            float3 Ay = tex2D(SamplerSnowA, uvY);		
            float3 Az = tex2D(SamplerSnowA, uvZ);
            
            float3 Shx = tex2D(SamplerShine, uvX);
            float3 Shy = tex2D(SamplerShine, uvY);		
            float3 Shz = tex2D(SamplerShine, uvZ);	
            
        float ShineMix = Shx*blending.x + Shy*blending.y + Shz*blending.z; 		   
    
        float3 vw = normalize(float3(0,0,1));
        float sAl = saturate(0.01-dot(vw, -npos));
              sAl = pow(sAl, 0.2);	//1		   
    
              
        float3 SnowMix = R1x*blending.x + R1y*blending.y + R1z*blending.z; 	 		
        float SnowMixA = Ax*blending.x + Ay*blending.y + Az*blending.z; 
    
        float Glass = pow(ColorCar.a, 0.5);
        float3 Lighting2 = PS.Light*0.9; 
        
       float3 dfsn = lerp(0.45*float3(0.78, 0.90, 1.02), 0.45*float3(0.78, 0.90, 1.02), x1);
              dfsn = lerp(dfsn, 0.8*float3(0.90, 0.95, 1.02), x2);
              dfsn = lerp(dfsn, 1.05*float3(1.0, 0.99, 0.95), x3);
              dfsn = lerp(dfsn, 1.11*float3(1.0, 0.99, 0.95), x4);
              dfsn = lerp(dfsn, 1.15*float3(1.02, 0.99, 0.95), xE);
              dfsn = lerp(dfsn, 1.15*float3(1.02, 0.99, 0.95), x5);
              dfsn = lerp(dfsn, 1.12*float3(1.05, 0.90, 0.80), x6);
              dfsn = lerp(dfsn, 0.9*float3(0.93, 0.90, 0.95), x7);
              dfsn = lerp(dfsn, 0.6*float3(0.90, 0.95, 1.02), xG);	
              dfsn = lerp(dfsn, 0.5*float3(0.90, 0.95, 1.02), xZ);			  
              dfsn = lerp(dfsn, 0.45*float3(0.82, 0.90, 1.02), x8); 
              
       float3 dfn = lerp(0.45*float3(0.92, 0.96, 1.03), 0.45*float3(0.92, 0.96, 1.03), x1);
              dfn = lerp(dfn, 0.52*float3(0.92, 0.96, 1.02), x2);
              dfn = lerp(dfn, 0.8*float3(0.95, 0.97, 1.00), x3);
              dfn = lerp(dfn, 0.85, x4);
              dfn = lerp(dfn, 0.85, xE);
              dfn = lerp(dfn, 0.85, x5);
              dfn = lerp(dfn, 0.85, x6);
              dfn = lerp(dfn, 0.7*float3(0.94, 0.96, 1.01), x7);
              dfn = lerp(dfn, 0.6*float3(0.92, 0.96, 1.02), xG);	
              dfn = lerp(dfn, 0.5*float3(0.90, 0.96, 1.02), xZ);			  
              dfn = lerp(dfn, 0.45*float3(0.90, 0.96, 1.02), x8); 		  
              dfn*=float3(0.92, 0.96, 1.03);
    
        if (wx.x==2) dfsn = dfn;
        if (wx.x==3) dfsn = dfn;		  
        if (wx.x==4) dfsn = dfn;
        if (wx.x==7) dfsn = dfn;
        if (wx.x==8) dfsn = dfn;
        if (wx.x==9) dfsn = dfn;
        if (wx.x==12) dfsn = dfn;
        if (wx.x==15) dfsn = dfn;
        if (wx.x==16) dfsn = dfn;	
              
     if (Stg) finalColor2.rgb+= lerp(0.025, 1.6*(moon*float3(0.85, 0.95, 1.1)*3.5) + specular3*bl0*4.5, (ShineMix*0.2)*saturate(blending2.z+SnowMixA*2.0*blending2.z)*Glass*sAl);
    
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////  Снег  ////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    
    float3 TM0 = GetCorrection(finalColor2.rgb*0.9);
	float3 TM1 = Uncharted2Tonemap(finalColor2.rgb*0.9);	
	       finalColor2.rgb = lerp(TM0, TM1, 0.75);			   
	
           finalColor2.rgb = saturate(finalColor2.rgb);
           finalColor2.rgb = pow(finalColor2.rgb, 1.2);

           finalColor2.a*= ColorCar.a; //1
    return finalColor2;
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////RADMIR/////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////
    
    technique tec0
    {
        pass P0
        {
            VertexShader = compile vs_3_0 VertexShaderFunction();	
            PixelShader = compile ps_3_0 PS_Reflection();
        }
    }
    
    // Fallback
    technique fallback
    {
        pass P0
        {
            // Just draw normally
        }
    }
]]

matte_chameleon = [[//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++      _________           __         __________       __               __    __  __      _________       +++++//
//+++++     |XX|X X XX|          XX        |HH|HHH\HHH\     |XX              |XX|  |XX||XX|    |XX|X X XX|      +++++//
//+++++     |XX|    |XX|        /XX\       |HH|      \HH\   |XX||XX|     |XX||XX|    |XX|      |XX|    |XX|     +++++//
//+++++     |XX|    |XX|       /XXXX\      |HH|       |HH|  |XX| |XX|   |XX| |XX|    |XX|      |XX|    |XX|     +++++//
//+++++     |XX|   |XX|       /XX/\XX\     |HH|       |HH|  |XX|  |XX| |XX|  |XX|    |XX|      |XX|   |XX|      +++++//
//+++++     |XX|X X X|       /XX/  \XX\    |HH|       |HH|  |XX|     |XX|    |XX|    |XX|      |XX|X X X|       +++++//
//+++++     |XX|   \XX\     /XXXXXXXXXX\   |HH|       |HH|  |XX|             |XX|    |XX|      |XX|   \XX\      +++++//
//+++++     |XX|    \XX\   /XX/      \XX\  |HH|      /HH/   |XX|             |XX|    |XX|      |XX|    \XX\     +++++//
//+++++     |XX|    |XX|  /XX/        \XX\ |HH|    /HHH/    |XX|             |XX|    |XX|      |XX|     |XX|    +++++//
//+++++     |XX|    |XX| /XX/          \XX\|HHHHHHHHH/      |XX|             |XX|  |XX||XX|    |XX|     |XX|    +++++// 
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

//---------------------------------------------------------------------
// ...
//---------------------------------------------------------------------
//int gGameTimeHours : GAME_TIME_HOURS;
//int gGameTimeMinutes : GAME_TIME_MINUTES;
//int gWeather : WEATHER;
//int gStage1ColorOp < string stageState="1,COLOROP"; >;

float2 sEffectFade = float2(50, 40);
float4 paintColor2;
//---------------------------------------------------------------------
// Textures
//---------------------------------------------------------------------
texture gScreenSource : SCREEN_SOURCE;
texture gDepthBuffer : DEPTHBUFFER;

texture sReflDay;
texture sReflNight;
texture sSnow;
texture sSnowA;
texture sShine;
texture sReflDayV;
//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
#include "radmir.fx"
//---------------------------------------------------------------------
// Sampler
//---------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
};

sampler SamplerDepth = sampler_state
{
    Texture = (gDepthBuffer);
    AddressU = Clamp;
    AddressV = Clamp;
};

samplerCUBE VReflDaySampler = sampler_state
{
	Texture = (sReflDay);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE; //FALSE		
    MaxMipLevel=0;
    MipMapLodBias=0;
};

samplerCUBE ReflDaySampler = sampler_state
{
	Texture = (sReflDay);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE;		
    MaxMipLevel=0;
    MipMapLodBias=0;
};

samplerCUBE ReflNightSampler = sampler_state
{
	Texture = (sReflNight);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE;//FALSE
    MaxMipLevel=0;
    MipMapLodBias=0;
};

sampler2D SamplerSnow = sampler_state
{
   Texture   = <sSnow>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerSnowA = sampler_state
{
   Texture   = <sSnowA>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerShine = sampler_state
{
   Texture   = <sShine>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler SamplerColor = sampler_state
{
    Texture = (gScreenSource);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU  = Clamp;
	AddressV  = Clamp;
	SRGBTexture=FALSE;	
};

//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
	float3 Normal : NORMAL0;
	
    float4 Color : COLOR0;	
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
	float4 Position2 : POSITION1;	
    float2 TexCoord : TEXCOORD0;
    float4 Color : COLOR0;
	float4 AmbC : TEXCOORD1;
    float4 invTex : TEXCOORD2;
    float3 Material : TEXCOORD3;	
    float3 Normal : TEXCOORD4;
    float4 View : TEXCOORD5;
    float4 Light : TEXCOORD6;	
    float4 Diffuse : TEXCOORD7;		
};


////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

   // FixUpNormal( VS.Normal );
	
    // Set information to do specular calculation
    float3 Normal = mul(VS.Normal, (float3x3)gWorld);
    PS.Normal = Normal;
    Normal = normalize(Normal);	

    float4 worldPos = mul( float4(VS.Position.xyz,1) , gWorld );

	PS.Position = mul(float4(VS.Position.xyz , 1.0), gWorldViewProjection);
	PS.Position2 = PS.Position;
	
    PS.AmbC = gMaterialAmbient;
    PS.Material = AlphaMaterial();
    PS.View.xyz = gCameraPosition - worldPos.xyz;
	
    //PS.Color = CalcGTACompleteDiffuse(Normal, VS.Color);
    PS.Diffuse = gMaterialDiffuse;	
	PS.Light = CalcGTADynamicDiffuse(Normal); //1
	PS.TexCoord.xy = VS.TexCoord.xy;

    float refMask = pow(2 * dot(Normal, normalize(PS.View.xyz)), 3);
    PS.View.w = saturate(1 - refMask) * pow(dot(Normal, float3(0,0,1)), 1);

    float4x4 gWVPI =  inverse(gWorldViewProjection);
	float4 objspacepos	= mul(PS.Position2, gWVPI);
	       objspacepos.xyz/=objspacepos.w;
		   
    PS.invTex = objspacepos;
/**/	
    // Distance fade calculation
    float DistanceFromCamera = distance(gCameraPosition, worldPos.xyz);
    PS.View.w *= saturate(1 - ((DistanceFromCamera - sEffectFade.y) / (sEffectFade.x - sEffectFade.y)));
	
    return PS;
}

float3 GetCorrection(float3 color)
{
	float3 n0 = normalize(color.xyz);
	float3 ct0=color.xyz/n0.xyz;
	       ct0=pow(ct0, 1.0);
           n0.xyz = pow(n0.xyz, 1.1);   
           color.xyz = ct0*n0.xyz;  
           color.xyz*= 1.0;
	 
	float mC = max(color.x, max(color.y, color.z));		 		 
	float3 x1 = 1.0 - exp(-mC);	
	float3 rg =  float3(x1.x, x1.y, x1.z);
	float3 x2 = 1.0 - exp(-color);	
	float3 rg2 =  float3(x2.x, x2.y, x2.z);	
		 
	float mm = rg;
	float3 c1 = color * mm / mC;
	float3 p2 = rg2;
	color.xyz = lerp(p2, c1, 0.2);		 

	return color;	
}

float3 Uncharted2Tonemap(float3 x)
{
    float A = 1.0;
	float B = 0.25;
	float C = 0.52;
	float D = 0.34;
	float E = 0.0;
	float F = 1.0;

    return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
}

/*
*/

float2 wpd2(float3 cd)
{
   float4 tv = float4(cd.xyz, 1.0);
   float4 wp = mul(tv, gViewInverseTranspose);
		  //wp.xyz/= wp.w;   
		  
		  wp.x = -wp.x;  		  
		  wp.xy = wp.xy*0.0+0.0;
   return wp.xy;
}

////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

float4 PS_Reflection(PSInput PS) : COLOR0
{
    float3 vView = normalize(PS.View.xyz);	

	float wx = gWeather;
	
    float  wpos2 = length(vView.xyz);
    float3 camdir = vView.xyz / wpos2;	
    float3 npos = normalize(PS.Normal);
	
  float hourMinutes = (1 / 59) * 15;
  float GameTime = 15 + hourMinutes;

   float t0 = GameTime;
   float x1 = smoothstep(0.0, 4.0, t0);
   float x2 = smoothstep(4.0, 5.0, t0);
   float x3 = smoothstep(5.0, 6.0, t0);
   float x4 = smoothstep(6.0, 7.0, t0);
   float xE = smoothstep(8.0, 11.0, t0);
   float x5 = smoothstep(16.0, 17.0, t0);
   float x6 = smoothstep(18.0, 19.0, t0);
   float x7 = smoothstep(19.0, 20.0, t0);
   float xG = smoothstep(20.0, 21.0, t0);  
   float xZ = smoothstep(21.0, 22.0, t0);
   float x8 = smoothstep(22.0, 24.0, t0);	
   
 //SunDirection--------------------
float3  f = lerp(float3(0.,0.,-.61), float3(.583,-.257,-.0108), smoothstep(0.,5.,GameTime));
        f = lerp(f, float3(.569,-.242,.151), smoothstep(5.,7.,GameTime));
		f = lerp(f, float3(.49,-.247,.323), smoothstep(7.,9.,GameTime));
		f = lerp(f, float3(.373,-.262,.445), smoothstep(9.,11.,GameTime));
		f = lerp(f, float3(.201,-.312,.517), smoothstep(11.,13.,GameTime));
		f = lerp(f, float3(-.00732,-.39,.503), smoothstep(13.,15.,GameTime));
		f = lerp(f, float3(-.189,-.502,.343), smoothstep(15.,17.,GameTime));
		f = lerp(f, float3(-.223,-.594,.1), smoothstep(17.,19.,GameTime));
		f = lerp(f, float3(0.,0.,-.61), smoothstep(19.,24.,GameTime));
		f = normalize(f);  	
		
   float3 df0 = lerp(0.70*float3(0.90, 0.95, 1.02), 0.70*float3(0.90, 0.95, 1.02), x1);
          df0 = lerp(df0, 0.72*float3(0.90, 0.95, 1.02), x2);
          df0 = lerp(df0, 1.75*float3(1.15, 0.95, 0.75), x3);
          df0 = lerp(df0, 2.1*float3(1.10, 0.99, 0.90), x4);
          df0 = lerp(df0, 2.2*float3(1.02, 0.99, 0.95), xE);
          df0 = lerp(df0, 2.2*float3(1.02, 0.99, 0.95), x5);
          df0 = lerp(df0, 1.95*float3(1.20, 0.99, 0.70), x6);
          df0 = lerp(df0, 1.80*float3(1.10, 0.95, 0.80), x7);
          df0 = lerp(df0, 0.80*float3(0.95, 0.92, 0.90), xG);	
          df0 = lerp(df0, 0.75*float3(0.90, 0.95, 1.02), xZ);	  
          df0 = lerp(df0, 0.70*float3(0.90, 0.95, 1.02), x8); 
		  
   float3 df1 = 0.70;
   
    if (wx.x==2) df0 = df1; 
    if (wx.x==3) df0 = df1;   
    if (wx.x==4) df0 = df1;
    if (wx.x==7) df0 = df1;
    if (wx.x==8) df0 = df1;
    if (wx.x==9) df0 = df1;
    if (wx.x==12) df0 = df1;
    if (wx.x==15) df0 = df1;
    if (wx.x==16) df0 = df1;		

	
   float3 sh0 = lerp(0.70, 0.70, x1);
          sh0 = lerp(sh0, 0.70, x2);
          sh0 = lerp(sh0, 0.95, x3);
          sh0 = lerp(sh0, 0.95, x4);
          sh0 = lerp(sh0, 0.95, xE);
          sh0 = lerp(sh0, 0.95, x5);
          sh0 = lerp(sh0, 0.80, x6);
          sh0 = lerp(sh0, 0.80, x7);
          sh0 = lerp(sh0, 0.80, xG);	
          sh0 = lerp(sh0, 0.75, xZ);		  		  
          sh0 = lerp(sh0, 0.70, x8); 
		  
float3 shadowColor = float3(0.90, 0.93, 1.025);			  
    if (wx.x==4) shadowColor = 1.0;
    if (wx.x==7) shadowColor = 1.0;
    if (wx.x==8) shadowColor = 1.0;
    if (wx.x==9) shadowColor = 1.0;
    if (wx.x==12) shadowColor = 1.0;
    if (wx.x==15) shadowColor = 1.0;
    if (wx.x==16) shadowColor = 1.0;


    float3 Color0 = float3(1, 0.9, 0.75);
    float3 Color1 = float3(1.25, 1.25, 0.85);
    
     if (wx.x==2) Color0 = Color1;
     if (wx.x==3) Color0 = Color1;		 
     if (wx.x==4) Color0 = Color1;
     if (wx.x==7) Color0 = Color1;
     if (wx.x==8) Color0 = Color1;
     if (wx.x==9) Color0 = Color1;
     if (wx.x==12) Color0 = Color1;
     if (wx.x==15) Color0 = Color1;
     if (wx.x==16) Color0 = Color1;	
 
    float3 bl0 = lerp(0.0, 0.0, x1);
           bl0 = lerp(bl0, 0.0, x2);
           bl0 = lerp(bl0, 0.5*Color0, x3);
           bl0 = lerp(bl0, 1.5*Color0, x4);
           bl0 = lerp(bl0, 1.5*Color0, xE);
           bl0 = lerp(bl0, 0.75*Color0, x5);
           bl0 = lerp(bl0, 0.5*Color0, x6);
           bl0 = lerp(bl0, 0.3*Color0, x7);
           bl0 = lerp(bl0, 0.0, xG);		
           bl0 = lerp(bl0, 0.0, xZ);		  
           bl0 = lerp(bl0, 0.0, x8);

		  
		 
   float sp0 = lerp(0.0, 0.0, x1);
         sp0 = lerp(sp0, 0.0, x2);
         sp0 = lerp(sp0, 1.0, x3);
         sp0 = lerp(sp0, 1.0, x4);
         sp0 = lerp(sp0, 1.0, xE);
         sp0 = lerp(sp0, 1.0, x5);
         sp0 = lerp(sp0, 1.0, x6);
         sp0 = lerp(sp0, 1.0, x7);
         sp0 = lerp(sp0, 0.0, xG);	
         sp0 = lerp(sp0, 0.0, xZ);			 
         sp0 = lerp(sp0, 0.0, x8);	
		 
    if (wx.x==2) sp0 = 0.0;
    if (wx.x==3) sp0 = 0.0;		 
    if (wx.x==4) sp0 = 0.0;
    if (wx.x==7) sp0 = 0.0;
    if (wx.x==8) sp0 = 0.0;
    if (wx.x==9) sp0 = 0.0;
    if (wx.x==12) sp0 = 0.0;
    if (wx.x==15) sp0 = 0.0;
    if (wx.x==16) sp0 = 0.0;			 
		 
 		   
   float3 X2 = normalize(f+camdir);	
   float specular3 = pow(0.01-dot(npos.xyz, X2.xyz), 2.35);
         specular3 = pow(specular3, 50.0*1.8);
         specular3 = (specular3*specular3)*10.5;
         specular3/= 5.5*1.5; 	
		 
    float df2 = 0.01*0.001 + dot(npos.xyz, X2);	
		  df2 = pow(df2, 2500.0*2);
	float gl = (df2/0.01)* 0.01;
          gl = saturate(gl)*0.0;		   
		   
 	float4 ColorCar = PS.Diffuse;	
    float4 texel = tex2D(Sampler0, PS.TexCoord);
	       texel.rgb*= ColorCar*float3(0.97, 1.0, 1.05);
		   
    float texelA = saturate(texel.rgb);	
    float mix = lerp(0.7, 2.2, texelA);	
    float diff = saturate(0.1-dot(npos, -f)); 
		  diff = pow(diff, 0.7);

    float3 sv3 = normalize(float3(0.0, 0.0, 0.7)+vView.xyz); 	
	float fresnelz = (0.05-dot(-sv3, npos));		
		  fresnelz = pow(fresnelz, 5.0);
		  fresnelz = fresnelz*fresnelz;
          fresnelz/= 2.5;	
          fresnelz*= 0.7;		  		  		  
		  
	float3 lighting = lerp(sh0*shadowColor, df0, saturate(diff));			   
	
    float3 refl = reflect(vView, npos);	
	
    float4 CubeD = texCUBE(ReflDaySampler, -refl.xzy);
	       CubeD*= 2.0;	
    float4 CubeDV = texCUBE(VReflDaySampler, -refl.xzy);
	       CubeDV*= 2.1; //1
			   
	float3 CurrentRefl =  CubeDV.rgb;

	if (wx.x==0) CurrentRefl = CubeD.rgb;
	if (wx.x==1) CurrentRefl = CubeD.rgb;
	if (wx.x==2) CurrentRefl = CubeD.rgb;
	if (wx.x==3) CurrentRefl = CubeD.rgb;
	if (wx.x==4) CurrentRefl = CubeD.rgb;
	
	
    float4 CubeN = texCUBE(ReflNightSampler, -refl.xzy);
	       CubeN.rgb*= 2.2*float3(0.82, 0.95, 1.05);

	float3 cb = lerp(CubeN.xyz, CubeN.xyz, x1);
		   cb = lerp(cb, CubeN.xyz, x2);
		   cb = lerp(cb, ((CurrentRefl.xyz)+(paintColor2*1.25)), x3);
		   cb = lerp(cb, CurrentRefl.xyz*(paintColor2*0.5), x6);
		   cb = lerp(cb, CurrentRefl.xyz*0.85+(paintColor2*0.5), x7);
		   cb = lerp(cb, CurrentRefl.xyz*0.8, xG);		   
		   cb = lerp(cb, CubeN.xyz, xZ);		   
		   cb = lerp(cb, CubeN.xyz, x8);
		   
	float3 n0 = normalize(cb.xyz);
	float3 ct0=cb.xyz/n0.xyz;
	       ct0=pow(ct0, 2.0);
           n0.xyz = pow(n0.xyz, 1.8);   
           cb.xyz = ct0*n0.xyz;  
           cb.xyz*= 1.25;			   
	
	float fresnel = 0.001*1.0-dot(npos, -camdir);		
		  fresnel = saturate(pow(fresnel, 0.37*0.15));		  
  		  
   float m0 = lerp(0.20, 0.20, x1);
         m0 = lerp(m0, 0.10, x2);
         m0 = lerp(m0, 0.0, x3);
         m0 = lerp(m0, 0.0, x4);
         m0 = lerp(m0, 0.0, x5);
         m0 = lerp(m0, 0.0, x6);
         m0 = lerp(m0, 0.0, x7);		 
         m0 = lerp(m0, 0.20, x8);
		
    float3 MoonVector = normalize(float3(-0.00732, -0.39, 0.317));
    float m1 = saturate(0.001 + dot(normalize(-MoonVector-camdir), -npos.xyz));	
		  m1 = pow(m1, 35.0);
    float3 moon = (m1*m1)*m0*2.0;		  
	   
    float mix2 = lerp(0.9, 5.0, texelA);		 
    float4 texel2 = tex2D(Sampler0, PS.TexCoord);	
	
	float4 Lighting1 = ColorCar*PS.Light*0.9;

  	float4 diffuse  = gDiffuseMaterialSource  == 0 ? ColorCar  : 1;

/*	
  float3 CL1 = float3(0.6, 0.8, 1.1)*1.1;
  float3 CL2 = float3(0.9, 0.95, 1.0); 
  float3 CL0 = lerp(CL1, CL1, x1);
         CL0 = lerp(CL0, float3(0.65, 0.83, 1.05), x2);
         CL0 = lerp(CL0, CL2, x3);
         CL0 = lerp(CL0, 1.0, x4);
         CL0 = lerp(CL0, 1.0, xE);
         CL0 = lerp(CL0, 1.0, x5);
         CL0 = lerp(CL0, float3(0.90, 0.95, 1.0), x6);
         CL0 = lerp(CL0, float3(0.66, 0.84, 1.04)*0.9, x7);
         CL0 = lerp(CL0, CL1, x8);
		 
  float3 CV0 = lerp(float3(0.75, 0.85, 1.0), float3(0.75, 0.85, 1.0), x1);
         CV0 = lerp(CV0, float3(0.75, 0.85, 1.0), x2);
         CV0 = lerp(CV0, 1.0, x3);
         CV0 = lerp(CV0, 1.0, x4);
         CV0 = lerp(CV0, 1.0, xE);
         CV0 = lerp(CV0, 1.0, x5);
         CV0 = lerp(CV0, 1.0, x6);
         CV0 = lerp(CV0, 1.0, x7);
         CV0 = lerp(CV0, float3(0.75, 0.85, 1.0), x8);		 
		 

float3 CurrentWeather = 1.0;

if (wx.x==0) CurrentWeather = CL0;
if (wx.x==1) CurrentWeather = CL0;
if (wx.x==2) CurrentWeather = CL0;
if (wx.x==3) CurrentWeather = CL0;
if (wx.x==4) CurrentWeather = CL0; 	

if (wx.x==7) CurrentWeather = CL0;
if (wx.x==8) CurrentWeather = CL0;
if (wx.x==9) CurrentWeather = CL0;

if (wx.x==12) CurrentWeather = CL0;
if (wx.x==15) CurrentWeather = CL0;
if (wx.x==16) CurrentWeather = CL0;	  

if (wx.x==5) CurrentWeather = CV0;
if (wx.x==6) CurrentWeather = CV0;
 
if (wx.x==10) CurrentWeather = CV0; 		 
if (wx.x==11) CurrentWeather = CV0; 
if (wx.x==13) CurrentWeather = CV0; 	
if (wx.x==14) CurrentWeather = CV0; 
if (wx.x==17) CurrentWeather = CV0; 
*/
    float Stg = ((texel.a <=0.9999) || PS.Material);

    float4 DiffAmb = PS.AmbC*2.0;
  if (Stg) DiffAmb = (ColorCar*0.3);
	   
	float4 finalColor2 = float4((DiffAmb.rgb+Lighting1.rgb)*texel2.rgb*0.9, min(diffuse.a, texel2.a));	
	   
    float3 specmix2 = lerp(specular3*1.5, specular3*finalColor2*1.5, 0.80);	
		

   float factor3 = 0.1 - dot(-vView, npos);
         factor3 = pow(factor3, 0.65);
   float fr3 = (factor3*factor3); 
         fr3/= 2.5;	
         fr3 = saturate(fr3*0.6);	
         fr3 = lerp(1.0, fr3, 0.65);		

           finalColor2.rgb*= fr3;			
		
           finalColor2.rgb*= (lighting);				   
           finalColor2.rgb+= specmix2*bl0*0.7; 
           finalColor2.rgb+= moon*float3(0.85, 0.95, 1.1)*0.5;	
           finalColor2.rgb+= saturate(lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92)*0.7);				   


		   
    //finalColor2.rgb+= lerp(lerp(fresnelz*2.4, finalColor2.xyz*fresnelz*1.2, 0.92), 0.0, saturate(lighting2));			
    //finalColor2.rgb+= lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92);		
	
	float fresnelx = 0.001-dot(-vView, npos);		
		  fresnelx = saturate(pow(fresnelx, 0.37));
		  fresnelx = lerp(1.0, 0.0, 0.92*fresnelx);	

   float sp1 = lerp(0.2, 0.2, x1);
         sp1 = lerp(sp1, 0.2, x2);
         sp1 = lerp(sp1, 0.6, x3);
         sp1 = lerp(sp1, 0.8, x4);
         sp1 = lerp(sp1, 0.9, x5);
         sp1 = lerp(sp1, 0.6, x6);
         sp1 = lerp(sp1, 0.5, x7);
         sp1 = lerp(sp1, 0.2, xG);	
         sp1 = lerp(sp1, 0.2, xZ);			 
         sp1 = lerp(sp1, 0.2, x8);	
		  		   

		   
	
  float3 v = {0.6, 0.6, 0.95};
  float3 v2 = {0.9, 0.9, 1.0};  
  
  float3 n = normalize(npos.xyz*v);		 
  float3 ref0 = reflect(vView.xyz, n.xyz);		 
  //float3 n1 = ((1000.0/0.01)*n0)/1000.0;		
  float3 ref2 = (1.0*ref0)/0.5;	  
  
  float3 r0 = (vView.xyz+ref2)*0.95;	
  float2 r1 = wpd2(r0.xyz);		
	
	float2 rc = r1.xy;		
	
    float4 envMap = tex2D(SamplerColor, rc);
	       envMap.w = rc.y<0.0||rc.y>1.0 ? 0.0:1.0; 
	       envMap.w*= rc.x<0.0||rc.x>1.0 ? 0.0:1.0;

	float c08 = 6.7;
	float c07 = 1.0;

	float nf02 = saturate(c08*(r1.y));
          nf02*= saturate(c08*(r1.x));					
	      nf02 = pow(nf02, c07);			
	float nf03 = saturate(c08+r1.y*(-c08));
          nf03*= saturate(c08+r1.x*(-c08));					
	      nf03 = pow(nf03, c07);
	
	float fresnelR = 0.01-dot(npos, -camdir);		
		  fresnelR = saturate(pow(fresnelR, 4.0));	

		    cb = lerp(cb, envMap.xyz*3.3,  envMap.w*nf02*nf03*pow(0.01*0.5, fresnelR));	
    float3 reflection = lerp(1.12*cb+(gl*sp0*4.0), finalColor2.rgb, 0.97*fresnel);

    //float3 AtmSky = getSky(GameTime, wx, wpos, wpos2);	
		   
           finalColor2.rgb = lerp(finalColor2.rgb+fresnelx*0.27*sp1*float3(0.92, 0.96, 1.0), reflection, Stg); //
		   
    //finalColor2.rgb = GetCorrection(finalColor2.rgb*2.0);		   

		   
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////  Снег  ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
	float4 objspacepos	= PS.invTex;
	// Triplanar uvs
    float2 uvX = objspacepos.yz; // x facing plane
    float2 uvY = objspacepos.xz; // y facing plane	
    float2 uvZ = objspacepos.xy; // z facing plane   

	float3 wnorm = normalize(cross(ddx(objspacepos.xyz),ddy(objspacepos.xyz)));  

    float3 blending = pow(abs(wnorm.xyz), 3.0);
 	       blending = blending / (blending.x + blending.y + blending.z);	
		   
    float3 blending2 = pow(abs(npos.xyz*float3(22.0, 22.0, 10.0)), 2.2);
 	       blending2 = blending2 / (blending2.x + blending2.y + blending2.z);		
		   	   
		float3 R1x = tex2D(SamplerSnow, uvX);
		float3 R1y = tex2D(SamplerSnow, uvY);		
		float3 R1z = tex2D(SamplerSnow, uvZ);

		float3 Ax = tex2D(SamplerSnowA, uvX);
		float3 Ay = tex2D(SamplerSnowA, uvY);		
		float3 Az = tex2D(SamplerSnowA, uvZ);
		
		float3 Shx = tex2D(SamplerShine, uvX);
		float3 Shy = tex2D(SamplerShine, uvY);		
		float3 Shz = tex2D(SamplerShine, uvZ);	
		
	float ShineMix = Shx*blending.x + Shy*blending.y + Shz*blending.z; 		   

    float3 vw = normalize(float3(0,0,1));
    float sAl = saturate(0.01-dot(vw, -npos));
		  sAl = pow(sAl, 0.2);	//1		   

		  
	float3 SnowMix = R1x*blending.x + R1y*blending.y + R1z*blending.z; 	 		
	float SnowMixA = Ax*blending.x + Ay*blending.y + Az*blending.z; 

	float Glass = pow(ColorCar.a, 0.5);
	float3 Lighting2 = PS.Light*0.9; 
	
   float3 dfsn = lerp(0.45*float3(0.78, 0.90, 1.02), 0.45*float3(0.78, 0.90, 1.02), x1);
          dfsn = lerp(dfsn, 0.8*float3(0.90, 0.95, 1.02), x2);
          dfsn = lerp(dfsn, 1.05*float3(1.0, 0.99, 0.95), x3);
          dfsn = lerp(dfsn, 1.11*float3(1.0, 0.99, 0.95), x4);
          dfsn = lerp(dfsn, 1.15*float3(1.02, 0.99, 0.95), xE);
          dfsn = lerp(dfsn, 1.15*float3(1.02, 0.99, 0.95), x5);
          dfsn = lerp(dfsn, 1.12*float3(1.05, 0.90, 0.80), x6);
          dfsn = lerp(dfsn, 0.9*float3(0.93, 0.90, 0.95), x7);
          dfsn = lerp(dfsn, 0.6*float3(0.90, 0.95, 1.02), xG);	
          dfsn = lerp(dfsn, 0.5*float3(0.90, 0.95, 1.02), xZ);			  
          dfsn = lerp(dfsn, 0.45*float3(0.82, 0.90, 1.02), x8); 
		  
   float3 dfn = lerp(0.45*float3(0.92, 0.96, 1.03), 0.45*float3(0.92, 0.96, 1.03), x1);
          dfn = lerp(dfn, 0.52*float3(0.92, 0.96, 1.02), x2);
          dfn = lerp(dfn, 0.8*float3(0.95, 0.97, 1.00), x3);
          dfn = lerp(dfn, 0.85, x4);
          dfn = lerp(dfn, 0.85, xE);
          dfn = lerp(dfn, 0.85, x5);
          dfn = lerp(dfn, 0.85, x6);
          dfn = lerp(dfn, 0.7*float3(0.94, 0.96, 1.01), x7);
          dfn = lerp(dfn, 0.6*float3(0.92, 0.96, 1.02), xG);	
          dfn = lerp(dfn, 0.5*float3(0.90, 0.96, 1.02), xZ);			  
          dfn = lerp(dfn, 0.45*float3(0.90, 0.96, 1.02), x8); 		  
		  dfn*=float3(0.92, 0.96, 1.03);

    if (wx.x==2) dfsn = dfn;
    if (wx.x==3) dfsn = dfn;		  
    if (wx.x==4) dfsn = dfn;
    if (wx.x==7) dfsn = dfn;
    if (wx.x==8) dfsn = dfn;
    if (wx.x==9) dfsn = dfn;
    if (wx.x==12) dfsn = dfn;
    if (wx.x==15) dfsn = dfn;
    if (wx.x==16) dfsn = dfn;	
		  
 if (Stg) finalColor2.rgb+= lerp(0.1, 1.6*(moon*float3(0.85, 0.95, 1.1)*3.5) + specular3*bl0*4.5, ShineMix*saturate(blending2.z+SnowMixA*2.0*blending2.z)*Glass*sAl);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////  Снег  ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

	float3 TM0 = GetCorrection(finalColor2.rgb*1.4);
	float3 TM1 = Uncharted2Tonemap(finalColor2.rgb*1.4);	
	       finalColor2.rgb = lerp(TM0, TM1, 0.2);			   
	
           finalColor2.rgb = saturate(finalColor2.rgb);
           finalColor2.rgb = pow(finalColor2.rgb, 1.75);

           finalColor2.a*= ColorCar.a; //1
    return finalColor2;
}

////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

technique tec0
{
    pass P0
    {
        VertexShader = compile vs_3_0 VertexShaderFunction();	
        PixelShader = compile ps_3_0 PS_Reflection();
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
]]

chameleon = [[//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++      _________           __         __________       __               __    __  __      _________       +++++//
//+++++     |XX|X X XX|          XX        |HH|HHH\HHH\     |XX              |XX|  |XX||XX|    |XX|X X XX|      +++++//
//+++++     |XX|    |XX|        /XX\       |HH|      \HH\   |XX||XX|     |XX||XX|    |XX|      |XX|    |XX|     +++++//
//+++++     |XX|    |XX|       /XXXX\      |HH|       |HH|  |XX| |XX|   |XX| |XX|    |XX|      |XX|    |XX|     +++++//
//+++++     |XX|   |XX|       /XX/\XX\     |HH|       |HH|  |XX|  |XX| |XX|  |XX|    |XX|      |XX|   |XX|      +++++//
//+++++     |XX|X X X|       /XX/  \XX\    |HH|       |HH|  |XX|     |XX|    |XX|    |XX|      |XX|X X X|       +++++//
//+++++     |XX|   \XX\     /XXXXXXXXXX\   |HH|       |HH|  |XX|             |XX|    |XX|      |XX|   \XX\      +++++//
//+++++     |XX|    \XX\   /XX/      \XX\  |HH|      /HH/   |XX|             |XX|    |XX|      |XX|    \XX\     +++++//
//+++++     |XX|    |XX|  /XX/        \XX\ |HH|    /HHH/    |XX|             |XX|    |XX|      |XX|     |XX|    +++++//
//+++++     |XX|    |XX| /XX/          \XX\|HHHHHHHHH/      |XX|             |XX|  |XX||XX|    |XX|     |XX|    +++++// 
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

//---------------------------------------------------------------------
// ...
//---------------------------------------------------------------------
//int gGameTimeHours : GAME_TIME_HOURS;
//int gGameTimeMinutes : GAME_TIME_MINUTES;
//int gWeather : WEATHER;
//int gStage1ColorOp < string stageState="1,COLOROP"; >;

float2 sEffectFade = float2(50, 40);
float4 paintColor2;
//---------------------------------------------------------------------
// Textures
//---------------------------------------------------------------------
texture gScreenSource : SCREEN_SOURCE;
texture gDepthBuffer : DEPTHBUFFER;

texture sReflDay;
texture sReflNight;
texture sSnow;
texture sSnowA;
texture sShine;
texture sReflDayV;
//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
#include "radmir.fx"
//---------------------------------------------------------------------
// Sampler
//---------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
};

sampler SamplerDepth = sampler_state
{
    Texture = (gDepthBuffer);
    AddressU = Clamp;
    AddressV = Clamp;
};

samplerCUBE VReflDaySampler = sampler_state
{
	Texture = (sReflDay);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE; //FALSE		
    MaxMipLevel=0;
    MipMapLodBias=0;
};

samplerCUBE ReflDaySampler = sampler_state
{
	Texture = (sReflDay);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE;		
    MaxMipLevel=0;
    MipMapLodBias=0;
};

samplerCUBE ReflNightSampler = sampler_state
{
	Texture = (sReflNight);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE;//FALSE
    MaxMipLevel=0;
    MipMapLodBias=0;
};

sampler2D SamplerSnow = sampler_state
{
   Texture   = <sSnow>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerSnowA = sampler_state
{
   Texture   = <sSnowA>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerShine = sampler_state
{
   Texture   = <sShine>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler SamplerColor = sampler_state
{
    Texture = (gScreenSource);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU  = Clamp;
	AddressV  = Clamp;
	SRGBTexture=FALSE;	
};

//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
	float3 Normal : NORMAL0;
	
    float4 Color : COLOR0;	
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
	float4 Position2 : POSITION1;	
    float2 TexCoord : TEXCOORD0;
    float4 Color : COLOR0;
	float4 AmbC : TEXCOORD1;
    float4 invTex : TEXCOORD2;
    float3 Material : TEXCOORD3;	
    float3 Normal : TEXCOORD4;
    float4 View : TEXCOORD5;
    float4 Light : TEXCOORD6;	
    float4 Diffuse : TEXCOORD7;		
};


////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

   // FixUpNormal( VS.Normal );
	
    // Set information to do specular calculation
    float3 Normal = mul(VS.Normal, (float3x3)gWorld);
    PS.Normal = Normal;
    Normal = normalize(Normal);	

    float4 worldPos = mul( float4(VS.Position.xyz,1) , gWorld );

	PS.Position = mul(float4(VS.Position.xyz , 1.0), gWorldViewProjection);
	PS.Position2 = PS.Position;
	
    PS.AmbC = gMaterialAmbient;
    PS.Material = AlphaMaterial();
    PS.View.xyz = gCameraPosition - worldPos.xyz;
	
    //PS.Color = CalcGTACompleteDiffuse(Normal, VS.Color);
    PS.Diffuse = gMaterialDiffuse;	
	PS.Light = CalcGTADynamicDiffuse(Normal); //1
	PS.TexCoord.xy = VS.TexCoord.xy;

    float refMask = pow(2 * dot(Normal, normalize(PS.View.xyz)), 3);
    PS.View.w = saturate(1 - refMask) * pow(dot(Normal, float3(0,0,1)), 1);

    float4x4 gWVPI =  inverse(gWorldViewProjection);
	float4 objspacepos	= mul(PS.Position2, gWVPI);
	       objspacepos.xyz/=objspacepos.w;
		   
    PS.invTex = objspacepos;
/**/	
    // Distance fade calculation
    float DistanceFromCamera = distance(gCameraPosition, worldPos.xyz);
    PS.View.w *= saturate(1 - ((DistanceFromCamera - sEffectFade.y) / (sEffectFade.x - sEffectFade.y)));
	
    return PS;
}

float3 GetCorrection(float3 color)
{
	float3 n0 = normalize(color.xyz);
	float3 ct0=color.xyz/n0.xyz;
	       ct0=pow(ct0, 1.0);
           n0.xyz = pow(n0.xyz, 1.1);   
           color.xyz = ct0*n0.xyz;  
           color.xyz*= 1.0;
	 
	float mC = max(color.x, max(color.y, color.z));		 		 
	float3 x1 = 1.0 - exp(-mC);	
	float3 rg =  float3(x1.x, x1.y, x1.z);
	float3 x2 = 1.0 - exp(-color);	
	float3 rg2 =  float3(x2.x, x2.y, x2.z);	
		 
	float mm = rg;
	float3 c1 = color * mm / mC;
	float3 p2 = rg2;
	color.xyz = lerp(p2, c1, 0.2);		 

	return color;	
}

float3 Uncharted2Tonemap(float3 x)
{
    float A = 1.0;
	float B = 0.25;
	float C = 0.52;
	float D = 0.34;
	float E = 0.0;
	float F = 1.0;

    return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
}

/*
*/

float2 wpd2(float3 cd)
{
   float4 tv = float4(cd.xyz, 1.0);
   float4 wp = mul(tv, gViewInverseTranspose);
		  //wp.xyz/= wp.w;   
		  
		  wp.x = -wp.x;  		  
		  wp.xy = wp.xy*0.0+0.0;
   return wp.xy;
}

////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

float4 PS_Reflection(PSInput PS) : COLOR0
{
    float3 vView = normalize(PS.View.xyz);	

	float wx = gWeather;
	
    float  wpos2 = length(vView.xyz);
    float3 camdir = vView.xyz / wpos2;	
    float3 npos = normalize(PS.Normal);
	
  float hourMinutes = (1 / 59) * 15;
  float GameTime = 15 + hourMinutes;

   float t0 = GameTime;
   float x1 = smoothstep(0.0, 4.0, t0);
   float x2 = smoothstep(4.0, 5.0, t0);
   float x3 = smoothstep(5.0, 6.0, t0);
   float x4 = smoothstep(6.0, 7.0, t0);
   float xE = smoothstep(8.0, 11.0, t0);
   float x5 = smoothstep(16.0, 17.0, t0);
   float x6 = smoothstep(18.0, 19.0, t0);
   float x7 = smoothstep(19.0, 20.0, t0);
   float xG = smoothstep(20.0, 21.0, t0);  
   float xZ = smoothstep(21.0, 22.0, t0);
   float x8 = smoothstep(22.0, 24.0, t0);	
   
 //SunDirection--------------------
float3  f = lerp(float3(0.,0.,-.61), float3(.583,-.257,-.0108), smoothstep(0.,5.,GameTime));
        f = lerp(f, float3(.569,-.242,.151), smoothstep(5.,7.,GameTime));
		f = lerp(f, float3(.49,-.247,.323), smoothstep(7.,9.,GameTime));
		f = lerp(f, float3(.373,-.262,.445), smoothstep(9.,11.,GameTime));
		f = lerp(f, float3(.201,-.312,.517), smoothstep(11.,13.,GameTime));
		f = lerp(f, float3(-.00732,-.39,.503), smoothstep(13.,15.,GameTime));
		f = lerp(f, float3(-.189,-.502,.343), smoothstep(15.,17.,GameTime));
		f = lerp(f, float3(-.223,-.594,.1), smoothstep(17.,19.,GameTime));
		f = lerp(f, float3(0.,0.,-.61), smoothstep(19.,24.,GameTime));
		f = normalize(f);  	
		
   float3 df0 = lerp(0.70*float3(0.90, 0.95, 1.02), 0.70*float3(0.90, 0.95, 1.02), x1);
          df0 = lerp(df0, 0.72*float3(0.90, 0.95, 1.02), x2);
          df0 = lerp(df0, 1.75*float3(1.15, 0.95, 0.75), x3);
          df0 = lerp(df0, 2.1*float3(1.10, 0.99, 0.90), x4);
          df0 = lerp(df0, 2.2*float3(1.02, 0.99, 0.95), xE);
          df0 = lerp(df0, 2.2*float3(1.02, 0.99, 0.95), x5);
          df0 = lerp(df0, 1.95*float3(1.20, 0.99, 0.70), x6);
          df0 = lerp(df0, 1.80*float3(1.10, 0.95, 0.80), x7);
          df0 = lerp(df0, 0.80*float3(0.95, 0.92, 0.90), xG);	
          df0 = lerp(df0, 0.75*float3(0.90, 0.95, 1.02), xZ);	  
          df0 = lerp(df0, 0.70*float3(0.90, 0.95, 1.02), x8); 
		  
   float3 df1 = 0.70;
   
    if (wx.x==2) df0 = df1; 
    if (wx.x==3) df0 = df1;   
    if (wx.x==4) df0 = df1;
    if (wx.x==7) df0 = df1;
    if (wx.x==8) df0 = df1;
    if (wx.x==9) df0 = df1;
    if (wx.x==12) df0 = df1;
    if (wx.x==15) df0 = df1;
    if (wx.x==16) df0 = df1;		

	
   float3 sh0 = lerp(0.70, 0.70, x1);
          sh0 = lerp(sh0, 0.70, x2);
          sh0 = lerp(sh0, 0.95, x3);
          sh0 = lerp(sh0, 0.95, x4);
          sh0 = lerp(sh0, 0.95, xE);
          sh0 = lerp(sh0, 0.95, x5);
          sh0 = lerp(sh0, 0.80, x6);
          sh0 = lerp(sh0, 0.80, x7);
          sh0 = lerp(sh0, 0.80, xG);	
          sh0 = lerp(sh0, 0.75, xZ);		  		  
          sh0 = lerp(sh0, 0.70, x8); 
		  
float3 shadowColor = float3(0.90, 0.93, 1.025);			  
    if (wx.x==4) shadowColor = 1.0;
    if (wx.x==7) shadowColor = 1.0;
    if (wx.x==8) shadowColor = 1.0;
    if (wx.x==9) shadowColor = 1.0;
    if (wx.x==12) shadowColor = 1.0;
    if (wx.x==15) shadowColor = 1.0;
    if (wx.x==16) shadowColor = 1.0;


    float3 Color0 = float3(1, 0.9, 0.75);
    float3 Color1 = float3(1.25, 1.25, 0.85);
    
     if (wx.x==2) Color0 = Color1;
     if (wx.x==3) Color0 = Color1;		 
     if (wx.x==4) Color0 = Color1;
     if (wx.x==7) Color0 = Color1;
     if (wx.x==8) Color0 = Color1;
     if (wx.x==9) Color0 = Color1;
     if (wx.x==12) Color0 = Color1;
     if (wx.x==15) Color0 = Color1;
     if (wx.x==16) Color0 = Color1;	
 
    float3 bl0 = lerp(0.0, 0.0, x1);
           bl0 = lerp(bl0, 0.0, x2);
           bl0 = lerp(bl0, 0.5*Color0, x3);
           bl0 = lerp(bl0, 1.5*Color0, x4);
           bl0 = lerp(bl0, 1.5*Color0, xE);
           bl0 = lerp(bl0, 0.75*Color0, x5);
           bl0 = lerp(bl0, 0.5*Color0, x6);
           bl0 = lerp(bl0, 0.3*Color0, x7);
           bl0 = lerp(bl0, 0.0, xG);		
           bl0 = lerp(bl0, 0.0, xZ);		  
           bl0 = lerp(bl0, 0.0, x8);

		  
		 
   float sp0 = lerp(0.0, 0.0, x1);
         sp0 = lerp(sp0, 0.0, x2);
         sp0 = lerp(sp0, 1.0, x3);
         sp0 = lerp(sp0, 1.0, x4);
         sp0 = lerp(sp0, 1.0, xE);
         sp0 = lerp(sp0, 1.0, x5);
         sp0 = lerp(sp0, 1.0, x6);
         sp0 = lerp(sp0, 1.0, x7);
         sp0 = lerp(sp0, 0.0, xG);	
         sp0 = lerp(sp0, 0.0, xZ);			 
         sp0 = lerp(sp0, 0.0, x8);	
		 
    if (wx.x==2) sp0 = 0.0;
    if (wx.x==3) sp0 = 0.0;		 
    if (wx.x==4) sp0 = 0.0;
    if (wx.x==7) sp0 = 0.0;
    if (wx.x==8) sp0 = 0.0;
    if (wx.x==9) sp0 = 0.0;
    if (wx.x==12) sp0 = 0.0;
    if (wx.x==15) sp0 = 0.0;
    if (wx.x==16) sp0 = 0.0;			 
		 
 		   
   float3 X2 = normalize(f+camdir);	
   float specular3 = pow(0.01-dot(npos.xyz, X2.xyz), 0.35);
         specular3 = pow(specular3, 50.0*1.8);
         specular3 = (specular3*specular3)*10.5;
         specular3/= 5.5*1.5; 	
		 
    float df2 = 0.01*0.001 + dot(npos.xyz, X2);	
		  df2 = pow(df2, 2500.0*2);
	float gl = (df2/0.01)* 0.01;
          gl = saturate(gl)*10.0;		   
		   
 	float4 ColorCar = PS.Diffuse;	
    float4 texel = tex2D(Sampler0, PS.TexCoord);
	       texel.rgb*= ColorCar*float3(0.97, 1.0, 1.05);
		   
    float texelA = saturate(texel.rgb);	
    float mix = lerp(0.7, 2.2, texelA);	
    float diff = saturate(0.1-dot(npos, -f)); 
		  diff = pow(diff, 0.7);

    float3 sv3 = normalize(float3(0.0, 0.0, 0.7)+vView.xyz); 	
	float fresnelz = (0.05-dot(-sv3, npos));		
		  fresnelz = pow(fresnelz, 5.0);
		  fresnelz = fresnelz*fresnelz;
          fresnelz/= 2.5;	
          fresnelz*= 0.7;		  		  		  
		  
	float3 lighting = lerp(sh0*shadowColor, df0, saturate(diff));			   
	
    float3 refl = reflect(vView, npos);	
	
    float4 CubeD = texCUBE(ReflDaySampler, -refl.xzy);
	       CubeD*= 2.0;	
    float4 CubeDV = texCUBE(VReflDaySampler, -refl.xzy);
	       CubeDV*= 2.1; //1
			   
	float3 CurrentRefl =  CubeDV.rgb;

	if (wx.x==0) CurrentRefl = CubeD.rgb;
	if (wx.x==1) CurrentRefl = CubeD.rgb;
	if (wx.x==2) CurrentRefl = CubeD.rgb;
	if (wx.x==3) CurrentRefl = CubeD.rgb;
	if (wx.x==4) CurrentRefl = CubeD.rgb;
	
	
    float4 CubeN = texCUBE(ReflNightSampler, -refl.xzy);
	       CubeN.rgb*= 2.2*float3(0.82, 0.95, 1.05);

	float3 cb = lerp(CubeN.xyz, CubeN.xyz, x1);
		   cb = lerp(cb, CubeN.xyz, x2);
		   cb = lerp(cb, ((CurrentRefl.xyz*0.75)+(paintColor2*0.75)), x3);
		   cb = lerp(cb, CurrentRefl.xyz*(paintColor2*0.5), x6);
		   cb = lerp(cb, CurrentRefl.xyz*0.85+(paintColor2*0.5), x7);
		   cb = lerp(cb, CurrentRefl.xyz*0.8, xG);		   
		   cb = lerp(cb, CubeN.xyz, xZ);		   
		   cb = lerp(cb, CubeN.xyz, x8);
		   
	float3 n0 = normalize(cb.xyz);
	float3 ct0=cb.xyz/n0.xyz;
	       ct0=pow(ct0, 2.0);
           n0.xyz = pow(n0.xyz, 1.8);   
           cb.xyz = ct0*n0.xyz;  
           cb.xyz*= 1.25;			   
	
	float fresnel = 0.001*1.0-dot(npos, -camdir);		
		  fresnel = saturate(pow(fresnel, 0.37*0.15));		  
  		  
   float m0 = lerp(0.20, 0.20, x1);
         m0 = lerp(m0, 0.10, x2);
         m0 = lerp(m0, 0.0, x3);
         m0 = lerp(m0, 0.0, x4);
         m0 = lerp(m0, 0.0, x5);
         m0 = lerp(m0, 0.0, x6);
         m0 = lerp(m0, 0.0, x7);		 
         m0 = lerp(m0, 0.20, x8);
		
    float3 MoonVector = normalize(float3(-0.00732, -0.39, 0.317));
    float m1 = saturate(0.001 + dot(normalize(-MoonVector-camdir), -npos.xyz));	
		  m1 = pow(m1, 35.0);
    float3 moon = (m1*m1)*m0*2.0;		  
	   
    float mix2 = lerp(0.9, 5.0, texelA);		 
    float4 texel2 = tex2D(Sampler0, PS.TexCoord);	
	
	float4 Lighting1 = ColorCar*PS.Light*0.9;

  	float4 diffuse  = gDiffuseMaterialSource  == 0 ? ColorCar  : 1;

/*	
  float3 CL1 = float3(0.6, 0.8, 1.1)*1.1;
  float3 CL2 = float3(0.9, 0.95, 1.0); 
  float3 CL0 = lerp(CL1, CL1, x1);
         CL0 = lerp(CL0, float3(0.65, 0.83, 1.05), x2);
         CL0 = lerp(CL0, CL2, x3);
         CL0 = lerp(CL0, 1.0, x4);
         CL0 = lerp(CL0, 1.0, xE);
         CL0 = lerp(CL0, 1.0, x5);
         CL0 = lerp(CL0, float3(0.90, 0.95, 1.0), x6);
         CL0 = lerp(CL0, float3(0.66, 0.84, 1.04)*0.9, x7);
         CL0 = lerp(CL0, CL1, x8);
		 
  float3 CV0 = lerp(float3(0.75, 0.85, 1.0), float3(0.75, 0.85, 1.0), x1);
         CV0 = lerp(CV0, float3(0.75, 0.85, 1.0), x2);
         CV0 = lerp(CV0, 1.0, x3);
         CV0 = lerp(CV0, 1.0, x4);
         CV0 = lerp(CV0, 1.0, xE);
         CV0 = lerp(CV0, 1.0, x5);
         CV0 = lerp(CV0, 1.0, x6);
         CV0 = lerp(CV0, 1.0, x7);
         CV0 = lerp(CV0, float3(0.75, 0.85, 1.0), x8);		 
		 

float3 CurrentWeather = 1.0;

if (wx.x==0) CurrentWeather = CL0;
if (wx.x==1) CurrentWeather = CL0;
if (wx.x==2) CurrentWeather = CL0;
if (wx.x==3) CurrentWeather = CL0;
if (wx.x==4) CurrentWeather = CL0; 	

if (wx.x==7) CurrentWeather = CL0;
if (wx.x==8) CurrentWeather = CL0;
if (wx.x==9) CurrentWeather = CL0;

if (wx.x==12) CurrentWeather = CL0;
if (wx.x==15) CurrentWeather = CL0;
if (wx.x==16) CurrentWeather = CL0;	  

if (wx.x==5) CurrentWeather = CV0;
if (wx.x==6) CurrentWeather = CV0;
 
if (wx.x==10) CurrentWeather = CV0; 		 
if (wx.x==11) CurrentWeather = CV0; 
if (wx.x==13) CurrentWeather = CV0; 	
if (wx.x==14) CurrentWeather = CV0; 
if (wx.x==17) CurrentWeather = CV0; 
*/
    float Stg = ((texel.a <=0.9999) || PS.Material);

    float4 DiffAmb = PS.AmbC*2.0;
  if (Stg) DiffAmb = (ColorCar*0.3);
	   
	float4 finalColor2 = float4((DiffAmb.rgb+Lighting1.rgb)*texel2.rgb*0.9, min(diffuse.a, texel2.a));	
	   
    float3 specmix2 = lerp(specular3*1.5, specular3*finalColor2*1.5, 0.80);	
		

   float factor3 = 0.1 - dot(-vView, npos);
         factor3 = pow(factor3, 0.65);
   float fr3 = (factor3*factor3); 
         fr3/= 2.5;	
         fr3 = saturate(fr3*2.6);	
         fr3 = lerp(1.0, fr3, 0.65);		

           finalColor2.rgb*= fr3;			
		
           finalColor2.rgb*= (lighting);				   
           finalColor2.rgb+= specmix2*bl0*0.7; 
           finalColor2.rgb+= moon*float3(0.85, 0.95, 1.1)*0.5;	
           finalColor2.rgb+= saturate(lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92)*0.7);				   


		   
    //finalColor2.rgb+= lerp(lerp(fresnelz*2.4, finalColor2.xyz*fresnelz*1.2, 0.92), 0.0, saturate(lighting2));			
    //finalColor2.rgb+= lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92);		
	
	float fresnelx = 0.001-dot(-vView, npos);		
		  fresnelx = saturate(pow(fresnelx, 0.37));
		  fresnelx = lerp(1.0, 0.0, 0.92*fresnelx);	

   float sp1 = lerp(0.2, 0.2, x1);
         sp1 = lerp(sp1, 0.2, x2);
         sp1 = lerp(sp1, 0.6, x3);
         sp1 = lerp(sp1, 0.8, x4);
         sp1 = lerp(sp1, 0.9, x5);
         sp1 = lerp(sp1, 0.6, x6);
         sp1 = lerp(sp1, 0.5, x7);
         sp1 = lerp(sp1, 0.2, xG);	
         sp1 = lerp(sp1, 0.2, xZ);			 
         sp1 = lerp(sp1, 0.2, x8);	
		  		   

		   
	
  float3 v = {0.6, 0.6, 0.95};
  float3 v2 = {0.9, 0.9, 1.0};  
  
  float3 n = normalize(npos.xyz*v);		 
  float3 ref0 = reflect(vView.xyz, n.xyz);		 
  //float3 n1 = ((1000.0/0.01)*n0)/1000.0;		
  float3 ref2 = (1.0*ref0)/0.5;	  
  
  float3 r0 = (vView.xyz+ref2)*0.95;	
  float2 r1 = wpd2(r0.xyz);		
	
	float2 rc = r1.xy;		
	
    float4 envMap = tex2D(SamplerColor, rc);
	       envMap.w = rc.y<0.0||rc.y>1.0 ? 0.0:1.0; 
	       envMap.w*= rc.x<0.0||rc.x>1.0 ? 0.0:1.0;

	float c08 = 6.7;
	float c07 = 1.0;

	float nf02 = saturate(c08*(r1.y));
          nf02*= saturate(c08*(r1.x));					
	      nf02 = pow(nf02, c07);			
	float nf03 = saturate(c08+r1.y*(-c08));
          nf03*= saturate(c08+r1.x*(-c08));					
	      nf03 = pow(nf03, c07);
	
	float fresnelR = 0.01-dot(npos, -camdir);		
		  fresnelR = saturate(pow(fresnelR, 4.0));	

		    cb = lerp(cb, envMap.xyz*3.3,  envMap.w*nf02*nf03*pow(0.01*0.5, fresnelR));	
    float3 reflection = lerp(1.12*cb+(gl*sp0*4.0), finalColor2.rgb, 0.97*fresnel);

    //float3 AtmSky = getSky(GameTime, wx, wpos, wpos2);	
		   
           finalColor2.rgb = lerp(finalColor2.rgb+fresnelx*0.27*sp1*float3(0.92, 0.96, 1.0), reflection, Stg); //
		   
    //finalColor2.rgb = GetCorrection(finalColor2.rgb*2.0);		   

		   
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////  Снег  ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
	float4 objspacepos	= PS.invTex;
	// Triplanar uvs
    float2 uvX = objspacepos.yz; // x facing plane
    float2 uvY = objspacepos.xz; // y facing plane	
    float2 uvZ = objspacepos.xy; // z facing plane   

	float3 wnorm = normalize(cross(ddx(objspacepos.xyz),ddy(objspacepos.xyz)));  

    float3 blending = pow(abs(wnorm.xyz), 3.0);
 	       blending = blending / (blending.x + blending.y + blending.z);	
		   
    float3 blending2 = pow(abs(npos.xyz*float3(22.0, 22.0, 10.0)), 2.2);
 	       blending2 = blending2 / (blending2.x + blending2.y + blending2.z);		
		   	   
		float3 R1x = tex2D(SamplerSnow, uvX);
		float3 R1y = tex2D(SamplerSnow, uvY);		
		float3 R1z = tex2D(SamplerSnow, uvZ);

		float3 Ax = tex2D(SamplerSnowA, uvX);
		float3 Ay = tex2D(SamplerSnowA, uvY);		
		float3 Az = tex2D(SamplerSnowA, uvZ);
		
		float3 Shx = tex2D(SamplerShine, uvX);
		float3 Shy = tex2D(SamplerShine, uvY);		
		float3 Shz = tex2D(SamplerShine, uvZ);	
		
	float ShineMix = Shx*blending.x + Shy*blending.y + Shz*blending.z; 		   

    float3 vw = normalize(float3(0,0,1));
    float sAl = saturate(0.01-dot(vw, -npos));
		  sAl = pow(sAl, 0.2);	//1		   

		  
	float3 SnowMix = R1x*blending.x + R1y*blending.y + R1z*blending.z; 	 		
	float SnowMixA = Ax*blending.x + Ay*blending.y + Az*blending.z; 

	float Glass = pow(ColorCar.a, 0.5);
	float3 Lighting2 = PS.Light*0.9; 
	
   float3 dfsn = lerp(0.45*float3(0.78, 0.90, 1.02), 0.45*float3(0.78, 0.90, 1.02), x1);
          dfsn = lerp(dfsn, 0.8*float3(0.90, 0.95, 1.02), x2);
          dfsn = lerp(dfsn, 1.05*float3(1.0, 0.99, 0.95), x3);
          dfsn = lerp(dfsn, 1.11*float3(1.0, 0.99, 0.95), x4);
          dfsn = lerp(dfsn, 1.15*float3(1.02, 0.99, 0.95), xE);
          dfsn = lerp(dfsn, 1.15*float3(1.02, 0.99, 0.95), x5);
          dfsn = lerp(dfsn, 1.12*float3(1.05, 0.90, 0.80), x6);
          dfsn = lerp(dfsn, 0.9*float3(0.93, 0.90, 0.95), x7);
          dfsn = lerp(dfsn, 0.6*float3(0.90, 0.95, 1.02), xG);	
          dfsn = lerp(dfsn, 0.5*float3(0.90, 0.95, 1.02), xZ);			  
          dfsn = lerp(dfsn, 0.45*float3(0.82, 0.90, 1.02), x8); 
		  
   float3 dfn = lerp(0.45*float3(0.92, 0.96, 1.03), 0.45*float3(0.92, 0.96, 1.03), x1);
          dfn = lerp(dfn, 0.52*float3(0.92, 0.96, 1.02), x2);
          dfn = lerp(dfn, 0.8*float3(0.95, 0.97, 1.00), x3);
          dfn = lerp(dfn, 0.85, x4);
          dfn = lerp(dfn, 0.85, xE);
          dfn = lerp(dfn, 0.85, x5);
          dfn = lerp(dfn, 0.85, x6);
          dfn = lerp(dfn, 0.7*float3(0.94, 0.96, 1.01), x7);
          dfn = lerp(dfn, 0.6*float3(0.92, 0.96, 1.02), xG);	
          dfn = lerp(dfn, 0.5*float3(0.90, 0.96, 1.02), xZ);			  
          dfn = lerp(dfn, 0.45*float3(0.90, 0.96, 1.02), x8); 		  
		  dfn*=float3(0.92, 0.96, 1.03);

    if (wx.x==2) dfsn = dfn;
    if (wx.x==3) dfsn = dfn;		  
    if (wx.x==4) dfsn = dfn;
    if (wx.x==7) dfsn = dfn;
    if (wx.x==8) dfsn = dfn;
    if (wx.x==9) dfsn = dfn;
    if (wx.x==12) dfsn = dfn;
    if (wx.x==15) dfsn = dfn;
    if (wx.x==16) dfsn = dfn;	
		  
 if (Stg) finalColor2.rgb+= lerp(0.0, 1.6*(moon*float3(0.85, 0.95, 1.1)*3.5) + specular3*bl0*4.5, (ShineMix*0.2)*saturate(blending2.z+SnowMixA*2.0*blending2.z)*Glass*sAl);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////  Снег  ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

	float3 TM0 = GetCorrection(finalColor2.rgb*1.4);
	float3 TM1 = Uncharted2Tonemap(finalColor2.rgb*1.4);	
	       finalColor2.rgb = lerp(TM0, TM1, 0.2);			   
	
           finalColor2.rgb = saturate(finalColor2.rgb);
           finalColor2.rgb = pow(finalColor2.rgb, 1.75);

           finalColor2.a*= ColorCar.a; //1
    return finalColor2;
}

////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

technique tec0
{
    pass P0
    {
        VertexShader = compile vs_3_0 VertexShaderFunction();	
        PixelShader = compile ps_3_0 PS_Reflection();
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
]]

standart2 = [[
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++      _________           __         __________       __               __    __  __      _________       +++++//
//+++++     |XX|X X XX|          XX        |HH|HHH\HHH\     |XX              |XX|  |XX||XX|    |XX|X X XX|      +++++//
//+++++     |XX|    |XX|        /XX\       |HH|      \HH\   |XX||XX|     |XX||XX|    |XX|      |XX|    |XX|     +++++//
//+++++     |XX|    |XX|       /XXXX\      |HH|       |HH|  |XX| |XX|   |XX| |XX|    |XX|      |XX|    |XX|     +++++//
//+++++     |XX|   |XX|       /XX/\XX\     |HH|       |HH|  |XX|  |XX| |XX|  |XX|    |XX|      |XX|   |XX|      +++++//
//+++++     |XX|X X X|       /XX/  \XX\    |HH|       |HH|  |XX|     |XX|    |XX|    |XX|      |XX|X X X|       +++++//
//+++++     |XX|   \XX\     /XXXXXXXXXX\   |HH|       |HH|  |XX|             |XX|    |XX|      |XX|   \XX\      +++++//
//+++++     |XX|    \XX\   /XX/      \XX\  |HH|      /HH/   |XX|             |XX|    |XX|      |XX|    \XX\     +++++//
//+++++     |XX|    |XX|  /XX/        \XX\ |HH|    /HHH/    |XX|             |XX|    |XX|      |XX|     |XX|    +++++//
//+++++     |XX|    |XX| /XX/          \XX\|HHHHHHHHH/      |XX|             |XX|  |XX||XX|    |XX|     |XX|    +++++// 
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

//---------------------------------------------------------------------
// ...
//---------------------------------------------------------------------
//int gGameTimeHours : GAME_TIME_HOURS;
//int gGameTimeMinutes : GAME_TIME_MINUTES;
//int gWeather : WEATHER;
//int gStage1ColorOp < string stageState="1,COLOROP"; >;

float2 sEffectFade = float2(50, 40);
//---------------------------------------------------------------------
// Textures
//---------------------------------------------------------------------
texture gScreenSource : SCREEN_SOURCE;
texture gDepthBuffer : DEPTHBUFFER;

texture sReflDay;
texture sReflNight;
texture sSnow;
texture sSnowA;
texture sShine;
texture sReflDayV;
//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
#include "radmir.fx"
//---------------------------------------------------------------------
// Sampler
//---------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
};

sampler SamplerDepth = sampler_state
{
    Texture = (gDepthBuffer);
    AddressU = Clamp;
    AddressV = Clamp;
};

samplerCUBE VReflDaySampler = sampler_state
{
	Texture = (sReflDay);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE; //FALSE		
    MaxMipLevel=0;
    MipMapLodBias=0;
};

samplerCUBE ReflDaySampler = sampler_state
{
	Texture = (sReflDay);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE;		
    MaxMipLevel=0;
    MipMapLodBias=0;
};

samplerCUBE ReflNightSampler = sampler_state
{
	Texture = (sReflNight);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	SRGBTexture=FALSE;//FALSE
    MaxMipLevel=0;
    MipMapLodBias=0;
};

sampler2D SamplerSnow = sampler_state
{
   Texture   = <sSnow>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerSnowA = sampler_state
{
   Texture   = <sSnowA>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerShine = sampler_state
{
   Texture   = <sShine>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler SamplerColor = sampler_state
{
    Texture = (gScreenSource);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU  = Clamp;
	AddressV  = Clamp;
	SRGBTexture=FALSE;	
};

//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
	float3 Normal : NORMAL0;
	
    float4 Color : COLOR0;	
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
	float4 Position2 : POSITION1;	
    float2 TexCoord : TEXCOORD0;
    float4 Color : COLOR0;
	float4 AmbC : TEXCOORD1;
    float4 invTex : TEXCOORD2;
    float3 Material : TEXCOORD3;	
    float3 Normal : TEXCOORD4;
    float4 View : TEXCOORD5;
    float4 Light : TEXCOORD6;	
    float4 Diffuse : TEXCOORD7;		
};


////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

   // FixUpNormal( VS.Normal );
	
    // Set information to do specular calculation
    float3 Normal = mul(VS.Normal, (float3x3)gWorld);
    PS.Normal = Normal;
    Normal = normalize(Normal);	

    float4 worldPos = mul( float4(VS.Position.xyz,1) , gWorld );

	PS.Position = mul(float4(VS.Position.xyz , 1.0), gWorldViewProjection);
	PS.Position2 = PS.Position;
	
    PS.AmbC = gMaterialAmbient;
    PS.Material = AlphaMaterial();
    PS.View.xyz = gCameraPosition - worldPos.xyz;
	
    //PS.Color = CalcGTACompleteDiffuse(Normal, VS.Color);
    PS.Diffuse = gMaterialDiffuse;	
	PS.Light = CalcGTADynamicDiffuse(Normal); //1
	PS.TexCoord.xy = VS.TexCoord.xy;

    float refMask = pow(2 * dot(Normal, normalize(PS.View.xyz)), 3);
    PS.View.w = saturate(1 - refMask) * pow(dot(Normal, float3(0,0,1)), 1);

    float4x4 gWVPI =  inverse(gWorldViewProjection);
	float4 objspacepos	= mul(PS.Position2, gWVPI);
	       objspacepos.xyz/=objspacepos.w;
		   
    PS.invTex = objspacepos;
/**/	
    // Distance fade calculation
    float DistanceFromCamera = distance(gCameraPosition, worldPos.xyz);
    PS.View.w *= saturate(1 - ((DistanceFromCamera - sEffectFade.y) / (sEffectFade.x - sEffectFade.y)));
	
    return PS;
}

float3 GetCorrection(float3 color)
{
	float3 n0 = normalize(color.xyz);
	float3 ct0=color.xyz/n0.xyz;
	       ct0=pow(ct0, 1.0);
           n0.xyz = pow(n0.xyz, 1.1);   
           color.xyz = ct0*n0.xyz;  
           color.xyz*= 1.0;
	 
	float mC = max(color.x, max(color.y, color.z));		 		 
	float3 x1 = 1.0 - exp(-mC);	
	float3 rg =  float3(x1.x, x1.y, x1.z);
	float3 x2 = 1.0 - exp(-color);	
	float3 rg2 =  float3(x2.x, x2.y, x2.z);	
		 
	float mm = rg;
	float3 c1 = color * mm / mC;
	float3 p2 = rg2;
	color.xyz = lerp(p2, c1, 0.2);		 

	return color;	
}

float3 Uncharted2Tonemap(float3 x)
{
    float A = 1.0;
	float B = 0.25;
	float C = 0.52;
	float D = 0.34;
	float E = 0.0;
	float F = 1.0;

    return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
}

/*
*/

float2 wpd2(float3 cd)
{
   float4 tv = float4(cd.xyz, 1.0);
   float4 wp = mul(tv, gViewInverseTranspose);
		  //wp.xyz/= wp.w;   
		  
		  wp.x = -wp.x;  		  
		  wp.xy = wp.xy*0.0+0.0;
   return wp.xy;
}

////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

float4 PS_Reflection(PSInput PS) : COLOR0
{
    float3 vView = normalize(PS.View.xyz);	

	float wx = gWeather;
	
    float  wpos2 = length(vView.xyz);
    float3 camdir = vView.xyz / wpos2;	
    float3 npos = normalize(PS.Normal);
	
  float hourMinutes = (1 / 59) * 15;
  float GameTime = 15 + hourMinutes;

   float t0 = GameTime;
   float x1 = smoothstep(0.0, 4.0, t0);
   float x2 = smoothstep(4.0, 5.0, t0);
   float x3 = smoothstep(5.0, 6.0, t0);
   float x4 = smoothstep(6.0, 7.0, t0);
   float xE = smoothstep(8.0, 11.0, t0);
   float x5 = smoothstep(16.0, 17.0, t0);
   float x6 = smoothstep(18.0, 19.0, t0);
   float x7 = smoothstep(19.0, 20.0, t0);
   float xG = smoothstep(20.0, 21.0, t0);  
   float xZ = smoothstep(21.0, 22.0, t0);
   float x8 = smoothstep(22.0, 24.0, t0);	
   
 //SunDirection--------------------
float3  f = lerp(float3(0.,0.,-.61), float3(.583,-.257,-.0108), smoothstep(0.,5.,GameTime));
        f = lerp(f, float3(.569,-.242,.151), smoothstep(5.,7.,GameTime));
		f = lerp(f, float3(.49,-.247,.323), smoothstep(7.,9.,GameTime));
		f = lerp(f, float3(.373,-.262,.445), smoothstep(9.,11.,GameTime));
		f = lerp(f, float3(.201,-.312,.517), smoothstep(11.,13.,GameTime));
		f = lerp(f, float3(-.00732,-.39,.503), smoothstep(13.,15.,GameTime));
		f = lerp(f, float3(-.189,-.502,.343), smoothstep(15.,17.,GameTime));
		f = lerp(f, float3(-.223,-.594,.1), smoothstep(17.,19.,GameTime));
		f = lerp(f, float3(0.,0.,-.61), smoothstep(19.,24.,GameTime));
		f = normalize(f);  	
		
   float3 df0 = lerp(0.70*float3(0.90, 0.95, 1.02), 0.70*float3(0.90, 0.95, 1.02), x1);
          df0 = lerp(df0, 0.72*float3(0.90, 0.95, 1.02), x2);
          df0 = lerp(df0, 1.75*float3(1.15, 0.95, 0.75), x3);
          df0 = lerp(df0, 2.1*float3(1.10, 0.99, 0.90), x4);
          df0 = lerp(df0, 2.2*float3(1.02, 0.99, 0.95), xE);
          df0 = lerp(df0, 2.2*float3(1.02, 0.99, 0.95), x5);
          df0 = lerp(df0, 1.95*float3(1.20, 0.99, 0.70), x6);
          df0 = lerp(df0, 1.80*float3(1.10, 0.95, 0.80), x7);
          df0 = lerp(df0, 0.80*float3(0.95, 0.92, 0.90), xG);	
          df0 = lerp(df0, 0.75*float3(0.90, 0.95, 1.02), xZ);	  
          df0 = lerp(df0, 0.70*float3(0.90, 0.95, 1.02), x8); 
		  
   float3 df1 = 0.70;
   
    if (wx.x==2) df0 = df1; 
    if (wx.x==3) df0 = df1;   
    if (wx.x==4) df0 = df1;
    if (wx.x==7) df0 = df1;
    if (wx.x==8) df0 = df1;
    if (wx.x==9) df0 = df1;
    if (wx.x==12) df0 = df1;
    if (wx.x==15) df0 = df1;
    if (wx.x==16) df0 = df1;		

	
   float3 sh0 = lerp(0.70, 0.70, x1);
          sh0 = lerp(sh0, 0.70, x2);
          sh0 = lerp(sh0, 0.95, x3);
          sh0 = lerp(sh0, 0.95, x4);
          sh0 = lerp(sh0, 0.95, xE);
          sh0 = lerp(sh0, 0.95, x5);
          sh0 = lerp(sh0, 0.80, x6);
          sh0 = lerp(sh0, 0.80, x7);
          sh0 = lerp(sh0, 0.80, xG);	
          sh0 = lerp(sh0, 0.75, xZ);		  		  
          sh0 = lerp(sh0, 0.70, x8); 
		  
float3 shadowColor = float3(0.90, 0.93, 1.025);			  
    if (wx.x==4) shadowColor = 1.0;
    if (wx.x==7) shadowColor = 1.0;
    if (wx.x==8) shadowColor = 1.0;
    if (wx.x==9) shadowColor = 1.0;
    if (wx.x==12) shadowColor = 1.0;
    if (wx.x==15) shadowColor = 1.0;
    if (wx.x==16) shadowColor = 1.0;


    float3 Color0 = float3(1, 0.9, 0.75);
    float3 Color1 = float3(1.25, 1.25, 0.85);
    
     if (wx.x==2) Color0 = Color1;
     if (wx.x==3) Color0 = Color1;		 
     if (wx.x==4) Color0 = Color1;
     if (wx.x==7) Color0 = Color1;
     if (wx.x==8) Color0 = Color1;
     if (wx.x==9) Color0 = Color1;
     if (wx.x==12) Color0 = Color1;
     if (wx.x==15) Color0 = Color1;
     if (wx.x==16) Color0 = Color1;	
 
    float3 bl0 = lerp(0.0, 0.0, x1);
           bl0 = lerp(bl0, 0.0, x2);
           bl0 = lerp(bl0, 0.5*Color0, x3);
           bl0 = lerp(bl0, 1.5*Color0, x4);
           bl0 = lerp(bl0, 1.5*Color0, xE);
           bl0 = lerp(bl0, 0.75*Color0, x5);
           bl0 = lerp(bl0, 0.5*Color0, x6);
           bl0 = lerp(bl0, 0.3*Color0, x7);
           bl0 = lerp(bl0, 0.0, xG);		
           bl0 = lerp(bl0, 0.0, xZ);		  
           bl0 = lerp(bl0, 0.0, x8);

		  
		 
   float sp0 = lerp(0.0, 0.0, x1);
         sp0 = lerp(sp0, 0.0, x2);
         sp0 = lerp(sp0, 1.0, x3);
         sp0 = lerp(sp0, 1.0, x4);
         sp0 = lerp(sp0, 1.0, xE);
         sp0 = lerp(sp0, 1.0, x5);
         sp0 = lerp(sp0, 1.0, x6);
         sp0 = lerp(sp0, 1.0, x7);
         sp0 = lerp(sp0, 0.0, xG);	
         sp0 = lerp(sp0, 0.0, xZ);			 
         sp0 = lerp(sp0, 0.0, x8);	
		 
    if (wx.x==2) sp0 = 0.0;
    if (wx.x==3) sp0 = 0.0;		 
    if (wx.x==4) sp0 = 0.0;
    if (wx.x==7) sp0 = 0.0;
    if (wx.x==8) sp0 = 0.0;
    if (wx.x==9) sp0 = 0.0;
    if (wx.x==12) sp0 = 0.0;
    if (wx.x==15) sp0 = 0.0;
    if (wx.x==16) sp0 = 0.0;			 
		 
 		   
   float3 X2 = normalize(f+camdir);	
   float specular3 = pow(0.01-dot(npos.xyz, X2.xyz), 0.35);
         specular3 = pow(specular3, 50.0*1.8);
         specular3 = (specular3*specular3)*10.5;
         specular3/= 5.5*1.5; 	
		 
    float df2 = 0.01*0.001 + dot(npos.xyz, X2);	
		  df2 = pow(df2, 2500.0*2);
	float gl = (df2/0.01)* 0.01;
          gl = saturate(gl)*10.0;		   
		   
 	float4 ColorCar = PS.Diffuse;	
    float4 texel = tex2D(Sampler0, PS.TexCoord);
	       texel.rgb*= ColorCar*float3(0.97, 1.0, 1.05);
		   
    float texelA = saturate(texel.rgb);	
    float mix = lerp(0.7, 2.2, texelA);	
    float diff = saturate(0.1-dot(npos, -f)); 
		  diff = pow(diff, 0.7);

    float3 sv3 = normalize(float3(0.0, 0.0, 0.7)+vView.xyz); 	
	float fresnelz = (0.05-dot(-sv3, npos));		
		  fresnelz = pow(fresnelz, 5.0);
		  fresnelz = fresnelz*fresnelz;
          fresnelz/= 2.5;	
          fresnelz*= 0.7;		  		  		  
		  
	float3 lighting = lerp(sh0*shadowColor, df0, saturate(diff));			   
	
    float3 refl = reflect(vView, npos);	
	
    float4 CubeD = texCUBE(ReflDaySampler, -refl.xzy);
	       CubeD*= 2.0;	
    float4 CubeDV = texCUBE(VReflDaySampler, -refl.xzy);
	       CubeDV*= 2.1; //1
			   
	float3 CurrentRefl =  CubeDV.rgb;

	if (wx.x==0) CurrentRefl = CubeD.rgb;
	if (wx.x==1) CurrentRefl = CubeD.rgb;
	if (wx.x==2) CurrentRefl = CubeD.rgb;
	if (wx.x==3) CurrentRefl = CubeD.rgb;
	if (wx.x==4) CurrentRefl = CubeD.rgb;
	
	
    float4 CubeN = texCUBE(ReflNightSampler, -refl.xzy);
	       CubeN.rgb*= 2.2*float3(0.82, 0.95, 1.05);

	float3 cb = lerp(CubeN.xyz, CubeN.xyz, x1);
		   cb = lerp(cb, CubeN.xyz, x2);
		   cb = lerp(cb, CurrentRefl.xyz*0.92, x3);
		   cb = lerp(cb, CurrentRefl.xyz, x6);
		   cb = lerp(cb, CurrentRefl.xyz*0.85, x7);
		   cb = lerp(cb, CurrentRefl.xyz*0.8, xG);		   
		   cb = lerp(cb, CubeN.xyz, xZ);		   
		   cb = lerp(cb, CubeN.xyz, x8);
		   
	float3 n0 = normalize(cb.xyz);
	float3 ct0=cb.xyz/n0.xyz;
	       ct0=pow(ct0, 2.0);
           n0.xyz = pow(n0.xyz, 1.8);   
           cb.xyz = ct0*n0.xyz;  
           cb.xyz*= 1.25;			   
	
	float fresnel = 0.001*1.0-dot(npos, -camdir);		
		  fresnel = saturate(pow(fresnel, 0.37*0.15));		  
  		  
   float m0 = lerp(0.20, 0.20, x1);
         m0 = lerp(m0, 0.10, x2);
         m0 = lerp(m0, 0.0, x3);
         m0 = lerp(m0, 0.0, x4);
         m0 = lerp(m0, 0.0, x5);
         m0 = lerp(m0, 0.0, x6);
         m0 = lerp(m0, 0.0, x7);		 
         m0 = lerp(m0, 0.20, x8);
		
    float3 MoonVector = normalize(float3(-0.00732, -0.39, 0.317));
    float m1 = saturate(0.001 + dot(normalize(-MoonVector-camdir), -npos.xyz));	
		  m1 = pow(m1, 35.0);
    float3 moon = (m1*m1)*m0*2.0;		  
	   
    float mix2 = lerp(0.9, 5.0, texelA);		 
    float4 texel2 = tex2D(Sampler0, PS.TexCoord);	
	
	float4 Lighting1 = ColorCar*PS.Light*0.9;

  	float4 diffuse  = gDiffuseMaterialSource  == 0 ? ColorCar  : 1;

/*	
  float3 CL1 = float3(0.6, 0.8, 1.1)*1.1;
  float3 CL2 = float3(0.9, 0.95, 1.0); 
  float3 CL0 = lerp(CL1, CL1, x1);
         CL0 = lerp(CL0, float3(0.65, 0.83, 1.05), x2);
         CL0 = lerp(CL0, CL2, x3);
         CL0 = lerp(CL0, 1.0, x4);
         CL0 = lerp(CL0, 1.0, xE);
         CL0 = lerp(CL0, 1.0, x5);
         CL0 = lerp(CL0, float3(0.90, 0.95, 1.0), x6);
         CL0 = lerp(CL0, float3(0.66, 0.84, 1.04)*0.9, x7);
         CL0 = lerp(CL0, CL1, x8);
		 
  float3 CV0 = lerp(float3(0.75, 0.85, 1.0), float3(0.75, 0.85, 1.0), x1);
         CV0 = lerp(CV0, float3(0.75, 0.85, 1.0), x2);
         CV0 = lerp(CV0, 1.0, x3);
         CV0 = lerp(CV0, 1.0, x4);
         CV0 = lerp(CV0, 1.0, xE);
         CV0 = lerp(CV0, 1.0, x5);
         CV0 = lerp(CV0, 1.0, x6);
         CV0 = lerp(CV0, 1.0, x7);
         CV0 = lerp(CV0, float3(0.75, 0.85, 1.0), x8);		 
		 

float3 CurrentWeather = 1.0;

if (wx.x==0) CurrentWeather = CL0;
if (wx.x==1) CurrentWeather = CL0;
if (wx.x==2) CurrentWeather = CL0;
if (wx.x==3) CurrentWeather = CL0;
if (wx.x==4) CurrentWeather = CL0; 	

if (wx.x==7) CurrentWeather = CL0;
if (wx.x==8) CurrentWeather = CL0;
if (wx.x==9) CurrentWeather = CL0;

if (wx.x==12) CurrentWeather = CL0;
if (wx.x==15) CurrentWeather = CL0;
if (wx.x==16) CurrentWeather = CL0;	  

if (wx.x==5) CurrentWeather = CV0;
if (wx.x==6) CurrentWeather = CV0;
 
if (wx.x==10) CurrentWeather = CV0; 		 
if (wx.x==11) CurrentWeather = CV0; 
if (wx.x==13) CurrentWeather = CV0; 	
if (wx.x==14) CurrentWeather = CV0; 
if (wx.x==17) CurrentWeather = CV0; 
*/
    float Stg = ((texel.a <=0.9999) || PS.Material);

    float4 DiffAmb = PS.AmbC*2.0;
  if (Stg) DiffAmb = ColorCar*0.3;
	   
	float4 finalColor2 = float4((DiffAmb.rgb+Lighting1.rgb)*texel2.rgb*0.9, min(diffuse.a, texel2.a));	
	   
    float3 specmix2 = lerp(specular3*1.5, specular3*finalColor2*1.5, 0.80);	
		

   float factor3 = 0.1 - dot(-vView, npos);
         factor3 = pow(factor3, 0.65);
   float fr3 = (factor3*factor3); 
         fr3/= 2.5;	
         fr3 = saturate(fr3*2.6);	
         fr3 = lerp(1.0, fr3, 0.35);		

           finalColor2.rgb*= fr3;			
		
           finalColor2.rgb*= (lighting);				   
           finalColor2.rgb+= specmix2*bl0*0.7; 
           finalColor2.rgb+= moon*float3(0.85, 0.95, 1.1)*0.5;	
           finalColor2.rgb+= saturate(lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92)*0.7);				   


		   
    //finalColor2.rgb+= lerp(lerp(fresnelz*2.4, finalColor2.xyz*fresnelz*1.2, 0.92), 0.0, saturate(lighting2));			
    //finalColor2.rgb+= lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92);		
	
	float fresnelx = 0.001-dot(-vView, npos);		
		  fresnelx = saturate(pow(fresnelx, 0.37));
		  fresnelx = lerp(1.0, 0.0, 0.92*fresnelx);	

   float sp1 = lerp(0.2, 0.2, x1);
         sp1 = lerp(sp1, 0.2, x2);
         sp1 = lerp(sp1, 0.6, x3);
         sp1 = lerp(sp1, 0.8, x4);
         sp1 = lerp(sp1, 0.9, x5);
         sp1 = lerp(sp1, 0.6, x6);
         sp1 = lerp(sp1, 0.5, x7);
         sp1 = lerp(sp1, 0.2, xG);	
         sp1 = lerp(sp1, 0.2, xZ);			 
         sp1 = lerp(sp1, 0.2, x8);	
		  		   

		   
	
  float3 v = {0.6, 0.6, 0.95};
  float3 v2 = {0.9, 0.9, 1.0};  
  
  float3 n = normalize(npos.xyz*v);		 
  float3 ref0 = reflect(vView.xyz, n.xyz);		 
  //float3 n1 = ((1000.0/0.01)*n0)/1000.0;		
  float3 ref2 = (1.0*ref0)/0.5;	  
  
  float3 r0 = (vView.xyz+ref2)*0.95;	
  float2 r1 = wpd2(r0.xyz);		
	
	float2 rc = r1.xy;		
	
    float4 envMap = tex2D(SamplerColor, rc);
	       envMap.w = rc.y<0.0||rc.y>1.0 ? 0.0:1.0; 
	       envMap.w*= rc.x<0.0||rc.x>1.0 ? 0.0:1.0;

	float c08 = 6.7;
	float c07 = 1.0;

	float nf02 = saturate(c08*(r1.y));
          nf02*= saturate(c08*(r1.x));					
	      nf02 = pow(nf02, c07);			
	float nf03 = saturate(c08+r1.y*(-c08));
          nf03*= saturate(c08+r1.x*(-c08));					
	      nf03 = pow(nf03, c07);
	
	float fresnelR = 0.01-dot(npos, -camdir);		
		  fresnelR = saturate(pow(fresnelR, 4.0));	

		    cb = lerp(cb, envMap.xyz*3.3,  envMap.w*nf02*nf03*pow(0.01*0.5, fresnelR));	
    float3 reflection = lerp(1.12*cb+(gl*sp0*4.0), finalColor2.rgb, 0.97*fresnel);

    //float3 AtmSky = getSky(GameTime, wx, wpos, wpos2);	
		   
           finalColor2.rgb = lerp(finalColor2.rgb+fresnelx*0.27*sp1*float3(0.92, 0.96, 1.0), reflection, Stg); //
		   
    //finalColor2.rgb = GetCorrection(finalColor2.rgb*2.0);		   

		   
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////  Снег  ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
	float4 objspacepos	= PS.invTex;
	// Triplanar uvs
    float2 uvX = objspacepos.yz; // x facing plane
    float2 uvY = objspacepos.xz; // y facing plane	
    float2 uvZ = objspacepos.xy; // z facing plane   

	float3 wnorm = normalize(cross(ddx(objspacepos.xyz),ddy(objspacepos.xyz)));  

    float3 blending = pow(abs(wnorm.xyz), 3.0);
 	       blending = blending / (blending.x + blending.y + blending.z);	
		   
    float3 blending2 = pow(abs(npos.xyz*float3(22.0, 22.0, 10.0)), 2.2);
 	       blending2 = blending2 / (blending2.x + blending2.y + blending2.z);		
		   	   
		float3 R1x = tex2D(SamplerSnow, uvX);
		float3 R1y = tex2D(SamplerSnow, uvY);		
		float3 R1z = tex2D(SamplerSnow, uvZ);

		float3 Ax = tex2D(SamplerSnowA, uvX);
		float3 Ay = tex2D(SamplerSnowA, uvY);		
		float3 Az = tex2D(SamplerSnowA, uvZ);
		
		float3 Shx = tex2D(SamplerShine, uvX);
		float3 Shy = tex2D(SamplerShine, uvY);		
		float3 Shz = tex2D(SamplerShine, uvZ);	
		
	float ShineMix = Shx*blending.x + Shy*blending.y + Shz*blending.z; 		   

    float3 vw = normalize(float3(0,0,1));
    float sAl = saturate(0.01-dot(vw, -npos));
		  sAl = pow(sAl, 0.2);	//1		   

		  
	float3 SnowMix = R1x*blending.x + R1y*blending.y + R1z*blending.z; 	 		
	float SnowMixA = Ax*blending.x + Ay*blending.y + Az*blending.z; 

	float Glass = pow(ColorCar.a, 0.5);
	float3 Lighting2 = PS.Light*0.9; 
	
   float3 dfsn = lerp(0.45*float3(0.78, 0.90, 1.02), 0.45*float3(0.78, 0.90, 1.02), x1);
          dfsn = lerp(dfsn, 0.8*float3(0.90, 0.95, 1.02), x2);
          dfsn = lerp(dfsn, 1.05*float3(1.0, 0.99, 0.95), x3);
          dfsn = lerp(dfsn, 1.11*float3(1.0, 0.99, 0.95), x4);
          dfsn = lerp(dfsn, 1.15*float3(1.02, 0.99, 0.95), xE);
          dfsn = lerp(dfsn, 1.15*float3(1.02, 0.99, 0.95), x5);
          dfsn = lerp(dfsn, 1.12*float3(1.05, 0.90, 0.80), x6);
          dfsn = lerp(dfsn, 0.9*float3(0.93, 0.90, 0.95), x7);
          dfsn = lerp(dfsn, 0.6*float3(0.90, 0.95, 1.02), xG);	
          dfsn = lerp(dfsn, 0.5*float3(0.90, 0.95, 1.02), xZ);			  
          dfsn = lerp(dfsn, 0.45*float3(0.82, 0.90, 1.02), x8); 
		  
   float3 dfn = lerp(0.45*float3(0.92, 0.96, 1.03), 0.45*float3(0.92, 0.96, 1.03), x1);
          dfn = lerp(dfn, 0.52*float3(0.92, 0.96, 1.02), x2);
          dfn = lerp(dfn, 0.8*float3(0.95, 0.97, 1.00), x3);
          dfn = lerp(dfn, 0.85, x4);
          dfn = lerp(dfn, 0.85, xE);
          dfn = lerp(dfn, 0.85, x5);
          dfn = lerp(dfn, 0.85, x6);
          dfn = lerp(dfn, 0.7*float3(0.94, 0.96, 1.01), x7);
          dfn = lerp(dfn, 0.6*float3(0.92, 0.96, 1.02), xG);	
          dfn = lerp(dfn, 0.5*float3(0.90, 0.96, 1.02), xZ);			  
          dfn = lerp(dfn, 0.45*float3(0.90, 0.96, 1.02), x8); 		  
		  dfn*=float3(0.92, 0.96, 1.03);

    if (wx.x==2) dfsn = dfn;
    if (wx.x==3) dfsn = dfn;		  
    if (wx.x==4) dfsn = dfn;
    if (wx.x==7) dfsn = dfn;
    if (wx.x==8) dfsn = dfn;
    if (wx.x==9) dfsn = dfn;
    if (wx.x==12) dfsn = dfn;
    if (wx.x==15) dfsn = dfn;
    if (wx.x==16) dfsn = dfn;	
		  
 if (Stg) finalColor2.rgb+= lerp(0.0, 1.6*(moon*float3(0.85, 0.95, 1.1)*3.5) + specular3*bl0*4.5, ShineMix*saturate(blending2.z+SnowMixA*2.0*blending2.z)*Glass*sAl);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////  Снег  ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

	float3 TM0 = GetCorrection(finalColor2.rgb*0.9);
	float3 TM1 = Uncharted2Tonemap(finalColor2.rgb*0.9);	
	       finalColor2.rgb = lerp(TM0, TM1, 0.00);			   
	
           finalColor2.rgb = saturate(finalColor2.rgb);
           finalColor2.rgb = pow(finalColor2.rgb, 1.25);

           finalColor2.a*= ColorCar.a; //1
    return finalColor2;
}

////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////RADMIR/////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

technique tec0
{
    pass P0
    {
        VertexShader = compile vs_3_0 VertexShaderFunction();	
        PixelShader = compile ps_3_0 PS_Reflection();
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
    
]]