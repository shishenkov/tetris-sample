package engine 
{
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Bagish M.
	 */
	public class Cell extends Sprite
	{
		public static const EMPTY			:int = 0;
		public static const TETROMINO_TILE	:int = 1;
		public static const OCCUPIED		:int = 2;
		
		private var _state	:int = EMPTY;
		private var _tile	:Image;
		private var _shapeType:int = -1;
		
		public function Cell() 
		{
			_tile = new Image(Game.assets.getTexture("tile"));
			addChild(_tile);
			clear();
		}
		
		public function occupyCell(state:int, shapeType:int, updateView:Boolean = true):void
		{
			_state = state;
			_shapeType = shapeType;
			
			if(updateView)
				_tile.color = Constants.SHAPES_COLORES_LIST[_shapeType];
		}
		
		public function clear(updateView:Boolean = true):void
		{
			_state = EMPTY;
			_shapeType = -1;
			
			if(updateView)
				_tile.color = Settings.EMPTY_CELL_COLOR;
		}
		
		public function get state():int 
		{
			return _state;
		}
		
		public function get shapeType():int 
		{
			return _shapeType;
		}
	}
}



