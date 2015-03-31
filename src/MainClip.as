package 
{
	import engine.Game;
	import flash.display.Sprite;
	import flash.system.Capabilities;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.AssetManager;
    
    public class MainClip extends Sprite
    {
        private var mStarling:Starling;
        
        public function MainClip()
        {
            if (stage) start();
            else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
        
		private function onAddedToStage(event:Object):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			start();
		}
		
        private function start():void
        {
            Starling.multitouchEnabled = true;
            Starling.handleLostContext = true;
            
            mStarling = new Starling(Game, stage);
            mStarling.simulateMultitouch = true;
            mStarling.enableErrorChecking = Capabilities.isDebugger;
            mStarling.start();
            
            mStarling.addEventListener(Event.ROOT_CREATED, onRootCreated);
        }
        
        private function onRootCreated(event:Event, game:Game):void
        {
            if (mStarling.context.driverInfo.toLowerCase().indexOf("software") != -1)
                mStarling.nativeStage.frameRate = 30;
            
            var assets:AssetManager = new AssetManager();
            assets.verbose = Capabilities.isDebugger;
            assets.enqueue(EmbeddedAssets);
            
            game.start(assets);
        }
    }
}