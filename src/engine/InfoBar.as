package engine 
{
	import flash.geom.Point;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Bagish M.
	 */
	public class InfoBar extends Sprite
	{
		private var _engine		:IGameEngine;
		private var _nextShapePreview:Sprite;
		private var _currShapeTiles:Vector.<Vector.<Cell>>;
		private var _level		:TextField;
		private var _score		:TextField;
		private var _lines		:TextField;
		
		
		public function InfoBar(engine:IGameEngine) 
		{
			_engine = engine;
			
			_nextShapePreview = new Sprite();
			addChild(_nextShapePreview);
			initializePreviewShape();
			_nextShapePreview.x = 60;
			_nextShapePreview.scaleX = _nextShapePreview.scaleY = 0.8;
			
			_level = new TextField(200, 100, "level:", "tetrisFont", 25);
			addChild(_level);
			
			_score = new TextField(200, 100, "score:", "tetrisFont", 25);
			addChild(_score);
			
			_lines = new TextField(200, 100, "lines:", "tetrisFont", 25);
			_lines.underline
			addChild(_lines);
			
			_level.y = 100;
			_score.y = 180;
			_lines.y = 260;
		}
		
		override public function dispose():void 
		{
			for each (var item:Vector.<Cell> in _currShapeTiles) {
				item = null;
			}
			_currShapeTiles = null;
			_engine = null;
			
			super.dispose();
		}
		
		private function initializePreviewShape():void 
		{
			_currShapeTiles = new Vector.<Vector.<Cell>>(Tetromino.SHAPE_TILES_SIZE, true);
			for (var i:int = 0; i < Tetromino.SHAPE_TILES_SIZE; i++) 
			{
				_currShapeTiles[i] = new Vector.<Cell>(Tetromino.SHAPE_TILES_SIZE, true);
				for (var j:int = 0; j < Tetromino.SHAPE_TILES_SIZE; j++) 
				{
					var cell:Cell = new Cell();
					cell.x = j * Settings.CELL_SIZE;
					cell.y = i * Settings.CELL_SIZE;
					_currShapeTiles[i][j] = cell;
					_nextShapePreview.addChild(cell);
				}
			}
		}
		
		public function updateNextShapePreview():void 
		{
			for (var i:int = 0; i < Tetromino.SHAPE_TILES_SIZE; i++) {
				for (var j:int = 0; j < Tetromino.SHAPE_TILES_SIZE; j++) 
				{
					if (Constants.SHAPES_TILES_LIST[_engine.nextShapeIndex][0][i][j] == 1)
					{
						_currShapeTiles[i][j].occupyCell(Cell.OCCUPIED, _engine.nextShapeIndex);
						_currShapeTiles[i][j].alpha = 1;
					}
					else {
						_currShapeTiles[i][j].clear();
						_currShapeTiles[i][j].alpha = 0.5;
					}
				}
			}
		}
		
		public function updateLabels():void 
		{
			_level.text = "level:\n\n" + _engine.level;
			_score.text = "score:\n\n" + _engine.score;
			_lines.text = "lines:\n\n" + _engine.linesCleared;
		}
	}

}