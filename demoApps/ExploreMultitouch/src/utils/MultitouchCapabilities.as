package utils
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.sampler.NewObjectSample;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	
	public class MultitouchCapabilities extends Sprite
	{
		
		protected var touchEnabled:TextField;
		protected var numberOfTouchPoints:TextField;
		protected var supportsGestures:TextField;
		protected var supportedGestures:TextField;
		protected var touchScreenType:TextField;
		protected var playerType:TextField;
		
		
		//other details
		protected var os:TextField;
		
		//group
		protected var allElements:Array;
		
		
		protected var textF:TextFormat = new TextFormat(null, 22, 0xFFFFFF, null, null, null, null, null, null, null, null, null, null);
		
		
		public function MultitouchCapabilities()
		{
			buildTextObjects();
			//addEventListener(Event.ADDED_TO_STAGE, addBackground)
		}
		
		protected function buildTextObjects():void
		{
			
			touchEnabled = styleTextField(touchEnabled);
			touchEnabled.text = 'Supports raw touch events: '+ Multitouch.supportsTouchEvents;
			
			numberOfTouchPoints= styleTextField(numberOfTouchPoints);
			numberOfTouchPoints.text = 'Number of supported touch points: '+ Multitouch.maxTouchPoints;
			
			supportsGestures= styleTextField(supportsGestures);
			supportsGestures.text = 'Supports Gestures: '+ Multitouch.supportsGestureEvents;
			
			supportedGestures= styleTextField(supportedGestures);
			supportedGestures.text = 'List of supported gestures: '+ Multitouch.supportedGestures;
			
			
			
			touchScreenType= styleTextField(touchScreenType);
			touchScreenType.text = 'Touch screen type: '+ Capabilities.touchscreenType;
			
			
			
			
			//other details
			os = styleTextField(os);
			os.text = 'Operating System: '+ Capabilities.os;
			
			playerType = styleTextField(os);
			playerType.text = 'Flash Player Version: '+ Capabilities.version;
			
			
			//end 
		
			allElements = [touchEnabled, numberOfTouchPoints, supportsGestures,supportedGestures, touchScreenType, os, playerType];
			addElements();
		}
		
		protected function styleTextField(tf:TextField):TextField
		{
			tf = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.width = 200;
			tf.defaultTextFormat = textF;
			tf.textColor = 0xFFFFFF;
			return tf;
		}
		
		
		protected function addElements():void
		{
			var i:int = 1;
			for each (var disO:TextField in allElements)
			{
				styleTextField(disO);
				this.addChild(disO);
				disO.y = i*50;
				disO.x = 35;
				i++;	
			}
		}
		
	}
}