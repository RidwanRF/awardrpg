/* VERSION 1.0 */
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
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

//
// Matrices
//
float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;
float4x4 gProjectionInverse : PROJECTIONINVERSE;
float4x4 gWorldView : WORLDVIEW;
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float4x4 gWorldViewProjectionInverse : WORLDVIEWPROJECTIONINVERSE;
float4x4 gViewProjection : VIEWPROJECTION;
float4x4 gViewProjectionInverse : VIEWPROJECTIONINVERSE;
float4x4 gViewInverse : VIEWINVERSE;
float4x4 gWorldInverseTranspose : WORLDINVERSETRANSPOSE;
float4x4 gViewInverseTranspose : VIEWINVERSETRANSPOSE;
float4x4 gTestMatrix : TESTMATRIX;

//
// Camera
//
float3 gCameraPosition : CAMERAPOSITION;
float3 gCameraDirection : CAMERADIRECTION;

//
// Seconds counter
//
float gTime : TIME;

//
// Strongest light influence
//
float4 gLightAmbient : LIGHTAMBIENT;
float4 gLightDiffuse : LIGHTDIFFUSE;
float4 gLightSpecular : LIGHTSPECULAR;
float3 gLightDirection : LIGHTDIRECTION;

float3 gLightDirection2 = float3(0.577, 0.577, -0.577); //: LIGHTDIRECTION;

//####################################################################################################################
//####################################################################################################################
//
// Section #2 : Renders states
//
//####################################################################################################################
//####################################################################################################################

//---------------------------------------------------------------------
// The parameters below mirror the contents of the D3D registers.
// They are only relevant when using engineApplyShaderToWorldTexture.
//---------------------------------------------------------------------

//------------------------------------------------------------------------------------------
// renderState (partial) - String value should be one of D3DRENDERSTATETYPE without the D3DRS_  http://msdn.microsoft.com/en-us/library/bb172599%28v=vs.85%29.aspx
//------------------------------------------------------------------------------------------

int gLighting                      < string renderState="LIGHTING"; >;                        //  = 137,

float4 gGlobalAmbient              < string renderState="AMBIENT"; >;                    //  = 139,

int gDiffuseMaterialSource         < string renderState="DIFFUSEMATERIALSOURCE"; >;           //  = 145,
int gSpecularMaterialSource        < string renderState="SPECULARMATERIALSOURCE"; >;          //  = 146,
int gAmbientMaterialSource         < string renderState="AMBIENTMATERIALSOURCE"; >;           //  = 147,
int gEmissiveMaterialSource        < string renderState="EMISSIVEMATERIALSOURCE"; >;          //  = 148,

int gStage1ColorOp2 < string stageState="1,COLOROP"; >;

int gGameTimeHours : GAME_TIME_HOURS;
int gGameTimeMinutes : GAME_TIME_MINUTES;
int gWeather : WEATHER;
//------------------------------------------------------------------------------------------
// materialState - String value should be one of the members from D3DMATERIAL9  http://msdn.microsoft.com/en-us/library/bb172571%28v=VS.85%29.aspx
//------------------------------------------------------------------------------------------

float4 gMaterialAmbient     < string materialState="Ambient"; >;
float4 gMaterialDiffuse     < string materialState="Diffuse"; >;
float4 gMaterialSpecular    < string materialState="Specular"; >;
float4 gMaterialEmissive    < string materialState="Emissive"; >;
float gMaterialSpecPower    < string materialState="Power"; >;


//------------------------------------------------------------------------------------------
// textureState (partial) - String value should be a texture number followed by 'Texture'
//------------------------------------------------------------------------------------------

texture gTexture0           < string textureState="0,Texture"; >;
texture gTexture1           < string textureState="1,Texture"; >;
texture gTexture2           < string textureState="2,Texture"; >;
texture gTexture3           < string textureState="3,Texture"; >;


//------------------------------------------------------------------------------------------
// vertexDeclState  (partial)
//------------------------------------------------------------------------------------------
int gDeclNormal             < string vertexDeclState="Normal"; >;       // Set to 1 if vertex stream includes normals


//------------------------------------------------------------------------------------------
// lightEnableState - String value should be a light number followed by 'Enable'
//------------------------------------------------------------------------------------------

int gLight0Enable           < string lightEnableState="0,Enable"; >;
int gLight1Enable           < string lightEnableState="1,Enable"; >;
int gLight2Enable           < string lightEnableState="2,Enable"; >;
int gLight3Enable           < string lightEnableState="3,Enable"; >;
int gLight4Enable           < string lightEnableState="4,Enable"; >;

//------------------------------------------------------------------------------------------
// lightState - String value should be a light number followed by one of the members from D3DLIGHT9  http://msdn.microsoft.com/en-us/library/bb172566%28VS.85%29.aspx
//------------------------------------------------------------------------------------------

int gLight0Type                 < string lightState="0,Type"; >;
float4 gLight0Diffuse           < string lightState="0,Diffuse"; >;
float4 gLight0Specular          < string lightState="0,Specular"; >;
float4 gLight0Ambient           < string lightState="0,Ambient"; >;
float3 gLight0Position          < string lightState="0,Position"; >;
float3 gLight0Direction         < string lightState="0,Direction"; >;

int gLight1Type                 < string lightState="1,Type"; >;
float4 gLight1Diffuse           < string lightState="1,Diffuse"; >;
float4 gLight1Specular          < string lightState="1,Specular"; >;
float4 gLight1Ambient           < string lightState="1,Ambient"; >;
float3 gLight1Position          < string lightState="1,Position"; >;
float3 gLight1Direction         < string lightState="1,Direction"; >;

int gLight2Type                 < string lightState="2,Type"; >;
float4 gLight2Diffuse           < string lightState="2,Diffuse"; >;
float4 gLight2Specular          < string lightState="2,Specular"; >;
float4 gLight2Ambient           < string lightState="2,Ambient"; >;
float3 gLight2Position          < string lightState="2,Position"; >;
float3 gLight2Direction         < string lightState="2,Direction"; >;

int gLight3Type                 < string lightState="3,Type"; >;
float4 gLight3Diffuse           < string lightState="3,Diffuse"; >;
float4 gLight3Specular          < string lightState="3,Specular"; >;
float4 gLight3Ambient           < string lightState="3,Ambient"; >;
float3 gLight3Position          < string lightState="3,Position"; >;
float3 gLight3Direction         < string lightState="3,Direction"; >;

int gLight4Type                 < string lightState="4,Type"; >;
float4 gLight4Diffuse           < string lightState="4,Diffuse"; >;
float4 gLight4Specular          < string lightState="4,Specular"; >;
float4 gLight4Ambient           < string lightState="4,Ambient"; >;
float3 gLight4Position          < string lightState="4,Position"; >;
float3 gLight4Direction         < string lightState="4,Direction"; >;

//####################################################################################################################
//####################################################################################################################
//
// Section #3 : Helper functions
//
//####################################################################################################################
//####################################################################################################################

//------------------------------------------------------------------------------------------
// - Find a the relative position between 2 values
//------------------------------------------------------------------------------------------
float Unlerp( float from, float to, float pos )
{
    if ( from == to )
        return 1.0;
    else
        return ( pos - from ) / ( to - from );
}


//------------------------------------------------------------------------------------------
// - Transform vertex position for the camera
//------------------------------------------------------------------------------------------
float4 CalcScreenPosition( float3 InPosition )
{
    float4 posWorld = mul(float4(InPosition,1), gWorld);
    float4 posWorldView = mul(posWorld, gView);
    return mul(posWorldView, gProjection);
}

//------------------------------------------------------------------------------------------
// - Transform position by current world matix
//------------------------------------------------------------------------------------------
float3 CalcWorldPosition( float3 InPosition )
{
    return mul(float4(InPosition,1), gWorld).xyz;
}

float4 AlphaMaterial()
{
    return (gMaterialDiffuse.a <= 0.99) || (gStage1ColorOp2 != 1);
}



//------------------------------------------------------------------------------------------
// - Rotate normal by current world matix
//------------------------------------------------------------------------------------------
float3 CalcWorldNormal( float3 InNormal )
{
    return mul(InNormal, (float3x3)gWorld);
}

//------------------------------------------------------------------------------------------
// - Calculate GTA specular lighting for vehicles
//------------------------------------------------------------------------------------------
float4 CalculateVehicleSpecular(float3 SurfNormal )
{
    // Using Blinn half angle modification for performance over correctness
    SurfNormal = normalize(SurfNormal);
    float3 halfAngle = normalize(-gCameraDirection - gLightDirection);
    float r = saturate(dot(halfAngle, SurfNormal));
    float spec = pow(r, gMaterialSpecPower);
	return gMaterialSpecular * spec;
}

//------------------------------------------------------------------------------------------
// - Calculate GTA lighting for buildings
//------------------------------------------------------------------------------------------
float4 CalcGTABuildingDiffuse( float4 InDiffuse )
{
    float4 OutDiffuse;

    if ( !gLighting )
    {
        // If lighting render state is off, pass through the vertex color
        OutDiffuse = InDiffuse;
    }
    else
    {
        // If lighting render state is on, calculate diffuse color by doing what D3D usually does
        float4 ambient  = gAmbientMaterialSource  == 0 ? gMaterialAmbient  : InDiffuse;
        float4 diffuse  = gDiffuseMaterialSource  == 0 ? gMaterialDiffuse  : InDiffuse;
        float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse;
        OutDiffuse = gGlobalAmbient * saturate( ambient + emissive );
        OutDiffuse.a *= diffuse.a;
    }
    return OutDiffuse;
}

float4 CalcGTABuildingDiffuse2( float4 InDiffuse )
{
    float4 OutDiffuse;

    if ( !gLighting )
    {
        // If lighting render state is off, pass through the vertex color
        OutDiffuse = InDiffuse;
    }
    else
    {
        // If lighting render state is on, calculate diffuse color by doing what D3D usually does
        float4 ambient  = gAmbientMaterialSource  == 0 ? gMaterialAmbient  : InDiffuse;
        float4 diffuse  = gDiffuseMaterialSource  == 0 ? gMaterialDiffuse  : InDiffuse;
        float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse;
        OutDiffuse = gGlobalAmbient * saturate( ambient + emissive );
        OutDiffuse.a *= ambient.a;
    }
    return OutDiffuse;
}
//------------------------------------------------------------------------------------------
// - Calculate GTA lighting for vehicles
//------------------------------------------------------------------------------------------
float4 CalcGTAVehicleDiffuse( float3 WorldNormal, float4 InDiffuse )
{
    // Calculate diffuse color by doing what D3D usually does
    float4 ambient  = gAmbientMaterialSource  == 0 ? gMaterialAmbient  : InDiffuse;
    float4 diffuse  = gDiffuseMaterialSource  == 0 ? gMaterialDiffuse  : InDiffuse;
    float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse;

    float4 TotalAmbient = ambient * ( gGlobalAmbient + gLightAmbient );

    // Add the strongest light
    float DirectionFactor = max(0,dot(WorldNormal, -gLightDirection ));
    float4 TotalDiffuse = ( diffuse * gLightDiffuse * DirectionFactor );

    float4 OutDiffuse = saturate(TotalDiffuse + TotalAmbient + emissive);
    OutDiffuse.a *= diffuse.a;

    return OutDiffuse;
}

//------------------------------------------------------------------------------------------
// - Calculate GTA lighting including pointlights for vehicles (all 4 lights)
//------------------------------------------------------------------------------------------
float4 CalcGTACompleteDiffuse( float3 WorldNormal, float4 InDiffuse )
{
    // Calculate diffuse color by doing what D3D usually does
    float4 ambient  = gAmbientMaterialSource  == 0 ? gMaterialAmbient  : InDiffuse;
    float4 diffuse  = gDiffuseMaterialSource  == 0 ? gMaterialDiffuse  : InDiffuse;
    float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse;

    float4 TotalAmbient = ambient * ( gGlobalAmbient + gLightAmbient );

    // Add all the 4 pointlights
    float DirectionFactor=0;
    float4 TotalDiffuse=0;
	
    if (gLight1Enable) {
    DirectionFactor = max(0,dot(WorldNormal, -gLight1Direction ));
    TotalDiffuse += ( gLight1Diffuse * DirectionFactor );
                     }
    if (gLight2Enable) {
    DirectionFactor = max(0,dot(WorldNormal, -gLight2Direction ));
    TotalDiffuse += ( gLight2Diffuse * DirectionFactor );
                     }
    if (gLight3Enable) {
    DirectionFactor = max(0,dot(WorldNormal, -gLight3Direction ));
    TotalDiffuse += ( gLight3Diffuse * DirectionFactor );
                     }
    if (gLight4Enable) {
    DirectionFactor = max(0,dot(WorldNormal, -gLight4Direction ));
    TotalDiffuse += ( gLight4Diffuse * DirectionFactor );
                     }	

    TotalDiffuse *= diffuse;

    float4 OutDiffuse = saturate(TotalDiffuse + TotalAmbient + emissive);
    OutDiffuse.a *= diffuse.a;

    return OutDiffuse;
}

float3 getLightDirection()
{
	return float3(-gLightDirection2.x, gLightDirection2.y, gLightDirection2.z);
	//return normalize(float3(2500,2500,-3000));
}

float4 shadeColor(float3 textureNormal, float3 lightDirection)
{
	float4 diffuse  = gDiffuseMaterialSource  == 0 ? gMaterialDiffuse  : 1;
    float4 ambient  = gAmbientMaterialSource  == 0 ? gMaterialAmbient  : 1;
    float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : 1;
	
    float4 TotalAmbient = ambient * ( gGlobalAmbient + gLightAmbient );
	float DirectionFactor = max( 0.2, dot(textureNormal, -lightDirection) );
	
	//float4 shadedColor = saturate( diffuse + TotalAmbient ) * DirectionFactor + emissive;
	//       shadedColor.a = pow ( saturate(diffuse.a), 1.25);
	
	float4 shadedColor = saturate( diffuse + TotalAmbient );
	       shadedColor.a = pow ( saturate(diffuse.a), 1.25);	
		   
	return saturate(shadedColor);
	
	//float4 shadedColor = max( 0.2, dot(textureNormal, -lightDirection) );
	//shadedColor.a = 1;
	//return saturate(shadedColor);
}


//------------------------------------------------------------------------------------------
// - Calculate GTA lighting for vehicles (all 4 lights)
//------------------------------------------------------------------------------------------
float4 CalcGTADynamicDiffuse( float3 WorldNormal )
{
    // Add all the 4 pointlights
    float DirectionFactor=0;
    float4 TotalDiffuse=0;

    if (gLight1Enable) {
    DirectionFactor = max(0,dot(WorldNormal, -gLight1Direction ));
    TotalDiffuse += ( gLight1Diffuse * DirectionFactor );
                     }
    if (gLight2Enable) {
    DirectionFactor = max(0,dot(WorldNormal, -gLight2Direction ));
    TotalDiffuse += ( gLight2Diffuse * DirectionFactor );
                     }
					 
		 
    if (gLight3Enable) {
    DirectionFactor = max(0,dot(WorldNormal, -gLight3Direction ));
    TotalDiffuse += ( gLight3Diffuse * DirectionFactor );
                     }
/*							 
    if (gLight4Enable) {
    DirectionFactor = max(0,dot(WorldNormal, -gLight4Direction ));
    TotalDiffuse += ( gLight4Diffuse * DirectionFactor );
                     }	
*/
    float4 OutDiffuse = saturate(TotalDiffuse);

    return OutDiffuse;
}

//------------------------------------------------------------------------------------------
// - Get camera direction to a world point
//------------------------------------------------------------------------------------------
float3 CalculateCameraDirection( float3 CamPos, float3 InWorldPos )
{
    return normalize( InWorldPos - CamPos );
}

//------------------------------------------------------------------------------------------
// CalcCameraDistance
// - Get camera distance from a world point
//------------------------------------------------------------------------------------------
float CalcCameraDistance( float3 CamPos, float3 InWorldPos )
{
    return distance( InWorldPos, CamPos );
}

//------------------------------------------------------------------------------------------
// CalculateSpecular
// - Get specular intensity
//------------------------------------------------------------------------------------------
float CalculateSpecular( float3 CamDir, float3 LightDir, float3 SurfNormal, float SpecPower )
{
    // Using Blinn half angle modification for performance over correctness
    LightDir = normalize(LightDir);
    SurfNormal = normalize(SurfNormal);
    float3 halfAngle = normalize(-CamDir - LightDir);
    float r = dot(halfAngle, SurfNormal);
    return pow(saturate(r), SpecPower);
}

//------------------------------------------------------------------------------------------
// CalculateVehicleSpecular
// - Get specular intensity
//------------------------------------------------------------------------------------------
float CalculateVehicleSpecular( float3 CamDir, float3 LightDir, float3 SurfNormal, float SpecPower )
{
    // Using Blinn half angle modification for performance over correctness
    LightDir = normalize(LightDir);
    SurfNormal = normalize(SurfNormal);
    float3 halfAngle = normalize(-CamDir - LightDir);
    float r = dot(halfAngle, SurfNormal);
    float spec = pow(saturate(r), SpecPower) * 0.6;
    spec += pow(saturate(r), 10 * SpecPower) * 0.4;
    return spec;
}


float4x4 inverse(float4x4 input)
{
     #define minor(a,b,c) determinant(float3x3(input.a, input.b, input.c))
     
     float4x4 cofactors = float4x4(
          minor(_22_23_24, _32_33_34, _42_43_44), 
         -minor(_21_23_24, _31_33_34, _41_43_44),
          minor(_21_22_24, _31_32_34, _41_42_44),
         -minor(_21_22_23, _31_32_33, _41_42_43),
         
         -minor(_12_13_14, _32_33_34, _42_43_44),
          minor(_11_13_14, _31_33_34, _41_43_44),
         -minor(_11_12_14, _31_32_34, _41_42_44),
          minor(_11_12_13, _31_32_33, _41_42_43),
         
          minor(_12_13_14, _22_23_24, _42_43_44),
         -minor(_11_13_14, _21_23_24, _41_43_44),
          minor(_11_12_14, _21_22_24, _41_42_44),
         -minor(_11_12_13, _21_22_23, _41_42_43),
         
         -minor(_12_13_14, _22_23_24, _32_33_34),
          minor(_11_13_14, _21_23_24, _31_33_34),
         -minor(_11_12_14, _21_22_24, _31_32_34),
          minor(_11_12_13, _21_22_23, _31_32_33)
     );
     #undef minor
     return transpose(cofactors) / determinant(input);
}

float4 Inverse2(float4 pos)
{
    float4x4 gWVPI =  inverse(gWorldViewProjection);
	float4 objspacepos	= mul(pos, gWVPI);
	       objspacepos.xyz/=objspacepos.w;	 
     return objspacepos;
}


//####################################################################################################################
//####################################################################################################################
//
// Section #4 : Normal generation
//
//####################################################################################################################
//####################################################################################################################


int CUSTOMFLAGS
<
#ifdef GENERATE_NORMALS
    string createNormals = "yes";           // Some models do not have normals by default. Setting this to 'yes' will add them to the VertexShaderInput as NORMAL0
#endif
    string skipUnusedParameters = "yes";    // This will make the shader a bit faster
>;



void FixUpNormal( in out float3 OutNormal )
{
    // Incase we have no normal inputted
    if ( OutNormal.x == 0 && OutNormal.y == 0 && OutNormal.z == 0 )
        OutNormal = float3(0,0,1);   // Default to up
}


float3 calculateTextureNormals(sampler MainSampler, float2 TexCoords, float4 color, float textureSize)
{
   float off = 1.0 / textureSize;

   // Take all neighbor samples
   float4 s00 = tex2D(MainSampler, TexCoords + float2(-off, -off));
   float4 s01 = tex2D(MainSampler, TexCoords + float2( 0,   -off));
   float4 s02 = tex2D(MainSampler, TexCoords + float2( off, -off));

   float4 s10 = tex2D(MainSampler, TexCoords + float2(-off,  0));
   float4 s12 = tex2D(MainSampler, TexCoords + float2( off,  0));

   float4 s20 = tex2D(MainSampler, TexCoords + float2(-off,  off));
   float4 s21 = tex2D(MainSampler, TexCoords + float2( 0,    off));
   float4 s22 = tex2D(MainSampler, TexCoords + float2( off,  off));

   // Slope in X direction
   float4 sobelX = s00 + 2 * s10 + s20 - s02 - 2 * s12 - s22;
   // Slope in Y direction
   float4 sobelY = s00 + 2 * s01 + s02 - s20 - 2 * s21 - s22;

   // Weight the slope in all channels, we use grayscale as height
   float sx = dot(sobelX, color);
   float sy = dot(sobelY, color);

   // Compose the normal
   float3 normal = normalize(float3(sx, sy, 1));

   // Pack [-1, 1] into [0, 1]
   return normal;
}

//####################################################################################################################
//####################################################################################################################
// SKY
//####################################################################################################################
//####################################################################################################################

float CalculateGameTime0(in float t)
{	  
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
   
   float3 t0 = lerp(0.0, 0.1, x1);
          t0 = lerp(t0, 0.2, x2);
          t0 = lerp(t0, 0.8, x3);
          t0 = lerp(t0, 0.9, x4);
          t0 = lerp(t0, 1.0, xE);
          t0 = lerp(t0, 1.0, x5);
          t0 = lerp(t0, 0.9, x6);	 
          t0 = lerp(t0, 0.5, x7);
		  t0 = lerp(t0, 0.4, xG);
		  t0 = lerp(t0, 0.3, xZ);
          t0 = lerp(t0, 0.2, x8);
          t0 = lerp(t0, 0.0, x9); 		  
   return t0;	  
}


float CalculateGameTime(in float t)
{	  
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
   
   float3 t0 = lerp(0.0, 0.0, x1);
          t0 = lerp(t0, 0.7, x2);
          t0 = lerp(t0, 1.0, x3);
          t0 = lerp(t0, 1.0, x4);
          t0 = lerp(t0, 1.0, xE);
          t0 = lerp(t0, 1.0, x5);
          t0 = lerp(t0, 1.0, x6);		 
          t0 = lerp(t0, 0.95, x7);
		  t0 = lerp(t0, 0.9, xG);
		  t0 = lerp(t0, 0.6, xZ); 
          t0 = lerp(t0, 0.3, x8);
          t0 = lerp(t0, 0.0, x9); 		  
   return t0;	  
}

float CalculateGameTime2(in float t)
{	  
   float x1 = smoothstep(0.0, 4.0, t);
   float x2 = smoothstep(4.0, 5.0, t);
   float x3 = smoothstep(5.0, 6.0, t);
   float x4 = smoothstep(6.0, 7.0, t);
   float xE = smoothstep(8.0, 16.0, t);
   float x5 = smoothstep(16.0, 17.0, t);
   float x6 = smoothstep(18.0, 19.0, t);
   float x7 = smoothstep(19.0, 20.0, t);
   float xG = smoothstep(20.0, 21.0, t);  
   float xZ = smoothstep(21.0, 22.0, t);
   float x8 = smoothstep(22.0, 23.0, t);
   float x9 = smoothstep(23.0, 24.0, t);
   
   float3 t0 = lerp(0.0, 0.0, x1);
          t0 = lerp(t0, 0.7, x2);
          t0 = lerp(t0, 0.9, x3);
          t0 = lerp(t0, 0.9, x4);
          t0 = lerp(t0, 0.7, xE);
          t0 = lerp(t0, 0.7, x5);
          t0 = lerp(t0, 0.8, x6);		 
          t0 = lerp(t0, 1.0, x7);
		  t0 = lerp(t0, 1.0, xG);
		  t0 = lerp(t0, 1.0, xZ);
          t0 = lerp(t0, 0.0, x8);  
          t0 = lerp(t0, 0.0, x9);	  
   return t0;	  
}


float3 SunDirectionR(float GameTime)
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
 return f;					
}

float3 CalculateSun2(float3 wpos)
{
    float hourMinutes = (1 / 59) * 15;
    float GameTime = 15 + hourMinutes;
    float3 SunDirection = SunDirectionR(GameTime);
    float t = GameTime;	
    float wx = gWeather;
    float3 worldpos = normalize(wpos.xyz);	

    float getSun = (0.01/12.0) - dot(-SunDirection.xyz, worldpos.xyz);
          getSun = pow(getSun, 11900.0);	 
          getSun = getSun/122.0;
   
    float3 color = float3(0.0392, 0.0235, 0.0118);
    float3 f3 = lerp(0.0, (getSun*color*0.8), smoothstep(0.0, 0.005, worldpos.z));
 
    float3 sun = f3;
	
    //if (wx.x==2) sun = 0.0;	
    //if (wx.x==3) sun = 0.0;	
    if (wx.x==4) sun = 0.0;
    if (wx.x==7) sun = 0.0;
    if (wx.x==8) sun = 0.0;
    if (wx.x==9) sun = 0.0;
    if (wx.x==12) sun = 0.0;
    if (wx.x==15) sun = 0.0;
    if (wx.x==16) sun = 0.0;
 
    return sun;
}

float3 CalculateSun(float3 wpos)
{
    float hourMinutes = (1 / 59) * 15;
    float GameTime = 15 + 15;		
    float3 SunDir = SunDirectionR(GameTime); 
    float3 MoonDir = normalize(float3(-0.0833, -0.946, 0.317));	
    float wx = gWeather;	
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
   
    float3 SC0 = float3(1.0, 0.51, 0.2);   
    float3 SC3 = float3(1.0, 0.627, 0.2);    
   
    float3 t0 = lerp(0.0, 0.0, x1);
           t0 = lerp(t0, SC0*SC0*2.0, x2);
           t0 = lerp(t0, SC0*SC0*2.7, x3);
           t0 = lerp(t0, float3(1.0, 0.51, 0.235)*2.0, x4);
           t0 = lerp(t0, float3(1.0, 0.863, 0.549), xE);
           t0 = lerp(t0, float3(1.0, 0.863, 0.549), x5);
           t0 = lerp(t0, SC0*SC0*2.0, x6);	 
           t0 = lerp(t0, SC0*SC0*2.2, x7);
           t0 = lerp(t0, SC0*2.0, xG);
           t0 = lerp(t0, SC0*1.0, xZ);
           t0 = lerp(t0, SC0*0.6, x8);
           t0 = lerp(t0, 0.0, x9);	

    float3 t3 = lerp(0.0, 0.0, x1);
           t3 = lerp(t3, SC3*SC3*2.0, x2);
           t3 = lerp(t3, SC3*SC3*2.7, x3);
           t3 = lerp(t3, float3(1.0, 0.784, 0.392)*2.0, x4);
           t3 = lerp(t3, float3(1.0, 1.0, 1.0)*2.0, xE);
           t3 = lerp(t3, float3(1.0, 1.0, 1.0)*2.0, x5);
           t3 = lerp(t3, SC3*SC3*2.0, x6);		 
           t3 = lerp(t3, SC3*SC3*2.2, x7);
           t3 = lerp(t3, SC3*2.0, xG);
           t3 = lerp(t3, SC3*1.0, xZ);
           t3 = lerp(t3, SC3*0.6, x8);
           t3 = lerp(t3, 0.0, x9); 	
   
   float3 wp0 = normalize(wpos.xyz);

   float factor1 = 0.04 - dot(-SunDir, wp0);
         factor1 = pow(factor1, 18.0);	
   float factor2 = 0.6 - dot(-SunDir, wp0);
         factor2 = pow(factor2, 1.35);
		 
   float factor3 = 0.04 - dot(-MoonDir, wp0);
         factor3 = pow(factor3, 18.0);	
   float factor4 = 0.6 - dot(-MoonDir, wp0);
         factor4 = pow(factor4, 1.35);		 
		 
   float3 f1 = (factor1*factor1)/12.0;    
   float3 f2 = (factor2*factor2)/12.0;
   
   float3 f1x = (factor3*factor3)/5.0;    
   float3 f2x = (factor4*factor4)/10.0;   
   float3 fnight = (f1x*float3(0.0863, 0.137, 0.176))+(f2x*float3(0.0, 0.0, 0.0));     
		  fnight*= smoothstep(0.0, 0.3, -wp0.y);
 
   float m1 = smoothstep(0.0, 4.0, t),	
         m2 = smoothstep(4.0, 5.0, t),	 
         m3 = smoothstep(5.0, 6.0, t),			 
         m4 = smoothstep(6.0, 23.0, t),
         m5 = smoothstep(23.0, 24.0, t);
		 
   float ti = lerp(1.0, 1.0, m1);
         ti = lerp(ti, 0.3, m2);   
         ti = lerp(ti, 0.0, m3); 		  
         ti = lerp(ti, 0.0, m4);
         ti = lerp(ti, 1.0, m5); 

    float3 f3 = (f1*t0*0.5)+(f2*t3*0.5)+(fnight*ti*1.2);
 
    float3 sun = f3;
    if (wx.x==4) sun = 0.0;
    if (wx.x==7) sun = 0.0;
    if (wx.x==8) sun = 0.0;
    if (wx.x==9) sun = 0.0;
    if (wx.x==12) sun = 0.0;
    if (wx.x==15) sun = 0.0;
    if (wx.x==16) sun = 0.0; 
	
    return sun;
}

//####################################################################################################################
//####################################################################################################################
// SKY

float3 CalculateSunRay(in float2 coord, float3 wpos)
{
  float hourMinutes = (1 / 59) * 15;
  float GameTime = 15 + hourMinutes;

	  
    float3 sv = SunDirectionR(GameTime);
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
   
   float3 t0 = lerp(0.0, 0.0, x1);
          t0 = lerp(t0, float3(1.0, 0.549, 0.0784)*3.0, x2);
          t0 = lerp(t0, float3(1.0, 0.549, 0.0784)*4.7, x3);
          t0 = lerp(t0, float3(1.0, 0.9, 0.7)*2.2, x4);
          t0 = lerp(t0, float3(1.0, 1.0, 1.0)*1.1, xE);
          t0 = lerp(t0, float3(1.0, 1.0, 1.0)*1.1, x5);
          t0 = lerp(t0, float3(1.0, 0.549, 0.0784)*2.5, x6);	 
          t0 = lerp(t0, float3(1.0, 0.549, 0.0784)*2.5, x7);
		  t0 = lerp(t0, float3(1.0, 0.549, 0.0784)*2.5, xG);
		  t0 = lerp(t0, float3(1.0, 0.549, 0.0784)*2.5, xZ);
          t0 = lerp(t0, float3(1.0, 0.549, 0.0784)*2.5, x8);
          t0 = lerp(t0, 0.0, x9);	

   float3 t3 = lerp(0.0, 0.0, x1);
          t3 = lerp(t3, float3(1.0, 0.447, 0.0)*3.0, x2);
          t3 = lerp(t3, float3(1.0, 0.447, 0.0)*4.7, x3);
          t3 = lerp(t3, float3(1.0, 0.800, 0.500)*4.0, x4);
          t3 = lerp(t3, float3(1.0, 1.0, 1.0)*2.0, xE);
          t3 = lerp(t3, float3(1.0, 1.0, 1.0)*2.0, x5);
          t3 = lerp(t3, float3(1.0, 0.447, 0.0)*2.5, x6);		 
          t3 = lerp(t3, float3(1.0, 0.447, 0.0)*2.5, x7);
		  t3 = lerp(t3, float3(1.0, 0.447, 0.0)*2.5, xG);
		  t3 = lerp(t3, float3(1.0, 0.447, 0.0)*2.5, xZ);
          t3 = lerp(t3, float3(1.0, 0.447, 0.0)*2.5, x8);
          t3 = lerp(t3, 0.0, x9); 	   

   float c1 = 18.0;
   float c2 = 1.35;

   float factor1 = 0.04 - dot(-sv, wpos);
         factor1 = pow(factor1, c1);	
   float factor2 = 0.6 - dot(-sv, wpos);
         factor2 = pow(factor2, c2);
		 
   float factor3 = 0.04 - dot(-sv2, wpos);
         factor3 = pow(factor3, c1);	
   float factor4 = 0.6 - dot(-sv2, wpos);
         factor4 = pow(factor4, c2);		 

   float3 f1 = (factor1*factor1)/5.0;    
   float3 f2 = (factor2*factor2)/10.0;
   
   float3 f1x = (factor3*factor3)/5.0;    
   float3 f2x = (factor4*factor4)/10.0;   
   float3 fnight = (f1x*float3(0.0863, 0.137, 0.176))+(f2x*float3(0.0, 0.0, 0.0));     
		  fnight*= smoothstep(0.0, 0.3, -wpos.y);   
   
   float y1 = smoothstep(0.0, 2.0, t),
         yZ = smoothstep(2.0, 3.0, t),   
         y2 = smoothstep(4.0, 23.0, t),
         y3 = smoothstep(23.0, 24.0, t);   
		 
   float3 t5 = lerp(1.0, 0.5, y1);
          t5 = lerp(t5, 0.0, yZ);  
          t5 = lerp(t5, 0.0, y2);
          t5 = lerp(t5, 1.0, y3);	 

   float factorA = saturate(1.5 - dot(-sv, wpos));
         factorA = pow(factorA, 40);

   float3 f3 = lerp(0.0, (f1*t0*0.45)+(f2*t3*0.10), saturate(factorA)) +(fnight*t5);//	  
   return f3;
}


float3 CalculateMoon(in float2 coord, float3 wpos)
{
   float hourMinutes = (1 / 59) * 15;
   float GameTime = 15 + 15;	  
   float3 sv = SunDirectionR(GameTime);
   float3 sv2 = normalize(float3(-0.0833, -0.946, 0.317));	
   float t = GameTime;	
   float c1 = 18.0;
   float c2 = 1.35;
		 
   float factor3 = 0.04 - dot(-sv2, wpos);
         factor3 = pow(factor3, c1);	
   float factor4 = 0.6 - dot(-sv2, wpos);
         factor4 = pow(factor4, c2);		 
   
   float3 f1x = (factor3*factor3)/5.0;    
   float3 f2x = (factor4*factor4)/10.0;   
   float3 fnight = (f1x*float3(0.0863, 0.137, 0.176))+(f2x*float3(0.0, 0.0, 0.0));     
		  fnight*= smoothstep(0.0, 0.3, -wpos.y);   
   
   float y1 = smoothstep(0.0, 2.0, t);
   float yZ = smoothstep(2.0, 3.0, t);   
   float y2 = smoothstep(4.0, 21.0, t);
   float y3 = smoothstep(21.0, 24.0, t);   
		 
   float3 t5 = lerp(1.0, 0.5, y1);
          t5 = lerp(t5, 0.0, yZ);  
          t5 = lerp(t5, 0.0, y2);
          t5 = lerp(t5, 1.0, y3);	 

   float3 f3 = (fnight*t5*1.3);   
   return f3;
}

#define zenithDensity(x) 0.7 / pow(max(x - 0.1, 0.35e-2), 0.75)

float3 getSkyAbsorption(float3 x, float y)
{	
	float3 absorption = x * -y;
	       absorption = lerp(exp2(absorption), float3(0.569, 0.392, 0.275),  0.0);
	return absorption;
}


float3 jodieReinhardTonemap(float3 c)
{
    float l = dot(c, float3(0.2126, 0.7152, 0.0722));
    float3 tc = c / (c + 1.0);

    return lerp(c / (l + 1.0), tc, tc);
}

float3 ColorTopNew()
{
   float wx = gWeather;	
   float3 cc = float3(1.0, 1.0, 1.0);   

   float3 Yacnaya = float3(0.590, 0.805, 1.0);
   float3 Yacnaya2 = float3(0.550, 0.750, 0.900);
   float3 Colne4no = float3(0.600, 0.800, 0.950)*1.2;
   float3 Colne4no2 = float3(0.650, 0.800, 0.950);   
   float3 maloobla4no = float3(0.650, 0.800, 0.950);
   float3 Oblachno = float3(0.640, 0.800, 0.950)*1.4;
   float3 Pasmurno = float3(0.800, 0.900, 0.940)*1.4;

             cc = Yacnaya;
			 
//if (wx.x==2) cc = Pasmurno;			 
//if (wx.x==3) cc = Pasmurno;			 
if (wx.x==4) cc = Pasmurno;
if (wx.x==7) cc = Pasmurno;
if (wx.x==8) cc = Pasmurno;
if (wx.x==9) cc = Pasmurno;
if (wx.x==12) cc = Pasmurno;
if (wx.x==15) cc = Pasmurno;
if (wx.x==16) cc = Pasmurno;

if (wx.x==0) cc = Colne4no;
if (wx.x==1) cc = Yacnaya;
if (wx.x==2) cc = Yacnaya2;
if (wx.x==3) cc = Oblachno;
if (wx.x==5) cc = Colne4no2;
if (wx.x==6) cc = Yacnaya;
if (wx.x==10) cc = Yacnaya2;
if (wx.x==11) cc = Colne4no2;
if (wx.x==13) cc = Colne4no;  
if (wx.x==14) cc = maloobla4no; 
if (wx.x==17) cc = Colne4no; 
if (wx.x==18) cc = maloobla4no; 

   float3 result = cc;
   return result;
}

float3 ColorHorizonNew()
{
   float wx = gWeather;	
   float3 cc = float3(1.0, 1.0, 1.0);   

   float3 Yacnaya = float3(0.882, 0.882, 0.804);
   float3 Yacnaya2 = float3(0.880, 0.840, 0.750)*0.9;
   float3 Colne4no = float3(0.735, 0.735, 0.720)*1.05;
   float3 Colne4no2 = float3(0.735, 0.735, 0.720)*1.05;   
   float3 maloobla4no = float3(0.882, 0.882, 0.804);
   float3 Oblachno = float3(0.735, 0.735, 0.720)*1.05;
   float3 Pasmurno = float3(0.640, 0.710, 0.720)*1.6;

             cc = Yacnaya;
			 
//if (wx.x==2) cc = Pasmurno;			 
//if (wx.x==3) cc = Pasmurno;			 
if (wx.x==4) cc = Pasmurno;
if (wx.x==7) cc = Pasmurno;
if (wx.x==8) cc = Pasmurno;
if (wx.x==9) cc = Pasmurno;
if (wx.x==12) cc = Pasmurno;
if (wx.x==15) cc = Pasmurno;
if (wx.x==16) cc = Pasmurno;

if (wx.x==0) cc = Colne4no;
if (wx.x==1) cc = Yacnaya;
if (wx.x==2) cc = Yacnaya2;
if (wx.x==3) cc = Oblachno;
if (wx.x==5) cc = Colne4no2;
if (wx.x==6) cc = Yacnaya;
if (wx.x==10) cc = Yacnaya2;
if (wx.x==11) cc = Colne4no2;
if (wx.x==13) cc = Colne4no;  
if (wx.x==14) cc = maloobla4no; 
if (wx.x==17) cc = Colne4no; 
if (wx.x==18) cc = maloobla4no; 

   float3 result = cc;
   return result;
}

float GetVolumetricFog(float3 wpos)
{		  
// Создание основы неба	  
   float3 vec1 = normalize(float3(0.0, 0.0, 1.0));	  
   float fog = saturate(0.95 - dot(vec1, wpos));
	     fog = pow(fog, 7.5);	      
  return fog;	
}

float3 GetAtmosphericScattering(float2 txcoord, float3 wpos)
{ 
		  
// Создание основы неба	  
   float3 vec1 = normalize(float3(0.0, 0.0, 1.0));	  
   float sky = saturate(0.95 - dot(vec1, wpos));
	     sky = pow(sky, 2.32);
		 
   float sky1 = saturate(0.15 - dot(vec1, wpos));
	     sky1 = pow(sky1, 0.5);
		 
   float sky2 = (1.05 - dot(vec1, wpos));
	     sky2 = pow(sky2, 40.0);		 

   float3 SkyColorTop = ColorTopNew();
   float3 SkyColorBot = ColorHorizonNew();   
   float3 absorption = getSkyAbsorption(SkyColorTop, sky2);

//=============================================================
//
//=============================================================
  float hourMinutes = (1 / 59) * 15;
  float GameTime = 15 + hourMinutes;
 
   float t0 = GameTime;
   float3 vec0 = SunDirectionR(GameTime);
   float3 s0 = normalize(float3(0.0, 0.0, -1.0));
   
   float s1 = smoothstep(0.0, 1.0, t0);	
   float s2 = smoothstep(1.0, 23.0, t0);
   float s3 = smoothstep(23.0, 24.0, t0);
   
   float3 vec2 = lerp(s0, vec0, s1);
          vec2 = lerp(vec2, vec0, s2); 
          vec2 = lerp(vec2, vec0, s3);  


   float3 sv = SunDirectionR(GameTime);	
		  
   float vec3 = max(sv.z + 0.1 - 0.0, 0.0);   
   float vec5 = max(sv.z + 0.40 - 0.0, 0.0);
   
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

   float vec6 = lerp(0.4, 0.4, x1);
         vec6 = lerp(vec6, 0.4, x2);
         vec6 = lerp(vec6, 0.4, x3);
         vec6 = lerp(vec6, 0.4, x4);
         vec6 = lerp(vec6, 0.4, xE);
         vec6 = lerp(vec6, 0.5, x5);
         vec6 = lerp(vec6, 0.8, x6);
         vec6 = lerp(vec6, 0.8, x7);
         vec6 = lerp(vec6, 0.9, xG);	
         vec6 = lerp(vec6, 1.0, xZ);			  
         vec6 = lerp(vec6, 1.0, x8);    
         vec6 = lerp(vec6, 1.0, x9);  

   float hor1 = lerp(0.1, 0.1, x1);
         hor1 = lerp(hor1, 0.07, x2);
         hor1 = lerp(hor1, 0.01, x3);
         hor1 = lerp(hor1, 0.0, x4);
         hor1 = lerp(hor1, 0.0, xE);
         hor1 = lerp(hor1, 0.0, x5);
         hor1 = lerp(hor1, 0.0, x6);
         hor1 = lerp(hor1, 0.02, x7);
         hor1 = lerp(hor1, 0.07, xG);	
         hor1 = lerp(hor1, 0.12, xZ);			  
         hor1 = lerp(hor1, 0.12, x8);
	 
   
   float3 sunAbsorption = getSkyAbsorption(SkyColorTop, zenithDensity(sv.z + vec6));
   float3 sAbs = sunAbsorption * 0.5 + 0.5 * length(sunAbsorption);  
    
   //float3 sun = CalculateSun(txcoord) * absorption; 
   float3 Ray = CalculateSunRay(txcoord, wpos)* sunAbsorption;   
   float3 Moon = CalculateMoon(txcoord, wpos);    
// Цвета и прочее	
    float3 SkyRain = lerp(SkyColorTop, SkyColorBot*1.05, sky);	 
    float3 SkyColor = lerp(SkyColorTop, lerp(SkyColorBot*1.05, 0.98, sky1), sky); 	
	       SkyColor*= lerp(sky, 1.0, 0.4); 
           SkyColor+= 0.01;		   
           SkyColor = pow(SkyColor, 3.5);		   
	       SkyColor = lerp(SkyColor*pow(absorption, 1.0), SkyColor, vec3); 
		   SkyColor+= float3(0.95, 0.82, 1.0)*saturate(sky2)*hor1;
		
		   SkyColor*= 12.5;			   
	       SkyColor*= sAbs;
		   
   float sm1 = smoothstep(0.0, 2.0, GameTime),	
         sm2a = smoothstep(2.0, 4.0, GameTime),   
         sm2 = smoothstep(4.0, 5.0, GameTime),	 
         sm3 = smoothstep(5.0, 6.0, GameTime),			 
         sm4 = smoothstep(6.0, 22.0, GameTime),
         sm5 = smoothstep(21.0, 23.0, GameTime),
         sm6 = smoothstep(21.0, 24.0, GameTime);
         //sm7 = smoothstep(21.0, 24.0, GameTime);		 
   float ti = lerp(1.0, 1.0, sm1);
         ti = lerp(ti, 0.0, sm2a);     
         ti = lerp(ti, 0.0, sm2);   
         ti = lerp(ti, 0.0, sm3); 		  
         ti = lerp(ti, 0.0, sm4);
         ti = lerp(ti, 1.0, sm5);
         ti = lerp(ti, 1.0, sm6);
         //ti = lerp(ti, 1.0, sm7);		 
/*		 
   float ti2 = lerp(0.0, 0.0, sm1);
         ti2 = lerp(ti2, 0.4, sm2a);     
         ti2 = lerp(ti2, 0.5, sm2);   
         ti2 = lerp(ti2, 0.6, sm3); 		  
         ti2 = lerp(ti2, 1.0, sm4);
         ti2 = lerp(ti2, 0.0, sm5);
         ti2 = lerp(ti2, 0.0, sm6);		 
         //ti2 = lerp(ti2, 0.0, sm7);
*/
   float ti2 = lerp(0.0, 0.0, x1);
         ti2 = lerp(ti2, 0.3, x2);
         ti2 = lerp(ti2, 0.6, x3);
         ti2 = lerp(ti2, 0.8, x4);
         ti2 = lerp(ti2, 1.0, xE);
         ti2 = lerp(ti2, 1.0, x5);
         ti2 = lerp(ti2, 1.0, x6);
         ti2 = lerp(ti2, 0.6, x7);
         ti2 = lerp(ti2, 0.5, xG);	
         ti2 = lerp(ti2, 0.3, xZ);			  
         ti2 = lerp(ti2, 0.0, x8);
		 
   float ti3 = lerp(0.0, 0.0, x1);  
         ti3 = lerp(ti3, 0.8, sm2a);   
         ti3 = lerp(ti3, 0.9, x2);   
         ti3 = lerp(ti3, 0.9, x3); 		  
         ti3 = lerp(ti3, 0.5, x4);
         ti3 = lerp(ti3, 0.5, x5);
         ti3 = lerp(ti3, 0.5, x6);		 
         ti3 = lerp(ti3, 0.9, x7);
         ti3 = lerp(ti3, 1.0, xG);	
         ti3 = lerp(ti3, 0.5, xZ);			  
         ti3 = lerp(ti3, 0.0, x8);		 
		 
	float3 fnight = lerp(0.0, float3(0.50, 0.70, 0.95)*0.30, pow(sky, 0.85));
           SkyColor = lerp(SkyColor, fnight, ti);		   
           SkyColor+= Moon+(Ray*12.5*sAbs);
		   		   
   float wx = gWeather;	
   float3 Pasmurno = lerp(SkyRain*float3(0.90, 0.94, 1.05)*0.19, SkyRain*float3(0.95, 0.98, 1.0)*2.2, saturate(ti2));
          Pasmurno+= Moon*float3(0.85, 0.80, 0.85);


	float VolFog = GetVolumetricFog(wpos.xyz);

         SkyColor.rgb = lerp(SkyColor.rgb, float3(0.765, 0.700, 0.680), ti3*VolFog*0.80);

//if (wx.x==2) SkyColor = Pasmurno;
//if (wx.x==3) SkyColor = Pasmurno;		  
if (wx.x==4) SkyColor = Pasmurno;
if (wx.x==7) SkyColor = Pasmurno;
if (wx.x==8) SkyColor = Pasmurno;
if (wx.x==9) SkyColor = Pasmurno;
if (wx.x==12) SkyColor = Pasmurno;
if (wx.x==15) SkyColor = Pasmurno;
if (wx.x==16) SkyColor = Pasmurno;	
	   	   
           SkyColor = jodieReinhardTonemap(SkyColor);	

		 
    return SkyColor;	
}



//####################################################################################################################
//####################################################################################################################
float3 GetAtmosphericScattering2(float2 txcoord, float3 wpos)
{ 
		  
// Создание основы неба	  
   float3 vec1 = normalize(float3(0.0, 0.0, 1.0));	  
   float sky = saturate(0.95 - dot(vec1, wpos));
	     sky = pow(sky, 2.32);
		 
   float sky1 = saturate(0.15 - dot(vec1, wpos));
	     sky1 = pow(sky1, 0.5);
		 
   float sky2 = (1.05 - dot(vec1, wpos));
	     sky2 = pow(sky2, 40.0);		 

   float3 SkyColorTop = ColorTopNew();
   float3 SkyColorBot = ColorHorizonNew();   
   float3 absorption = getSkyAbsorption(SkyColorTop, sky2);

//=============================================================
//
//=============================================================
  float hourMinutes = (1 / 59) * gGameTimeMinutes;
  float GameTime = gGameTimeHours + hourMinutes;
 
   float t0 = GameTime;
   float3 vec0 = SunDirectionR(GameTime);
   float3 s0 = normalize(float3(0.0, 0.0, -1.0));
   
   float s1 = smoothstep(0.0, 1.0, t0);	
   float s2 = smoothstep(1.0, 23.0, t0);
   float s3 = smoothstep(23.0, 24.0, t0);
   
   float3 vec2 = lerp(s0, vec0, s1);
          vec2 = lerp(vec2, vec0, s2); 
          vec2 = lerp(vec2, vec0, s3);  


   float3 sv = SunDirectionR(GameTime);	
		  
   float vec3 = max(sv.z + 0.1 - 0.0, 0.0);   
   float vec5 = max(sv.z + 0.40 - 0.0, 0.0);
   
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

   float vec6 = lerp(0.4, 0.4, x1);
         vec6 = lerp(vec6, 0.4, x2);
         vec6 = lerp(vec6, 0.4, x3);
         vec6 = lerp(vec6, 0.4, x4);
         vec6 = lerp(vec6, 0.4, xE);
         vec6 = lerp(vec6, 0.5, x5);
         vec6 = lerp(vec6, 0.8, x6);
         vec6 = lerp(vec6, 0.8, x7);
         vec6 = lerp(vec6, 0.9, xG);	
         vec6 = lerp(vec6, 1.0, xZ);			  
         vec6 = lerp(vec6, 1.0, x8);    
         vec6 = lerp(vec6, 1.0, x9);  

   float hor1 = lerp(0.1, 0.1, x1);
         hor1 = lerp(hor1, 0.07, x2);
         hor1 = lerp(hor1, 0.01, x3);
         hor1 = lerp(hor1, 0.0, x4);
         hor1 = lerp(hor1, 0.0, xE);
         hor1 = lerp(hor1, 0.0, x5);
         hor1 = lerp(hor1, 0.0, x6);
         hor1 = lerp(hor1, 0.02, x7);
         hor1 = lerp(hor1, 0.07, xG);	
         hor1 = lerp(hor1, 0.12, xZ);			  
         hor1 = lerp(hor1, 0.12, x8);
	 
   
   float3 sunAbsorption = getSkyAbsorption(SkyColorTop, zenithDensity(sv.z + vec6));
   float3 sAbs = sunAbsorption * 0.5 + 0.5 * length(sunAbsorption);  
    
   //float3 sun = CalculateSun(txcoord) * absorption; 
   float3 Ray = CalculateSunRay(txcoord, wpos)* sunAbsorption;   
   float3 Moon = CalculateMoon(txcoord, wpos);    
// Цвета и прочее	
    float3 SkyRain = lerp(SkyColorTop, SkyColorBot*1.05, sky);	 
    float3 SkyColor = lerp(SkyColorTop, lerp(SkyColorBot*1.05, 0.98, sky1), sky); 	
	       SkyColor*= lerp(sky, 1.0, 0.4); 
           SkyColor+= 0.01;		   
           SkyColor = pow(SkyColor, 3.5);		   
	       SkyColor = lerp(SkyColor*pow(absorption, 1.0), SkyColor, vec3); 
		   SkyColor+= float3(0.95, 0.82, 1.0)*saturate(sky2)*hor1;
		
		   SkyColor*= 12.5;			   
	       SkyColor*= sAbs;
		   
   float sm1 = smoothstep(0.0, 2.0, GameTime),	
         sm2a = smoothstep(2.0, 4.0, GameTime),   
         sm2 = smoothstep(4.0, 5.0, GameTime),	 
         sm3 = smoothstep(5.0, 6.0, GameTime),			 
         sm4 = smoothstep(6.0, 22.0, GameTime),
         sm5 = smoothstep(21.0, 23.0, GameTime),
         sm6 = smoothstep(21.0, 24.0, GameTime);
         //sm7 = smoothstep(21.0, 24.0, GameTime);		 
   float ti = lerp(1.0, 1.0, sm1);
         ti = lerp(ti, 0.0, sm2a);     
         ti = lerp(ti, 0.0, sm2);   
         ti = lerp(ti, 0.0, sm3); 		  
         ti = lerp(ti, 0.0, sm4);
         ti = lerp(ti, 1.0, sm5);
         ti = lerp(ti, 1.0, sm6);
         //ti = lerp(ti, 1.0, sm7);		 
/*		 
   float ti2 = lerp(0.0, 0.0, sm1);
         ti2 = lerp(ti2, 0.4, sm2a);     
         ti2 = lerp(ti2, 0.5, sm2);   
         ti2 = lerp(ti2, 0.6, sm3); 		  
         ti2 = lerp(ti2, 1.0, sm4);
         ti2 = lerp(ti2, 0.0, sm5);
         ti2 = lerp(ti2, 0.0, sm6);		 
         //ti2 = lerp(ti2, 0.0, sm7);
*/
   float ti2 = lerp(0.0, 0.0, x1);
         ti2 = lerp(ti2, 0.3, x2);
         ti2 = lerp(ti2, 0.6, x3);
         ti2 = lerp(ti2, 0.8, x4);
         ti2 = lerp(ti2, 1.0, xE);
         ti2 = lerp(ti2, 1.0, x5);
         ti2 = lerp(ti2, 1.0, x6);
         ti2 = lerp(ti2, 0.6, x7);
         ti2 = lerp(ti2, 0.5, xG);	
         ti2 = lerp(ti2, 0.3, xZ);			  
         ti2 = lerp(ti2, 0.0, x8);
		 
   float ti3 = lerp(0.0, 0.0, x1);  
         ti3 = lerp(ti3, 0.8, sm2a);   
         ti3 = lerp(ti3, 0.9, x2);   
         ti3 = lerp(ti3, 0.9, x3); 		  
         ti3 = lerp(ti3, 0.5, x4);
         ti3 = lerp(ti3, 0.5, x5);
         ti3 = lerp(ti3, 0.5, x6);		 
         ti3 = lerp(ti3, 0.9, x7);
         ti3 = lerp(ti3, 1.0, xG);	
         ti3 = lerp(ti3, 0.5, xZ);			  
         ti3 = lerp(ti3, 0.0, x8);		 
		 
	float3 fnight = lerp(0.0, pow(float3(0.50, 0.70, 0.95)*0.3, 0.9), pow(sky, 0.45));
           SkyColor = lerp(SkyColor, fnight, ti);		   
           SkyColor+= Moon+(Ray*12.5*sAbs);
		   		   
   float wx = gWeather;	
   float3 Pasmurno = lerp(SkyRain*float3(0.90, 0.94, 1.05)*0.2, SkyRain*float3(0.95, 0.98, 1.0)*2.2, saturate(ti2));
          Pasmurno+= Moon*float3(0.85, 0.80, 0.85);


	float VolFog = GetVolumetricFog(wpos.xyz);

         SkyColor.rgb = lerp(SkyColor.rgb, float3(0.765, 0.700, 0.680), ti3*VolFog*0.80);

//if (wx.x==2) SkyColor = Pasmurno;
//if (wx.x==3) SkyColor = Pasmurno;		  
if (wx.x==4) SkyColor = Pasmurno;
if (wx.x==7) SkyColor = Pasmurno;
if (wx.x==8) SkyColor = Pasmurno;
if (wx.x==9) SkyColor = Pasmurno;
if (wx.x==12) SkyColor = Pasmurno;
if (wx.x==15) SkyColor = Pasmurno;
if (wx.x==16) SkyColor = Pasmurno;	
	   	   
           SkyColor = jodieReinhardTonemap(SkyColor);	

		 
    return SkyColor;	
}