// Variable to fetch the texture from the script
texture gTexture;

// My nice technique. Requires absolutely no tools, worries nor skills
technique TexReplace
{
	pass P0
	{
		// Set the texture
		Texture[0] = gTexture;
		 ColorOp[1] = Modulate;
        ColorArg1[1] = Current;
        ColorArg2[1] = Texture;

		
		// LET THE MAGIC DO ITS MAGIC!
	}
}