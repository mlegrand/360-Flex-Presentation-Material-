package mt
{
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import spark.components.Image;
	
	public class RotateScaleImage extends Image
	{
		public function RotateScaleImage()
		{
			super();
			addGestureEventListeners()
		}
		
		protected function addGestureEventListeners():void
		{
			this.addEventListener(TransformGestureEvent.GESTURE_ROTATE, gestureRotateHandler);
			this.addEventListener(TransformGestureEvent.GESTURE_ZOOM, gestureZoomHandler);
		}
		protected function gestureRotateHandler(event:TransformGestureEvent) : void
		{
			event.stopImmediatePropagation();
			var m:Matrix = this.transform.matrix;
			var p:Point = m.transformPoint(new Point(this.width/2, this.height/2));
			m.translate(-p.x, -p.y);
			m.rotate(event.rotation*(Math.PI/180));
			m.translate(p.x, p.y);
			this.transform.matrix = m;
		}
		protected function gestureZoomHandler(event:TransformGestureEvent):void
		{
			event.stopImmediatePropagation();
			var m:Matrix = this.transform.matrix;
			var p:Point = m.transformPoint(new Point(this.width/2, this.height/2));
			m.translate(-p.x, -p.y);
			m.scale(event.scaleX, event.scaleY);
			m.translate(p.x, p.y);
			this.transform.matrix = m;
		}
	}
}