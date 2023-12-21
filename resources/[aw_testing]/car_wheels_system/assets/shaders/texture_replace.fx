texture gTexture;

technique TexReplace
{
    pass P0
    {
        // Let the magic do its' magic!
        // Поцоны, я не знаю, как это работает, но оно работает.
        // Не связывайтесь с шейдерами, у меня от них брат умер.
        // pomogite
        Texture[1] = gTexture;
        ColorOp[1] = Modulate;
        ColorArg1[1] = Current;
        ColorArg2[1] = Texture;
    }
}
