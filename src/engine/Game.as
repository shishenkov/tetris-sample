package engine
{
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.utils.AssetManager;
	import utils.ProgressBar;
        
    public class Game extends Sprite
    {
        private static var _assets:AssetManager;
		
        private var _loadingProgress:ProgressBar;
		private var _currentScene:Sprite;
        
        
        public function Game()
        {
			
        }
        
        public function start(assets:AssetManager):void
        {
            _assets = assets;
            
            _loadingProgress = new ProgressBar(175, 20);
            _loadingProgress.x = stage.stageWidth / 2 - _loadingProgress.width / 2;
            _loadingProgress.y = stage.stageHeight / 2;
            addChild(_loadingProgress);
            
            assets.loadQueue(function(ratio:Number):void
            {
                _loadingProgress.ratio = ratio;
                
                if (ratio == 1)
                    Starling.juggler.delayCall(function():void
                    {
                        _loadingProgress.removeFromParent(true);
                        _loadingProgress = null;
                        showMainMenu();
                    }, 0.15);
            });
        }
        
        private function showMainMenu():void
        {
			trace("Assets loading finish");
			
			_currentScene = new GameEngine();
			addChild(_currentScene);
        }
        
        public static function get assets():AssetManager { return _assets; }
    }
}