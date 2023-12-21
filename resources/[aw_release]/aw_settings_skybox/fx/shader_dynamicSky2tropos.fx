//
// shader_dynamicSky2clouds.fx
// Author: Ren712/AngerMAN
//

//------------------------------------------------------------------------------------------
//-- Settings
//------------------------------------------------------------------------------------------
float gDayTime = 0;
float mMoonLightInt = 1;
bool gIsInWater = false;
float3 gScale = float3(1, 1, 1);
float gRescale = 1;
float2x3 gSunColor = {0,0,0,0,0,0};
float3 gRotate = float3(0,0,0);
float3 mRotate = float3(0,0,0);
float gCloudSpeed = 0.0;
float2 gStratosFade = float2(14000, 10000);
float gAlphaMult = 1;
float gBottCloudSpread = 500;
bool gHorizonBlending = true;

float GameTime = 24;
float currentWeather = 0;
float3 WeatherAndTime;

texture sNs;
texture sNs2;
texture sNs4;
texture sNs5;
texture sStars;
texture sMoon1;
//------------------------------------------------------------------------------------------
//-- Include some common things
//------------------------------------------------------------------------------------------
float4x4 gWorld : WORLD;
float4x4 gView : VIEW;

float4x4 gViewInverse : VIEWINVERSE;
float4x4 gWorldInverseTranspose : WORLDINVERSETRANSPOSE;
float4x4 gViewInverseTranspose : VIEWINVERSETRANSPOSE;

float4x4 gProjection : PROJECTION;
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float3 gCameraPosition : CAMERAPOSITION;
float3 gCameraDirection : CAMERADIRECTION;
matrix gProjectionMainScene : PROJECTION_MAIN_SCENE;
int gFogEnable < string renderState="FOGENABLE"; >;
float4 gFogColor < string renderState="FOGCOLOR"; >;
float gFogStart < string renderState="FOGSTART"; >;
float gTime : TIME;
int CUSTOMFLAGS < string skipUnusedParameters = "yes"; >;

//------------------------------------------------------------------------------------------
//-- Sampler for the main texture (needed for pixel shaders)
//------------------------------------------------------------------------------------------
sampler2D SamplerNs = sampler_state
{
   Texture   = <sNs>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerNs2 = sampler_state
{
   Texture   = <sNs2>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerNs4 = sampler_state
{
   Texture   = <sNs4>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerNs5 = sampler_state
{
   Texture   = <sNs5>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerStars = sampler_state
{
   Texture   = <sStars>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler2D SamplerMoon = sampler_state
{
   Texture = <sMoon1>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = NONE;
    AddressU = Clamp;
    AddressV = Clamp;
};

//------------------------------------------------------------------------------------------
//-- Structure of data sent to the vertex shader
//------------------------------------------------------------------------------------------
 struct VSInput
{
    float4 Position : POSITION; 
    float3 TexCoord : TEXCOORD0;
};

//------------------------------------------------------------------------------------------
//-- Structure of data sent to the pixel shader ( from the vertex shader )
//------------------------------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION; 
    float3 TexCoord0 : TEXCOORD0;
    float3 TexCoord1 : TEXCOORD1;
    float3 TexCoord2 : TEXCOORD2;
    float3 TexCoord3 : TEXCOORD3;
    float3 NightFade : TEXCOORD4;
    float3 LimitDot : TEXCOORD5;
    float4 WorldPos : TEXCOORD6;
    float3 PositionVS : TEXCOORD7;
};

//------------------------------------------------------------------------------------------
//-- eulerRotate
//------------------------------------------------------------------------------------------
float3x3 eulerRotate(float3 Rotate)
{
    float cosX,sinX;
    float cosY,sinY;
    float cosZ,sinZ;
	
    sincos(Rotate.x ,sinX,cosX);
    sincos(-Rotate.y ,sinY,cosY);
    sincos(Rotate.z ,sinZ,cosZ);

    return float3x3(
		cosY * cosZ + sinX * sinY * sinZ, -cosX * sinZ,  sinX * cosY * sinZ - sinY * cosZ,
		cosY * sinZ - sinX * sinY * cosZ,  cosX * cosZ, -sinY * sinZ - sinX * cosY * cosZ,
		cosX * sinY,                       sinX,         cosX * cosY
	);
}

//------------------------------------------------------------------------------------------
// MTAUnlerp
//------------------------------------------------------------------------------------------
float MTAUnlerp( float from, float to, float pos )
{
    if ( from == to )
        return 1.0;
    else
        return ( pos - from ) / ( to - from );
}

//------------------------------------------------------------------------------------------
//-- VertexShader
//------------------------------------------------------------------------------------------
PSInput VertexShaderSB(VSInput VS)
{
    PSInput PS = (PSInput)0;	
    PS.PositionVS = VS.Position.xyz;
    float farClip = gProjectionMainScene[3][2] / (1 - gProjectionMainScene[2][2]);
    if ((gFogEnable) && (gIsInWater)) farClip = min(gFogStart, farClip);
    VS.Position.xyz *= gScale * max(230, farClip) * 0.31 * gRescale;
    float4x4 sWorld = gWorld; sWorld[3].xyz = float3(0,0,0);
    float4 mulWorld = mul(VS.Position, sWorld);
    float4x4 sView = gView; sView[3].xyz = float3(0,0,0);
    float4 mulView = mul( mulWorld, sView);
    PS.Position = mul(mulView, gProjection);
    PS.TexCoord1 = normalize(mul(eulerRotate(gRotate), VS.Position.xyz));
    PS.TexCoord2 = normalize(mul(eulerRotate(mRotate), VS.Position.xyz)) * 8;
    PS.WorldPos = mul(VS.Position, sWorld);
    float3 eyeVector = normalize(PS.WorldPos.xyz - 0); 		 
    PS.TexCoord3 = mul(eulerRotate(gRotate), eyeVector.xyz* float3(19.0, 19.0, 19.0));	
    float2 move = float2(gCameraPosition.x * 0.00001, gCameraPosition.z * 0.0005);
    PS.TexCoord0 = VS.TexCoord - float3(move.x, move.y, 0);
    PS.NightFade.x = saturate(MTAUnlerp(gStratosFade[1], gStratosFade[1] - 2000, gCameraPosition.z));
    PS.NightFade.y = saturate(dot( float3(0,0,-1), PS.TexCoord2));
    PS.NightFade.z = saturate(MTAUnlerp(farClip + abs(gBottCloudSpread) + 50, farClip + 50, gCameraPosition.z));
	
    if (gHorizonBlending) PS.LimitDot.x = saturate(2.2 * PS.PositionVS.z);
        else PS.LimitDot.x = 1.0;
    float topDot = dot(float3(0,0,1), PS.PositionVS.xyz);	
    PS.LimitDot.y = 1 - saturate(pow(max(0.0001, topDot), 6.4) * 0.001);
    PS.LimitDot.z = dot(float3(0,0,-1), normalize(PS.TexCoord2));	
    return PS;
}

//------------------------------------------------------------------------------------------
// Structure of color data sent to the renderer ( from the pixel shader  )
//------------------------------------------------------------------------------------------
struct Pixel
{
    float4 World : COLOR0;      // Render target #0
    float Depth : DEPTH;        // Depth target
};

//------------------------------------------------------------------------------------------
//-- PixelShader
//------------------------------------------------------------------------------------------

float Coverage(in float v, in float d, in float c)
{
	c = clamp(c - (1.0 - v), 0.0, 1.0 - d)/(1.0 - d);
	c = max(0.0, c * 1.1 - 0.1);
	c = c = c * c * (3.0 - 2.0 * c);
	return c;
}

float Noise1x(in float2 p)
{	
    float t = (gTime * 0.05)* 2.2;
    p.xy += 1.0 * t;
    float2 uv = (p * float2(17.2, 17.2));	
	float2 c = (uv  + 0.5) / 20.0;
    float r0 = tex2D(SamplerNs, c*0.04);
    float r1 = tex2D(SamplerNs2, c*0.02);
		
float wx = currentWeather;
float CovCurrent;
if (wx.x==0,1) CovCurrent = r0;
if (wx.x==0) CovCurrent = r0;
if (wx.x==1) CovCurrent = r0;
if (wx.x==2) CovCurrent = 0.0;
if (wx.x==3) CovCurrent = r1;
if (wx.x==5) CovCurrent = r0;
if (wx.x==6) CovCurrent = 0.0;
if (wx.x==10) CovCurrent = 0.0;
if (wx.x==11) CovCurrent = r1;
if (wx.x==13) CovCurrent = r0; 
if (wx.x==14) CovCurrent = r1;
if (wx.x==17) CovCurrent = r1;
if (wx.x==18) CovCurrent = r0;
		
	return CovCurrent;
}


float Noise2x(in float2 p)
{	
    float t = (gTime * 0.065)* 2.12; // 
	p.xy += 1.0 * t;
    float2 uv = (p * float2(17.2, 17.2));
	float2 c = (uv + 0.5) / 20.0;
    float r0 = tex2D(SamplerNs2, c*0.04);
    float r1 = tex2D(SamplerNs4, c*0.04);
    float r2 = tex2D(SamplerNs5, c*0.02);
	
float wx = currentWeather;
float CovCurrent;

if (wx.x==0,1) CovCurrent = r0;
if (wx.x==0) CovCurrent = r0;
if (wx.x==1) CovCurrent = r0;
if (wx.x==2) CovCurrent = 0.0;
if (wx.x==3) CovCurrent = r2;
if (wx.x==5) CovCurrent = r0;
if (wx.x==6) CovCurrent = 0.0;
if (wx.x==10) CovCurrent = 0.0;
if (wx.x==11) CovCurrent = r1;
if (wx.x==13) CovCurrent = r0;  
if (wx.x==14) CovCurrent = r2; 
if (wx.x==17) CovCurrent = r2; 
if (wx.x==18) CovCurrent = r0; 
	
	return r0;
}

float SunLight(float3 worldP)
{

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

   float3 v0= f.xyz;
   float3 v2= normalize(float3(-0.09, -0.94, 0.31));	
   float t0 = GameTime;
   float x1 = smoothstep(0.0, 4.0, t0);	
   float x2 = smoothstep(4.0, 23.0, t0);
   float x3 = smoothstep(23.0, 24.0, t0);	
   
   float3 sv = lerp(v2, v0, x1);
          sv = lerp(sv, v0, x2);
          sv = lerp(sv, v2, x3);
		  
   float3 np = normalize(worldP.xyz);
   float f0 = 0.95 - dot(-sv, np);
         f0 = pow(f0, 6.07);
   float r0 = (f0*f0);
   
   return r0/40000.0;
}


float4 GenerateClouds(float3 worldpos, in float3 sunlight)
{

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

	float t = (gTime * 0.02)*0.2;	//
	float3 vecm = normalize(float3(-0.09, -0.94, 0.31));
    float3 sv0=-f.xyz;
    float3 sv2=-vecm;
	
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
   float x8 = smoothstep(22.0, 23.0, t0);
   float x9 = smoothstep(23.0, 24.0, t0);
   float x10 = smoothstep(4.0, 23.0, t0);
   float x11 = smoothstep(23.0, 24.0, t0);	
   
   float3 sv = lerp(sv2, sv0, x1);
          sv = lerp(sv, sv0, x10);
          sv = lerp(sv, sv2, x11);	  	
	
	float3 wp = worldpos/1.5;
		   wp.x *= 0.1;
		   wp.y *= 0.15;	
		   wp.y -= t * 0.01;	
	float3 wp1 = wp * float3(1.0, 0.5, 1.0) + float3(0.0, t * 0.01, 0.0);
	
	float noise  = 	Noise2x(wp * float3(1.0, 0.5, 1.0) + float3(0.0, t * 0.01, 0.0));
		   wp *= 3.0;
		   wp.xy -= t * 0.05;
		   wp.x += 2.0;
	float3 wp2 = wp;
	
		   wp.x *= 2.0;
		   wp.y *= 2.0;	
	
	
		  noise += (2.0 - abs(Noise1x(wp) * 0.8)) * 0.25;
		   wp.xy*= 10.0;
		   wp.xy -= t * 0.035;
	float3 wp3 = wp;
		  
          noise += (2.0 - abs(Noise1x(wp) * 1.0)) * 0.03;
		  noise /= 0.80;
		  
float wx = currentWeather;
float CovCurrent;
float fcc = 0.38;
if (wx.x==0,1) CovCurrent = fcc;

if (wx.x==0) CovCurrent = 0.20;
if (wx.x==1) CovCurrent = fcc;
if (wx.x==2) CovCurrent = 0.00;
if (wx.x==3) CovCurrent = 0.50;
if (wx.x==5) CovCurrent = fcc;
if (wx.x==6) CovCurrent = 0.45;
if (wx.x==10) CovCurrent = 0.00;
if (wx.x==11) CovCurrent = 0.30;
if (wx.x==13) CovCurrent = 0.30;  
if (wx.x==14) CovCurrent = fcc; 
if (wx.x==17) CovCurrent = fcc; 
if (wx.x==18) CovCurrent = fcc; 

if (wx.x==4) CovCurrent = 1.70;
if (wx.x==7) CovCurrent = 1.70;
if (wx.x==8) CovCurrent = 1.70;
if (wx.x==9) CovCurrent = 1.70;
if (wx.x==12) CovCurrent = 1.70;
if (wx.x==15) CovCurrent = 1.70;
if (wx.x==16) CovCurrent = 1.70;	  
		  
		float ti = max(sin(gTime*100.0*0.01),0);  
		  	  
	float coverage = CovCurrent;	  	
	float dn = 0.1 - 0.3 * 0.3;  
	noise = Coverage(coverage, dn, noise);
	
	float d0 = Noise2x(wp1 + sv.xyz * 0.70 / 2.3);
		  d0 += (2.0 - abs(Noise2x(wp2 + sv.xyz * 0.70 / 2.3) * 0.8)) * 0.10;	
		  d0 += (2.0 - abs(Noise1x(wp3 + sv.xyz * 0.70 / 2.3) * 1.0)) * 0.02; 
	      d0 = Coverage(0.64, dn, d0);
	
	float bf = lerp(clamp(pow(noise, 0.5) * 1.0, 0.0, 1.0), 0.5, pow(sunlight, 1.0));
		  d0 *= bf;	
			  
   float3 lt = lerp(float3(0.0275, 0.0353, 0.0471)*5.8, float3(0.0275, 0.0353, 0.0471)*5.8, x1);
          lt = lerp(lt, float3(0.7, 0.6, 0.6)*0.4, x2);
          lt = lerp(lt, float3(1.0, 0.727, 0.535), x3);
          lt = lerp(lt, float3(1.0, 0.9, 0.8), x4);
          lt = lerp(lt, float3(1.0, 1.0, 1.0), xE);
          lt = lerp(lt, float3(1.0, 1.0, 1.0), x5);
          lt = lerp(lt, float3(1.0, 0.727, 0.535), x6);		 
          lt = lerp(lt, float3(1.0, 0.727, 0.535), x7);
		  lt = lerp(lt, 0.5, xG);
		  lt = lerp(lt, 0.3, xZ);
          lt = lerp(lt, 0.1, x8);
          lt = lerp(lt, float3(0.0275, 0.0353, 0.0471)*5.8, x9);

   float3 ShColor = float3(0.094, 0.106, 0.118);		  

   float3 sh = lerp(float3(0.051, 0.0784, 0.118)*0.6, float3(0.03, 0.04, 0.05)*0.6, x1);
          sh = lerp(sh, ShColor*0.7, x2);
          sh = lerp(sh, ShColor*3.5, x3);
          sh = lerp(sh, ShColor*4.1, x4);
          sh = lerp(sh, float3(0.380, 0.397, 0.425)*1.15, xE);
          sh = lerp(sh, float3(0.380, 0.397, 0.325)*1.15, x5);
          sh = lerp(sh, ShColor*3.5, x6);	 
          sh = lerp(sh, ShColor*3.5, x7);
		  sh = lerp(sh, ShColor*3.5, xG);
		  sh = lerp(sh, ShColor*2.6, xZ);
          sh = lerp(sh, ShColor*1.4, x8);
          sh = lerp(sh, float3(0.051, 0.0784, 0.118)*0.6, x9);	

   float3 fmix = lerp(0.02, 0.1, x1);
          fmix = lerp(fmix, 0.1, x2);
          fmix = lerp(fmix, 0.2, x3);			  
          fmix = lerp(fmix, 0.5, x4);
          fmix = lerp(fmix, 0.5, xE);
          fmix = lerp(fmix, 0.5, x5);
          fmix = lerp(fmix, 0.3, x6);
          fmix = lerp(fmix, 0.2, x7); 
          fmix = lerp(fmix, 0.1, xG);	
          fmix = lerp(fmix, 0.05, xZ);
          fmix = lerp(fmix, 0.03, x8);	  
          fmix = lerp(fmix, 0.02, x9);		  
			  
   float3 fmix2 = lerp(0.01, 0.1, x1);
          fmix2 = lerp(fmix2, 0.05, x2);
          fmix2 = lerp(fmix2, 0.1, x3);			  
          fmix2 = lerp(fmix2, 0.2, x4);
          fmix2 = lerp(fmix2, 0.2, xE);
          fmix2 = lerp(fmix2, 0.2, x5);
          fmix2 = lerp(fmix2, 0.1, x6);
          fmix2 = lerp(fmix2, 0.08, x7); 
          fmix2 = lerp(fmix2, 0.05, xG);	
          fmix2 = lerp(fmix2, 0.03, xZ);
          fmix2 = lerp(fmix2, 0.02, x8);	  
          fmix2 = lerp(fmix2, 0.01, x9);
          fmix2*= 2.0;		  
   float3 ColorSun = lerp(float3(0.0392, 0.0588, 0.0784)*4.0, float3(0.05, 0.04, 0.02)*4.0, x1);
          ColorSun = lerp(ColorSun, float3(0.0392, 0.0588, 0.0784)*0.8, x2);
          ColorSun = lerp(ColorSun, float3(0.45, 0.07, 0.0), x3);
          ColorSun = lerp(ColorSun, float3(0.392, 0.275, 0.118)*0.3, x4);
          ColorSun = lerp(ColorSun, float3(0.392, 0.275, 0.118)*0.2, xE);
          ColorSun = lerp(ColorSun, float3(0.392, 0.275, 0.118)*0.2, x5);
          ColorSun = lerp(ColorSun, float3(0.392, 0.08, 0.0), x6); 
          ColorSun = lerp(ColorSun, float3(0.392, 0.08, 0.0), x7);
		  ColorSun = lerp(ColorSun, float3(0.392, 0.118, 0.0588), xG);
		  ColorSun = lerp(ColorSun, float3(0.392, 0.118, 0.0588)*0.4, xZ);
          ColorSun = lerp(ColorSun, float3(0.392, 0.118, 0.0588)*0.4, x8);		  
          ColorSun = lerp(ColorSun, float3(0.0392, 0.0588, 0.0784)*4.0, x9);

 float3 m0 = float3(min(1.0, d0), min(1.0, d0), min(1.0, d0));
 float3 color = lerp((pow(sunlight, 0.2)*ColorSun*2.0)+lt*0.60, sh*1.1, m0);
 
 float3 colorPasm = lerp(fmix, fmix2, m0);
 
float3 SunCurrent; 
if (wx.x==0,1) SunCurrent = color;


if (wx.x==4) SunCurrent = colorPasm;
if (wx.x==7) SunCurrent = colorPasm;
if (wx.x==8) SunCurrent = colorPasm;
if (wx.x==9) SunCurrent = colorPasm;
if (wx.x==12) SunCurrent = colorPasm;
if (wx.x==15) SunCurrent = colorPasm;
if (wx.x==16) SunCurrent = colorPasm;

 
	float4 r0 = float4(SunCurrent.rgb, (noise*noise*noise));
	return r0;

}

float IntersectPlane(float3 pos, float3 dir)
{
	return -pos.z/dir.z;
}

float Stars(in float2 coord)
{	
    float2 uv = coord.xy;
	float2 p = (uv) / (0.05*2.0);
	float fstars = tex2D(SamplerStars, p);
	return fstars;
}

float Moon(in float2 coord)
{	
    float2 uv = coord.xy + 0.1 * 1.5;
	float2 p = (uv + 0.5) / (-3.25*2.0);
	float fmoon = tex2D(SamplerMoon, p);
	return fmoon*1.5;
}

/**/
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------

float4 CalculateSun(float3 worldp)
{
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
		
    float3 sv = f.xyz;
    float3 sv2 = normalize(float3(-0.0833, -0.946, 0.317));
	
   float t = GameTime;	
	
   float x1 = smoothstep(0.0, 4.0, t);
   float x2 = smoothstep(4.0, 5.0, t);
   float x3 = smoothstep(5.0, 6.0, t);
   float x4 = smoothstep(6.0, 7.0, t);
   float xE = smoothstep(8.0, 11.0, t);
   float x5 = smoothstep(16.0, 17.0, t);
   float x6 = smoothstep(18.0, 19.0, t);
   float x7 = smoothstep(19.0, 20.0, t);
   float xG = smoothstep(20.0, 21.0, t);  
   float xZ = smoothstep(21.0, 22.0, t);
   float x8 = smoothstep(22.0, 23.0, t);
   float x9 = smoothstep(23.0, 24.0, t);

   float3 SC0 = float3(0.9, 0.7, 0.6);   
   float3 t0 = lerp(0.0, 0.0, x1);
          t0 = lerp(t0, SC0*SC0*0.5, x2);
          t0 = lerp(t0, SC0*SC0*2.7, x3);
          t0 = lerp(t0, float3(1.0, 0.863, 0.549), x4);
          t0 = lerp(t0, float3(1.0, 0.863, 0.549), xE);
          t0 = lerp(t0, float3(1.0, 0.863, 0.549), x5);
          t0 = lerp(t0, SC0*SC0*2.0, x6);	 
          t0 = lerp(t0, SC0*SC0*0.8, x7);
		  t0 = lerp(t0, SC0*0.6, xG);
		  t0 = lerp(t0, SC0*0.4, xZ);
          t0 = lerp(t0, SC0*0.2, x8);
          t0 = lerp(t0, 0.0, x9);	

   float3 SC3 = float3(0.9, 0.7, 0.6); 		  
   float3 t3 = lerp(0.0, 0.0, x1);
          t3 = lerp(t3, SC3*SC3*0.5, x2);
          t3 = lerp(t3, SC3*SC3*2.7, x3);
          t3 = lerp(t3, float3(1.1, 0.7, 0.6)*2.0, x4);
          t3 = lerp(t3, float3(1.0, 1.0, 1.0)*2.0, xE);
          t3 = lerp(t3, float3(1.0, 1.0, 1.0)*2.0, x5);
          t3 = lerp(t3, SC3*SC3*2.7, x6);		 
          t3 = lerp(t3, SC3*SC3*0.8, x7);
		  t3 = lerp(t3, SC3*0.6, xG);
		  t3 = lerp(t3, SC3*0.4, xZ);
          t3 = lerp(t3, SC3*0.2, x8);
          t3 = lerp(t3, 0.0, x9); 	
   
   float3 wp = worldp;
   float c0 = 475.0 * 25.0;
   float c1 = 18.0;
   float c2 = 1.35;
   
   float3 np0 = normalize(wp.xyz);
   float factor = (0.01/12.0) - dot(-sv, np0);
         factor = pow(factor, c0);
   float factor1 = 0.04 - dot(-sv, np0);
         factor1 = pow(factor1, c1);	
   float factor2 = 0.6 - dot(-sv, np0);
         factor2 = pow(factor2, c2);
		 
   float factor3 = 0.04 - dot(-sv2, np0);
         factor3 = pow(factor3, c1);	
   float factor4 = 0.6 - dot(-sv2, np0);
         factor4 = pow(factor4, c2);		 
		 
   float3 f0 = factor/12.0;
   float3 f1 = (factor1*factor1)/5.0;    
   float3 f2 = (factor2*factor2)/10.0;
   
   float3 f1x = (factor3*factor3)/5.0;    
   float3 f2x = (factor4*factor4)/10.0;   
   float3 fnight = (f1x*float3(0.0863, 0.137, 0.176))+(f2x*float3(0.0, 0.0, 0.0));     
		  fnight*= smoothstep(0.0, 0.3, -np0.y);   
   
   float y1 = smoothstep(0.0, 2.0, t);
   float yZ = smoothstep(2.0, 3.0, t);   
   float y2 = smoothstep(4.0, 23.0, t);
   float y3 = smoothstep(23.0, 24.0, t);   
   
  float3 t4 = lerp(0.0, 0.0, y1);
         t4 = lerp(t4, float3(0.0392, 0.0335, 0.027), yZ);  
         t4 = lerp(t4, float3(0.0392, 0.0235, 0.027), y2);
         t4 = lerp(t4, 0.0, y3);
		 
  float3 t5 = lerp(1.0, 0.5, y1);
         t5 = lerp(t5, 0.0, yZ);  
         t5 = lerp(t5, 0.0, y2);
         t5 = lerp(t5, 1.0, y3);	 
 
   float3 wp0 = wp; //  gCameraPosition
   float3 np1 = normalize(wp0.xyz);
   float4 f3 = 1.0;
          f3.xyz = lerp(0.0, (f0*t4), smoothstep(0.0, 0.02, np1.z))+(f1*t0*0.05) +(f2*t3*0.8)+(fnight*t5*5.0); // +(f1*t0)+(f2*t3)+(fnight*t5);
		  
   float sA = f3.xyz;		  
		  f3.a = lerp(0.0, sA, smoothstep(0.0, 0.2, np1.z));
		  
		  


float wx = currentWeather;
float4 SunCurrent;

if (wx.x==0,1) SunCurrent = f3;

if (wx.x==4) SunCurrent = 0.0;
if (wx.x==7) SunCurrent = 0.0;
if (wx.x==8) SunCurrent = 0.0;
if (wx.x==9) SunCurrent = 0.0;
if (wx.x==12) SunCurrent = 0.0;
if (wx.x==15) SunCurrent = 0.0;
if (wx.x==16) SunCurrent = 0.0;	  

   return SunCurrent;
}

//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------

Pixel PS_Sky(PSInput PS, float2 vPos : VPOS0)
{
    Pixel output;
	
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
	
   float Timex = 0.005 * gTime;
   float Timex1 = 0.01 * gTime;	
	
   float3 TexCoord1 = normalize(PS.TexCoord1);
   float3 TexCoord2 = normalize(PS.TexCoord2);
			   
float3 sLightDir = normalize(float3(-.00732,-.39,.503));
		     
   float3 wpos = PS.WorldPos.xyz;  
   float2 res = PS.TexCoord0.xy;
   float3 p0 = (gViewInverseTranspose[3].xyz/gViewInverseTranspose[3].w);	
	
   float3 w1 = float3(1.0, 1.0, 10.0);
   float4 ns = float4(normalize(wpos.xyz), 1.0);    
   
   float3 ns1 = normalize(wpos.xyz);
          ns1.z = abs(ns1.z)*1.40;	

    float3 np2 = normalize(-p0+ns1);

		  
   float4 Sun = CalculateSun(wpos);	
   float Al = Sun;	 
   
   float4 cd = float4(1.0, 1.0, 1.0, 0.0);
	      //cd+= Sun*1.0;
	      cd.xyz = Sun.xyz*1.0;
		  
    float pos = frac(vPos.xy/2.0) + 0.25;
    float3 j0 = float3(0.25,-0.25,0.25) * (1.0 / (exp2(8.0) - 1.0));
     	   j0 = lerp(2.0 * j0, -2.0 * j0, pos);					  

          cd.rgb+= j0;		  
		  
	      cd.a = Sun.a;		
	      cd.a+= j0;			  
    output.World = cd;	
    output.Depth = 0.99999f;
    return output;
}
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------

Pixel PS_Stars(PSInput PS, float2 vPos : VPOS0)
{
    Pixel output;
	
	
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
	
   float Timex = 0.005 * gTime;
   float Timex1 = 0.01 * gTime;	
	
   float3 TexCoord1 = normalize(PS.TexCoord1);
   float3 TexCoord2 = normalize(PS.TexCoord2);
			   
float3 sLightDir = normalize(float3(-.00732,-.39,.503));
		     
   float3 wpos = PS.WorldPos.xyz;  
   float2 res = PS.TexCoord0.xy;
   float3 p0 = (gViewInverseTranspose[3].xyz/gViewInverseTranspose[3].w);	

	
   float3 sc0 = SunLight(wpos);	
	
   float3 w1 = float3(1.0, 1.0, 10.0);
   float4 ns = float4(normalize(wpos.xyz), 1.0);    
   
   float3 ns1 = normalize(wpos.xyz);
          ns1.z = abs(ns1.z)*1.40;	

    float3 np2 = normalize(-p0+ns1);

   float sm1 = smoothstep(0.0, 4.0, t0),	
         sm2 = smoothstep(4.0, 5.0, t0),	 
         sm3 = smoothstep(5.0, 6.0, t0),			 
         sm4 = smoothstep(6.0, 23.0, t0),
         sm5 = smoothstep(23.0, 24.0, t0);
   float3 ti = lerp(1.0, 1.0, sm1);
          ti = lerp(ti, 0.3, sm2);   
          ti = lerp(ti, 0.0, sm3); 		  
          ti = lerp(ti, 0.0, sm4);
          ti = lerp(ti, 1.0, sm5);

   float4 s0 = Stars(np2 * 0.5 + 0.5)*3.2*1.40;
   		  s0*= smoothstep(0.0, 0.3, ns.z);
		  s0.a = min(1.0, ti*s0.a);
		  
	
   float4 cd = float4(1.0, 1.0, 1.0, 0.0);
	      cd = s0*1.3;
       // cd.a  = lerp(0.0, cd.a, smoothstep(0.0, 0.10, pow(ns.z, 1.65)));	

    float pos = frac(vPos.xy/2.0) + 0.25;
    float3 j0 = float3(0.25,-0.25,0.25) * (1.0 / (exp2(8.0) - 1.0));
     	   j0 = lerp(2.0 * j0, -2.0 * j0, pos);					  

          cd.rgb+= j0;
		
    output.World = cd;	
    output.Depth = 0.99999f;
    return output;
}

//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------

Pixel PS_Moon(PSInput PS, float2 vPos : VPOS0)
{
    Pixel output;
		
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
	
   float Timex = 0.005 * gTime;
   float Timex1 = 0.01 * gTime;	
	
   float3 TexCoord1 = normalize(PS.TexCoord1);
   float3 TexCoord2 = normalize(PS.TexCoord2);
			   
   float3 sLightDir = normalize(float3(-.00732,-.39,.503));
		     
   float3 wpos = PS.WorldPos.xyz;  
   float2 res = PS.TexCoord0.xy;
   float3 p0 = (gViewInverseTranspose[3].xyz/gViewInverseTranspose[3].w);	

	
   float3 sc0 = SunLight(wpos);	
	
   float3 w1 = float3(1.0, 1.0, 10.0);
   float4 ns = float4(normalize(wpos.xyz), 1.0);    
   
   float3 ns0 = normalize(wpos.xzy+float3(5.0, 5.0, 0.0));
   
   float v1 = 2.89;
   float3x3 vec0 = float3x3(1, 0, 0, 0, cos(v1), sin(v1), 0, -sin(v1), cos(v1));   
		   ns0 = mul(ns0, vec0);		   
	float3 np1 = normalize(ns0);

   float sm1 = smoothstep(0.0, 4.0, t0),	
         sm2 = smoothstep(4.0, 5.0, t0),	 
         sm3 = smoothstep(5.0, 6.0, t0),			 
         sm4 = smoothstep(6.0, 23.0, t0),
         sm5 = smoothstep(23.0, 24.0, t0);
   float3 ti = lerp(1.0, 1.0, sm1);
          ti = lerp(ti, 0.3, sm2);   
          ti = lerp(ti, 0.0, sm3); 		  
          ti = lerp(ti, 0.0, sm4);
          ti = lerp(ti, 1.0, sm5);

   float4 m0 = Moon(np1*53.0)*0.78;
   		  m0*= smoothstep(0.0, 0.3, -ns.y);
		  m0.a = saturate(min(1.0, ti*m0.a));
		  
	
   float4 cd = float4(1.0, 1.0, 1.0, 0.0);
	      cd.xyz = m0.xyz*0.7;
		  
    float pos = frac(vPos.xy/2.0) + 0.25;
    float3 j0 = float3(0.25,-0.25,0.25) * (1.0 / (exp2(8.0) - 1.0));
     	   j0 = lerp(2.0 * j0, -2.0 * j0, pos);					  

          cd.rgb+= j0;		  
		  
	      cd.a = m0.a;		  
       // cd.a  = lerp(0.0, cd.a, smoothstep(0.0, 0.10, pow(ns.z, 1.65)));	
		
    output.World = cd;	
    output.Depth = 0.99999f;
    return output;
}


//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------

Pixel PS_Clouds(PSInput PS, float2 vPos : VPOS0)
{
    Pixel output;
	
	
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
	
   float Timex = 0.005 * gTime;
   float Timex1 = 0.01 * gTime;	
	
   float3 TexCoord1 = normalize(PS.TexCoord1);
   float3 TexCoord2 = normalize(PS.TexCoord2);
			   
float3 sLightDir = normalize(float3(-.00732,-.39,.503));
		     
   float3 wpos = PS.WorldPos.xyz;  
   float2 res = PS.TexCoord0.xy;
   float3 p0 = (gViewInverseTranspose[3].xyz/gViewInverseTranspose[3].w);	

	
   float3 sc0 = SunLight(wpos);	
	
   float3 w1 = float3(1.0, 1.0, 10.0);
   float4 ns = float4(normalize(wpos.xyz), 1.0);    
   float ip = IntersectPlane(w1, ns.xyz);
   
   float3 ns1 = normalize(wpos.xyz);
          ns1.z = abs(ns1.z)*1.40;	

    float3 np2 = normalize(-p0+ns1);

   float4 s0 = Stars(np2 * 0.5 + 0.5)*3.2*1.40;
   		  //s0*= smoothstep(0.0, 0.3, ns.z);
		  s0.a = min(1.0, s0.a);
		  
	
   float4 cd = float4(1.0, 1.0, 1.0, 0.0);

   float4 c0 = GenerateClouds(wpos*ip*0.006, sc0);	

float3 SunCurrent;
float3 SunNext;
float3 wx = WeatherAndTime;

if (wx.x==0) SunCurrent = float3(1.0, 0.0, 0.0);
if (wx.y==0) SunNext = float3(1.0, 0.0, 0.0);

if (wx.x==1) SunCurrent = float3(1.0, 0.0, 0.0);
if (wx.y==1) SunNext = float3(1.0, 0.0, 0.0);

if (wx.x==2) SunCurrent = float3(0.0, 1.0, 0.0);
if (wx.y==2) SunNext = float3(0.0, 1.0, 0.0);

if (wx.x==3) SunCurrent = float3(0.0, 1.0, 0.0);
if (wx.y==3) SunNext = float3(0.0, 1.0, 0.0);

if (wx.x==5) SunCurrent = float3(0.0, 0.0, 1.0);
if (wx.y==5) SunNext = float3(0.0, 0.0, 1.0);

if (wx.x==6) SunCurrent = float3(0.0, 0.0, 1.0);
if (wx.y==6) SunNext = float3(0.0, 0.0, 1.0);

if (wx.x==4) SunCurrent = 1.0;
if (wx.x==7) SunCurrent = 1.0;
if (wx.x==8) SunCurrent = 1.0;
if (wx.x==9) SunCurrent = 1.0;
if (wx.x==12) SunCurrent = 1.0;
if (wx.x==15) SunCurrent = 1.0;
if (wx.x==16) SunCurrent = 1.0;

if (wx.y==4) SunNext = 1.0;
if (wx.y==7) SunNext = 1.0;
if (wx.y==8) SunNext = 1.0;
if (wx.y==9) SunNext = 1.0;
if (wx.y==12) SunNext = 1.0;
if (wx.y==15) SunNext = 1.0;
if (wx.y==16) SunNext = 1.0;	  


    float xZx = currentWeather;
    //      xZx = 150.0;
float3 SunCurrentX = float3(1.0, 1.0, 1.0);	
if (xZx.x==0) SunCurrentX = float3(1.0, 0.0, 0.0);
if (xZx.x==1) SunCurrentX = float3(0.0, 0.0, 1.0);	
	
float3 wmix = lerp(SunCurrent, SunNext, wx.z);	   
  
		  	 //c0.xyz*=wmix;

				 
			 
			
   if (ip <= 1.0) cd = c0;
                  //cd.xyz*=SunCurrentX; 
				  
    float pos = frac(vPos.xy/2.0) + 0.25;
    float3 j0 = float3(0.25,-0.25,0.25) * (1.0 / (exp2(8.0) - 1.0));
     	   j0 = lerp(2.0 * j0, -2.0 * j0, pos);					  

          cd.rgb+= j0;				  
          cd.a  = lerp(0.0, cd.a, smoothstep(0.0, 0.10, pow(ns.z, 1.65)));	
          //cd.a  = 0.0;
		  
	  		  
    output.World = cd;	
    output.Depth = 0.99999f;
    return output;
}

//------------------------------------------------------------------------------------------
//-- Techniques
//------------------------------------------------------------------------------------------
technique DynamicSky2tropos
{
    pass P0
    {
	    AlphaRef = 1;
        VertexShader = compile vs_3_0 VertexShaderSB();
        PixelShader = compile ps_3_0 PS_Sky();
    }
    pass P1
    {
	    AlphaRef = 1;
        VertexShader = compile vs_3_0 VertexShaderSB();
        PixelShader = compile ps_3_0 PS_Stars();
    }

    pass P2
    {
	    AlphaRef = 1;
        VertexShader = compile vs_3_0 VertexShaderSB();
        PixelShader = compile ps_3_0 PS_Moon();
    }	
	
    pass P3
    {
	    AlphaRef = 1;
        VertexShader = compile vs_3_0 VertexShaderSB();
        PixelShader = compile ps_3_0 PS_Clouds();
    }	
}
