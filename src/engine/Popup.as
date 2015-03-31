package engine 
{
	import gs.TweenMax;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Bagish M.
	 */
	public class Popup extends Sprite
	{
		public static const PAUSE		:int = 0;
		public static const GAME_OVER	:int = 1;
		public static const START_GAME	:int = 2;
		
		private const TRANSITION_DURATION:Number = 0.4;
		
		private var _backShield	:Quad;
		private var _restartBtn	:Button;
		private var _title		:TextField;
		
		public function Popup() 
		{
			_backShield = new Quad(Settings.FIELD_WIDTH*Settings.CELL_SIZE, Settings.FIELD_HEIGH*Settings.CELL_SIZE, 0xA0A0A0);
			_backShield.alpha = 0.9;
			addChild(_backShield);
			
			_restartBtn = new Button(Game.assets.getTexture("buttonBack"), "restart", null);
			_restartBtn.name = "restartGame";
			_restartBtn.x = _backShield.width / 2 - _restartBtn.width / 2;
			_restartBtn.y = _backShield.height / 2 - _restartBtn.height / 2;
			addChild(_restartBtn);
			
			_title = new TextField(200, 100, "", "tetrisFont", 25);
			addChild(_title);
			_title.x = _backShield.width / 2 - _title.width / 2;
			_title.y = _backShield.height / 2 - 100;
			
			this.x = Settings.GAME_FIELD_POS.x;
			this.y = Settings.GAME_FIELD_POS.y;
		}
		
		public function show(popupType:int):void 
		{
			if (popupType == PAUSE) {
				_title.text = "PAUSE";
				_restartBtn.name = "resumeGame";
				_restartBtn.text = "RESUME";
			}
			else if (popupType == GAME_OVER) {
				_title.text = "GAME OVER";
				_restartBtn.name = "restartGame";
				_restartBtn.text = "RESTART";
			}
			else if (popupType == START_GAME) {
				_title.text = "TETRIS";
				_restartBtn.name = "startGame";
				_restartBtn.text = "START";
			}
			
			TweenMax.to(this, TRANSITION_DURATION, {y:Settings.GAME_FIELD_POS.y} );
		}
		
		public function hide():void 
		{
			TweenMax.to(this, TRANSITION_DURATION, {y:-_backShield.height} );
		}
		
	}

}