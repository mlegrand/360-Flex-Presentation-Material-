package utils
{
	import flash.display.BitmapData;
	import flash.events.TouchEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	import mx.graphics.codec.PNGEncoder;
	
	public class DCanvas extends UIComponent
	{
		public function DCanvas()
		{
			super();
			addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBeginHandler);
			addEventListener(TouchEvent.TOUCH_MOVE, onTouchMoveHandler);
			addEventListener(TouchEvent.TOUCH_END, onTouchEndHandler);
			addEventListener(ResizeEvent.RESIZE, onRisizeHandler);
		}
		
		
		/////
		//  properties
		////
		
		[Bindable]
		public var drawColor:uint = 0x000000;
		
		protected var touchMap:Object = new Object();
		
		
		
		/////
		//  Event Handlers
		////
	
		protected function onTouchBeginHandler(event:TouchEvent):void
		{
			var touchPoint:Object  = new Object();
			touchPoint.id = event.touchPointID.toString();
			touchPoint.x = event.localX;
			touchPoint.y = event.localY;
			touchMap[event.touchPointID.toString()] = touchPoint;
		}
		
		protected function onTouchMoveHandler(event:TouchEvent):void
		{
			if(touchMap[event.touchPointID.toString()])
			{
				var touchPoint:Object = touchMap[event.touchPointID.toString()]
				graphics.lineStyle(8, drawColor)
				graphics.moveTo(touchPoint.x, touchPoint.y);
				graphics.lineTo(event.localX, event.localY);
				//update touch point location 
				touchPoint.x = event.localX;
				touchPoint.y = event.localY;
			}
		}
		
		protected function onTouchEndHandler(event:TouchEvent):void
		{
			delete touchMap[event.touchPointID.toString()] 
		}
		
		
		
		protected function onRisizeHandler(event:ResizeEvent):void
		{
			erase();
		}
		
		
		//
		//  Public methods
		//
		
		public function erase():void
		{
			graphics.clear();
			
			graphics.beginFill(0xFFFFFF, 1);
			graphics.drawRect(0,0,width, height);
			
		}
		
		public function save():void
		{
			var bd:BitmapData = new BitmapData(width, height)
			bd.draw(this);
			
			var ba:ByteArray = (new PNGEncoder()).encode(bd);
			(new FileReference()).save(ba, "doodle.png");
		}
		
		
		
		
		
		
	}
}