package engine 
{
	/**
	 * ...
	 * @author Bagish M.
	 */
	public class Constants 
	{
		private static const I_TILES:Array=[[[0,0,0,0],[1,1,1,1],[0,0,0,0],[0,0,0,0]],[[0,1,0,0],[0,1,0,0],[0,1,0,0],[0,1,0,0]]];
		private static const I_COLOR:uint=0x00FFFF;
		
		private static const T_TILES:Array=[[[0,0,0,0],[1,1,1,0],[0,1,0,0],[0,0,0,0]],[[0,1,0,0],[1,1,0,0],[0,1,0,0],[0,0,0,0]],[[0,1,0,0],[1,1,1,0],[0,0,0,0],[0,0,0,0]],[[0,1,0,0],[0,1,1,0],[0,1,0,0],[0,0,0,0]]];
		private static const T_COLOR:uint=0x494949;
		
		private static const L_TILES:Array=[[[0,0,0,0],[1,1,1,0],[1,0,0,0],[0,0,0,0]],[[1,1,0,0],[0,1,0,0],[0,1,0,0],[0,0,0,0]],[[0,0,1,0],[1,1,1,0],[0,0,0,0],[0,0,0,0]],[[0,1,0,0],[0,1,0,0],[0,1,1,0],[0,0,0,0]]];
		private static const L_COLOR:uint=0xFFA500;
		
		private static const J_TILES:Array=[[[1,0,0,0],[1,1,1,0],[0,0,0,0],[0,0,0,0]],[[0,1,1,0],[0,1,0,0],[0,1,0,0],[0,0,0,0]],[[0,0,0,0],[1,1,1,0],[0,0,1,0],[0,0,0,0]],[[0,1,0,0],[0,1,0,0],[1,1,0,0],[0,0,0,0]]];
		private static const J_COLOR:uint=0x0000FF;
		
		private static const Z_TILES:Array=[[[0,0,0,0],[1,1,0,0],[0,1,1,0],[0,0,0,0]],[[0,0,1,0],[0,1,1,0],[0,1,0,0],[0,0,0,0]]];
		private static const Z_COLOR:uint=0xFF0000;
		
		private static const S_TILES:Array=[[[0,0,0,0],[0,1,1,0],[1,1,0,0],[0,0,0,0]],[[0,1,0,0],[0,1,1,0],[0,0,1,0],[0,0,0,0]]];
		private static const S_COLOR:uint=0x00FF00;
		
		private static const O_TILES:Array=[[[0,1,1,0],[0,1,1,0],[0,0,0,0],[0,0,0,0]]];
		private static const O_COLOR:uint = 0xFFFF00;
		
		/*private static const X_TILES:Array=[[[0,0,1,0],[0,1,1,1],[0,0,1,0],[0,0,0,0]]];
		private static const X_COLOR:uint=0x000000;*/
		
		public static const SHAPES_TILES_LIST:Array /*of Arrays*/ = [I_TILES, T_TILES, L_TILES, J_TILES, Z_TILES, S_TILES, O_TILES/*, X_TILES*/];
		public static const SHAPES_COLORES_LIST:Array /*of uints*/ = [I_COLOR, T_COLOR, L_COLOR, J_COLOR, Z_COLOR, S_COLOR, O_COLOR/*, X_COLOR*/];
	}
}