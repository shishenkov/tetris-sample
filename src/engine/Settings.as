package engine 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Bagish M.
	 */
	public class Settings 
	{
		public static const FIELD_WIDTH	:int = 10;
		public static const FIELD_HEIGH	:int = 20;
		public static const CELL_SIZE	:int = 24;
		
		public static const GAME_FIELD_POS	:Point = new Point(0, 0);
		public static const INFO_BAR_POS	:Point = new Point(250, 50);
		
		public static const GAME_SPEED		:Number = 1.0;
		public static const PER_LEVEL_SPEED_PENALTY:Number = 0.1;
		public static const PER_LEVEL_SCORE	:int = 100;
		
		public static const SCORE_TO_NEX_LEVEL_LIST:Array /*of int's*/ = [500, 1500, 3000, 6000, 8000, 12000, 15000, 18000];
		//public static const SCORE_TO_NEX_LEVEL_LIST:Array /*of int's*/ = [100, 200, 300, 400, 500, 600, 700, 800];
		public static const INFINITIE_LEVEL_SCORE_THRESHHOLD:int = 100;
		public static const SCORE_PER_LINE:Array /*of int's*/ = [100, 300, 700, 1500];
		
		public static const EMPTY_CELL_COLOR:uint = 0x8F8F8F;
	}

}