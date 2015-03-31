package
{
    public class EmbeddedAssets
    {
        /** ATTENTION: Naming conventions!
         *  
         *  - Classes for embedded IMAGES should have the exact same name as the file,
         *    without extension. This is required so that references from XMLs (atlas, bitmap font)
         *    won't break.
         *    
         *  - Atlas and Font XML files can have an arbitrary name, since they are never
         *    referenced by file name.
         * 
         */
        
		[Embed(source="../assets/textures/tile.png")]
        public static const tile:Class;
		
		[Embed(source="../assets/textures/button.png")]
        public static const buttonBack:Class;
		
		[Embed(source="../assets/fonts/pixel.ttf", embedAsCFF="false", fontFamily="tetrisFont")]
        public static const tetrisFont:Class;
    }
}