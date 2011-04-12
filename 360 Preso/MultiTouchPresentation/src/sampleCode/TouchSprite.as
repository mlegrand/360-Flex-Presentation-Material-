package sampleCode
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import spark.core.SpriteVisualElement;
	
	public class TouchSprite extends SpriteVisualElement
	{
		protected var touchMapper:Array = [];
		protected var bkg:Sprite = new Sprite();
		public function TouchSprite()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addBackgrond)
			bkg.addEventListener(TouchEvent.TOUCH_BEGIN, touchevent_beginHandler);
		}
		protected function touchevent_beginHandler(event:TouchEvent):void
		{
			var b:Sprite = buildBlob();
			this.addChild(b);
			
			var p:Point = new Point(event.localX, event.localY);
			 p = globalToLocal(p);
			
			b.x = p.x;
			b.y = p.y;
			touchMapper[event.touchPointID] = b;
		}
		protected function touchevent_moveHandler(event:TouchEvent):void
		{
			if(touchMapper[event.touchPointID])
			{
				touchMapper[event.touchPointID].x = event.localX-this.x;
				touchMapper[event.touchPointID].y = event.localY-this.y;
			}
		}
		protected function touchevent_endHandler(event:TouchEvent):void
		{
			this.removeChild(touchMapper[event.touchPointID]);
			delete touchMapper[event.touchPointID];
		}
		
		protected function buildBlob():Sprite
		{
			var blob:Sprite = new Sprite();
			blob.graphics.beginFill(0x000000, 0.75);
			blob.graphics.drawCircle(0,0, 20);
			blob.graphics.endFill();
			return blob;
		}
		
		
		protected function addBackgrond(e:Event):void
		{
			bkg.graphics.beginFill(0xFFFFFF, 1);
			bkg.graphics.drawRect(0,0, 800, 400);
			bkg.graphics.endFill();
			this.addChild(bkg);
		}
		
	}
}