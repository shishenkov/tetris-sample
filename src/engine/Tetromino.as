package engine 
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Bagish M.
	 */
	public class Tetromino
	{
		public static const SHAPE_TILES_SIZE	:int = 4;
		
		private const DIRECTION_LEFT	:int = 0;
		private const DIRECTION_RIGHT	:int = 1;
		private const DIRECTION_DOWN	:int = 2;
		
		private var _currShapeTiles	:Vector.<Vector.<int>>;
		private var _shapeType		:int = -1;
		private var _engine			:IGameEngine;
		
		private var _onFieldPosition	:Point = new Point();
		private var _currentRotationIndex:int = 0;
		
		public function Tetromino(engine:IGameEngine) 
		{
			_engine = engine;
			
			initialize();
		}
		
		public function dispose():void
		{
			_engine = null;
			for each (var item:Vector.<int> in _currShapeTiles) {
				item = null;
			}
			_currShapeTiles = null;
			
			super.dispose();
		}
		
		private function initialize():void 
		{
			_currShapeTiles = new Vector.<Vector.<int>>(SHAPE_TILES_SIZE, true);
			for (var i:int = 0; i < SHAPE_TILES_SIZE; i++)
			{
				_currShapeTiles[i] = new Vector.<int>(SHAPE_TILES_SIZE, true);
			}
		}
		
		public function setNewShape(shapeType:int):void 
		{
			_shapeType = shapeType;
			_currentRotationIndex = 0;
			
			resetPosition();
			setNewShapeTilesList();
			liftShapeIfFirstRowEmpty();
			setShapeTilesView();
		}
		
		private function resetPosition():void 
		{
			_onFieldPosition.x = int(Settings.FIELD_WIDTH/2) - 2;
			_onFieldPosition.y = 0;
		}
		
		private function setNewShapeTilesList():void 
		{
			for (var i:int = 0; i < SHAPE_TILES_SIZE; i++) {
				for (var j:int = 0; j < SHAPE_TILES_SIZE; j++) 
				{
					_currShapeTiles[i][j] = Constants.SHAPES_TILES_LIST[_shapeType][_currentRotationIndex][i][j];
				}
			}
		}
		
		private function liftShapeIfFirstRowEmpty():void 
		{
			if (_onFieldPosition.y == 0) 
			{
				var _isFirstRowEmpty:Boolean = true;
				for (var i:int = 0; i < SHAPE_TILES_SIZE; i++) {
					if (_currShapeTiles[0][i] == 1) {
						_isFirstRowEmpty = false;
						break;
					}
				}
				_onFieldPosition.y = _isFirstRowEmpty ? -1 : 0;
			}
		}
		
		public function moveDown():void
		{
			if (isFitAfterMove(DIRECTION_DOWN)) 
			{
				clearTetrominoCells();
				_onFieldPosition.y++;
				setShapeTilesView();
			}
		}
		
		public function moveLeft():void 
		{
			if (isFitAfterMove(DIRECTION_LEFT)) 
			{
				clearTetrominoCells();
				_onFieldPosition.x--;
				setShapeTilesView();
			}
		}
		
		public function moveRight():void 
		{
			if (isFitAfterMove(DIRECTION_RIGHT)) 
			{
				clearTetrominoCells();
				_onFieldPosition.x++;
				setShapeTilesView();
			}
		}
		
		public function rotate():void 
		{
			//if shape is not rotatable then return
			if (Constants.SHAPES_TILES_LIST[_shapeType].length == 1)
				return;
			
			//is next rotation index is out of list
			var nextRotationIndex:int = _currentRotationIndex + 1;
			if(nextRotationIndex >= Constants.SHAPES_TILES_LIST[_shapeType].length)
				nextRotationIndex = 0;
			
			if (isRotatedShapeFits(nextRotationIndex))
			{
				//save rotation index
				_currentRotationIndex = nextRotationIndex;
				//clear current shape cells
				clearTetrominoCells();
				//set up new shape
				setNewShapeTilesList();
				//update shape view
				setShapeTilesView();
			}
		}
		
		/* 
		 * Is rotated shape fits to game field and not collide with occupied cells
		*/
		private function isRotatedShapeFits(rotationIndex:int):Boolean
		{
			for (var i:int = 0; i < SHAPE_TILES_SIZE; i++) {
				for (var j:int = 0; j < SHAPE_TILES_SIZE; j++) 
				{
					var rotatedShapeTile:int = Constants.SHAPES_TILES_LIST[_shapeType][rotationIndex][i][j];
					
					if (rotatedShapeTile == 1)
					{
						var row:int = _onFieldPosition.y + i;
						var column:int = _onFieldPosition.x + j;
						
						if (row < 0 || row >= Settings.FIELD_HEIGH 
						|| column < 0 || column >= Settings.FIELD_WIDTH 
						|| _engine.gameField[row][column].state == Cell.OCCUPIED) 
						{
							return false;
						}
					}
				}
			}
			
			return true;
		}
		
		/*
		* Is shape fits to game field after move in certain direction
		*/
		private function isFitAfterMove(direction:int):Boolean
		{
			var newPosition:Point = _onFieldPosition.clone();
			
			if (direction == DIRECTION_LEFT) {
				newPosition.x--;
			}
			else if(direction == DIRECTION_RIGHT){
				newPosition.x++;
			}
			else if (direction == DIRECTION_DOWN) {
				newPosition.y++;
			}
			
			for (var i:int = 0; i < SHAPE_TILES_SIZE; i++) {
				for (var j:int = 0; j < SHAPE_TILES_SIZE; j++) 
				{
					if (_currShapeTiles[i][j] == 1)
					{
						var row:int = newPosition.y + i;
						var column:int = newPosition.x + j;
						
						if (row < 0 || row >= Settings.FIELD_HEIGH 
						|| column < 0 || column >= Settings.FIELD_WIDTH 
						|| _engine.gameField[row][column].state == Cell.OCCUPIED) 
						{
							return false;
						}
					}
				}
			}
			
			return true;
		}
		
		public function isEnableMoveDown():Boolean
		{
			return isFitAfterMove(DIRECTION_DOWN);
		}
		
		private function clearTetrominoCells():void 
		{
			for (var i:int = 0; i < SHAPE_TILES_SIZE; i++) {
				for (var j:int = 0; j < SHAPE_TILES_SIZE; j++) 
				{
					if (_currShapeTiles[i][j] == 1) 
					{
						var row:int = _onFieldPosition.y + i;
						var column:int = _onFieldPosition.x + j;
						
						_engine.gameField[row][column].clear();
					}
				}
			}
		}
		
		private function setShapeTilesView():void 
		{
			for (var i:int = 0; i < SHAPE_TILES_SIZE; i++) {
				for (var j:int = 0; j < SHAPE_TILES_SIZE; j++) 
				{
					if (_currShapeTiles[i][j] == 1) 
					{
						var row:int = _onFieldPosition.y + i;
						var column:int = _onFieldPosition.x + j;
						
						_engine.gameField[row][column].occupyCell(Cell.TETROMINO_TILE, _shapeType);
					}
				}
			}
		}
		
		public function get shapeType():int 
		{
			return _shapeType;
		}
	}
}