package sampleCode
{
	import flash.display.DisplayObject;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	public class RotatableScalable
	{
		protected var disO:DisplayObject;
		public function RotatableScalable(displayObject:DisplayObject)
		{
			disO = displayObject;
			if(Multitouch.supportsGestureEvents)
			{
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
				addGestureEventListeners()
			}
		}
		
		
		protected function addGestureEventListeners():void
		{
			disO.addEventListener(TransformGestureEvent.GESTURE_ROTATE, gestureRotateHandler);
			disO.addEventListener(TransformGestureEvent.GESTURE_ZOOM, gestureZoomHandler);
		}
		protected function gestureRotateHandler(event:TransformGestureEvent) : void
		{
			event.stopImmediatePropagation();
			var m:Matrix = disO.transform.matrix;
			var p:Point = m.transformPoint(new Point(disO.width/2, disO.height/2));
			m.translate(-p.x, -p.y);
			m.rotate(event.rotation*(Math.PI/180));
			m.translate(p.x, p.y);
			disO.transform.matrix = m;
		}
		protected function gestureZoomHandler(event:TransformGestureEvent):void
		{
			event.stopImmediatePropagation();
			var m:Matrix = disO.transform.matrix;
			var p:Point = m.transformPoint(new Point(disO.width/2, disO.height/2));
			m.translate(-p.x, -p.y);
			m.scale(event.scaleX, event.scaleY);
			m.translate(p.x, p.y);
			disO.transform.matrix = m;
		}
		
		
	}
}