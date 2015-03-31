package engine 
{
	import flash.ui.Keyboard;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Bagish M.
	 */
	public class GameEngine extends Sprite implements IGameEngine
	{
		private var _gameField	:Vector.<Vector.<Cell>>;
		
		private var _gameLayer	:Sprite;
		private var _hudLayer	:Sprite;
		
		private var _currentShape	:Tetromino;
		private var _infoBar		:InfoBar;
		private var _popup			:Popup;
		
		private var _nextStepTimeMark	:Number = 0;
		private var _nextShapeIndex		:int = -1;
		private var _isGameActive		:Boolean;
		private var _clearedRowsIndexesList:Array /*of int's*/ = [];
		private var _level				:int=1;
		private var _score				:int=0;
		private var _linesCleared		:int=0;
		private var _currentSpeed		:Number = Settings.GAME_SPEED;
		private var _infinitieModeScoreMark:Number = 0;
		private var _isDownKeyPressed	:Boolean;
		
		public function GameEngine() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		override public function dispose():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			removeEventListener(Event.TRIGGERED, onButtonTriggered);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_currentShape = null;
			for each (var item:Vector.<Cell> in _gameField) {
				_gameField = null;
			}
			_gameField = null;
			
			super.dispose();
		}
		
		private function onAddToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			initialize();
			_popup.show(Popup.START_GAME);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(Event.TRIGGERED, onButtonTriggered);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function initialize():void 
		{
			_gameLayer = new Sprite();
			_hudLayer = new Sprite();
			addChild(_gameLayer);
			addChild(_hudLayer);
			
			_infoBar = new InfoBar(this);
			_infoBar.x = Settings.INFO_BAR_POS.x;
			_infoBar.y = Settings.INFO_BAR_POS.y;
			_hudLayer.addChild(_infoBar);
			
			_popup = new Popup();
			addChild(_popup);
			
			_currentShape = new Tetromino(this);
			
			//initialize game field cells
			_gameField = new Vector.<Vector.<Cell>>(Settings.FIELD_HEIGH, true);
			for (var i:int = 0; i < Settings.FIELD_HEIGH; i++) 
			{
				_gameField[i] = new Vector.<Cell>(Settings.FIELD_WIDTH, true);
				
				for (var j:int = 0; j < Settings.FIELD_WIDTH; j++) 
				{
					var cell:Cell = new Cell();
					
					cell.x = Settings.GAME_FIELD_POS.x + j * Settings.CELL_SIZE;
					cell.y = Settings.GAME_FIELD_POS.y + i * Settings.CELL_SIZE;
					
					_gameField[i][j] = cell;
					_gameLayer.addChild(cell);
				}
			}
		}
		
		private function startGame():void 
		{
			_currentShape.setNewShape(getRandomShape());
			_nextShapeIndex = getRandomShape();
			
			_infoBar.updateNextShapePreview();
			_infoBar.updateLabels();
			
			_isGameActive = true;	
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			if (_isGameActive) 
			{
				_nextStepTimeMark += e.passedTime;
				if (_nextStepTimeMark > _currentSpeed && !_isDownKeyPressed) 
				{
					_nextStepTimeMark = 0;
					
					if (_currentShape.isEnableMoveDown()){
						_currentShape.moveDown();
					} else {
						handleShapeToFieldSetting();
					}
				}
			}
		}
		
		private function handleShapeToFieldSetting():void 
		{
			setShapeTilesAsOccupiedFieldCells();
			
			if (isGameOver()) 
			{
				_popup.show(Popup.GAME_OVER);
				_isGameActive = false;
			} 
			else 
			{
				if (getCompletedLinesAmount() > 0) 
				{
					_score += Settings.SCORE_PER_LINE[_clearedRowsIndexesList.length-1];
					_linesCleared += _clearedRowsIndexesList.length;
					checkForLevelFinishing();
					
					removeClearedLines();
					_infoBar.updateLabels();
				}
				
				getNewShape();
				_infoBar.updateNextShapePreview();
			}
		}
		
		private function checkForLevelFinishing():void 
		{
			//if current level is not out of score-to-level pattern, than increase level and game speed
			if (_level < Settings.SCORE_TO_NEX_LEVEL_LIST.length) {
				if (_score >= Settings.SCORE_TO_NEX_LEVEL_LIST[_level - 1]) {
					_level++;
					_currentSpeed = Settings.GAME_SPEED - Settings.PER_LEVEL_SPEED_PENALTY * (_level - 1);
				}
			}
			//else count fixed per-level-score, to provide infinitie level increasing without speed changing
			else {
				if (_score - _infinitieModeScoreMark > Settings.INFINITIE_LEVEL_SCORE_THRESHHOLD) {
					_level++;
					_infinitieModeScoreMark = 0;
				}
				else {
					_infinitieModeScoreMark = _score;
				}
			} 
		}
		
		private function removeClearedLines():void 
		{
			//clear removed row cells
			var i:int, j:int;
			var completedRowsAmount:int = _clearedRowsIndexesList.length;
			for (i = _clearedRowsIndexesList[completedRowsAmount-1]; i <= _clearedRowsIndexesList[0]; i++) {
				for (j = 0; j < Settings.FIELD_WIDTH; j++) 
				{
					_gameField[i][j].clear();
				}
			}
			
			//let down remained above cells
			var highestCellIndex:int = _clearedRowsIndexesList[completedRowsAmount - 1] - 1;
			for (i = 0; i < Settings.FIELD_WIDTH; i++) {
				for (j = highestCellIndex; j >= 0; j--) 
				{
					if (_gameField[j][i].state == Cell.OCCUPIED) {
						_gameField[j + completedRowsAmount][i].occupyCell(Cell.OCCUPIED, _gameField[j][i].shapeType);
						_gameField[j][i].clear();
					}
				}
			}
		}
		
		private function getCompletedLinesAmount():int 
		{
			_clearedRowsIndexesList = [];
			
			for (var i:int = Settings.FIELD_HEIGH-1; i >= 0 ; i--) 
			{
				var isRowFilled:Boolean = true;
				for (var j:int = 0; j < Settings.FIELD_WIDTH; j++) 
				{
					if (_gameField[i][j].state != Cell.OCCUPIED) {
						isRowFilled = false;
					}
				}
				
				if (isRowFilled) {
					_clearedRowsIndexesList.push(i);
				}
			}
			
			return _clearedRowsIndexesList.length;
		}
		
		private function getNewShape():void 
		{
			_currentShape.setNewShape(_nextShapeIndex);
			_nextShapeIndex = getRandomShape();
		}
		
		private function isGameOver():Boolean
		{
			for (var i:int = 0; i < Settings.FIELD_WIDTH; i++) {
				if (_gameField[0][i].state == Cell.OCCUPIED)
					return true;
			}
			
			return false;
		}
		
		private function setShapeTilesAsOccupiedFieldCells():void 
		{
			for (var i:int = 0; i < Settings.FIELD_HEIGH; i++) {
				for (var j:int = 0; j < Settings.FIELD_WIDTH; j++) 
				{
					if (_gameField[i][j].state == Cell.TETROMINO_TILE) {
						_gameField[i][j].occupyCell(Cell.OCCUPIED, _currentShape.shapeType);
					}
				}
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (!_isGameActive)
				return;
			
			if (e.keyCode == Keyboard.LEFT) {
				_currentShape.moveLeft();
			}
			else if (e.keyCode == Keyboard.RIGHT) {
				_currentShape.moveRight();
			}
			else if (e.keyCode == Keyboard.UP) {
				_currentShape.rotate();
			}
			else if (e.keyCode == Keyboard.DOWN) 
			{
				_isDownKeyPressed = true;
				if (_currentShape.isEnableMoveDown())
				{
					_currentShape.moveDown();
				}
				else 
				{
					handleShapeToFieldSetting();
				}
			}
			
			if (e.keyCode == Keyboard.P) 
			{
				_isGameActive = false;
				_popup.show(Popup.PAUSE);
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.DOWN) 
				_isDownKeyPressed = false;
		}
		
		private function onButtonTriggered(event:Event):void
        {
            var button:Button = event.target as Button;
            
			if (button.name == "restartGame" && !_isGameActive) 
			{
				restartGame();
				_popup.hide();
			}
			else if (button.name == "resumeGame" && !_isGameActive) 
			{
				_isGameActive = true;
				_popup.hide();
			}
			else if (button.name == "startGame" && !_isGameActive)
			{
				startGame();
				_popup.hide();
			}
        }
		
		private function restartGame():void 
		{
			_level 		= 1;
			_score 		= 0;
			_linesCleared = 0;
			_infinitieModeScoreMark = 0;
			_currentSpeed = Settings.GAME_SPEED;
			
			clearAllCells();
			_currentShape.setNewShape(getRandomShape());
			_nextShapeIndex = getRandomShape();
			
			_infoBar.updateNextShapePreview();
			_infoBar.updateLabels();
			
			_isGameActive = true;
		}
		
		private function getRandomShape():int
		{
			return Math.random() * Constants.SHAPES_TILES_LIST.length
		}
		
		private function clearAllCells():void 
		{
			for each (var item:Vector.<Cell> in _gameField) {
				for each (var cell:Cell in item) {
					cell.clear();
				}
			}
		}
		
		public function get gameField():Vector.<Vector.<Cell>> {
			return _gameField;
		}
		
		public function get nextShapeIndex():int 
		{
			return _nextShapeIndex;
		}
		
		public function get level():int 
		{
			return _level;
		}
		
		public function get score():int 
		{
			return _score;
		}
		
		public function get linesCleared():int 
		{
			return _linesCleared;
		}
		
	}
}