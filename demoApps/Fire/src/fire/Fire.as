package fire
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import mx.core.UIComponent;
	
	public class Fire extends UIComponent
	{
		private var canvas:BitmapData;
		private var canvasBitmap:Bitmap;
		
		// genral geometry constants
		private var p1:Point;
		private var p2:Point;
		private var p3:Point;
		private var r:Rectangle;
		private var blobRect:Rectangle;
		
		// constants that define fire appearance
		private var bf:BlurFilter;
		private var ct:ColorTransform;
		private var ct2:ColorTransform;
		private var m:Matrix;
		
		//canvas starter size
		protected var canvasStarterSize:Number = 200;
		
		
		// make some noise pattern
		private var noise:BitmapData;
		
		public function Fire()
		{
			super();
			addEventListeners();
		}
		
		override protected function createChildren() : void
		{
			super.createChildren();
			
			canvas = new BitmapData(canvasStarterSize, canvasStarterSize, false, 0);
			canvasBitmap = new Bitmap(canvas);
			addChild(canvasBitmap);
			// genral geometry constants
			p1 = new Point (0, 0);
			p2 = new Point (0, canvas.height -1);
			p3 = new Point (0,0);
			r = new Rectangle (0, 0, canvas.width, 2);
			blobRect = new Rectangle(0,0, 20, 20);
			// constants that define fire appearance
			
			bf = new BlurFilter (6,6, 1);
			ct = new ColorTransform(1.05, 1.03, 1.00, 1, -1, -1, -1, 0);
			ct2 = new ColorTransform(1, 1.25, 2.5);
			m = new Matrix ();
			m.translate(0, -1);
			
			// make some noise pattern
			noise = new BitmapData(canvas.width, canvas.height);
			noise.perlinNoise(6, 6, 3, 7, false, false, 1|2|4, true);
		}
		
		protected function addEventListeners():void
		{
			if(this.stage)
			{
				addedToStage(null);
			} else 
			{
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}
			addEventListener(MouseEvent.MOUSE_MOVE, updateFireOnMove, false, 0, true);
			addEventListener(Event.ENTER_FRAME, updateFire, false, 0, true);
			this.addEventListener(TouchEvent.TOUCH_BEGIN, touchEventHandler);
			this.addEventListener(TouchEvent.TOUCH_END, touchEventHandler);
			this.addEventListener(TouchEvent.TOUCH_MOVE, touchEventHandler);
			addEventListener(TransformGestureEvent.GESTURE_ROTATE, transformGHandler);
			addEventListener(TransformGestureEvent.GESTURE_ZOOM, transformGHandler)
		}
		
		protected function touchEventHandler(event:TouchEvent):void
		{
			r.y = (r.y + 1) % noise.height;
			if(stage)
			{
				drawBlob(event.touchPointID, event.localX, event.localY);
			}
			// blur
			canvas.applyFilter(canvas, canvas.rect, p1, bf);
			canvas.draw(canvas, m, ct);
		}
		
		protected function transformGHandler(event:TransformGestureEvent ) : void
		{
			// go through noise pattern
			r.y = (r.y + 1) % noise.height;
			if(stage)
			{
				drawBlob(1, event.localX, event.localY);
			}
			// blur
			canvas.applyFilter(canvas, canvas.rect, p1, bf);
			canvas.draw(canvas, m, ct);
			
		}
		
		
		protected function addedToStage(e:Event) : void
		{
			this.stage.addEventListener(Event.RESIZE, stageResized, false, 0, true);
			stageResized(null);
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			//stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		protected function stageResized (e:Event ) :void
		{
			//stage.align = StageAlign.TOP_LEFT;
			//var wd:int = stage.stageWidth;
			//var ht:int = stage.stageHeight;
			canvasBitmap.width = stage.width;
			canvasBitmap.height = stage.height;
		}
		
		
		public function drawBlob(id:int, mx:Number, my:Number) : void
		{
			//var bx:Number, by:Number;
			p3.x = int(mx * canvasStarterSize / stage.stageWidth) - 4;
			p3.y = int(my * canvasStarterSize / stage.stageHeight) - 4;
			blobRect.left = p3.x;
			blobRect.top = p3.y;
			blobRect.right = p3.x+8;
			blobRect.bottom = p3.y+8;
			// add noise at the bottom
			var m2:Matrix = new Matrix();
			m2.translate(p3.x, p3.y);
			canvas.draw(noise, m2, ct2, BlendMode.ADD, blobRect);
		}
		
		protected function updateFire(e:Event) : void
		{
			// go through noise pattern
			r.y = (r.y + 1) % noise.height;
			// blur
			canvas.applyFilter(canvas, canvas.rect, p1, bf);
			canvas.draw(canvas, m, ct);
		}
		
		protected function updateFireOnMove(e:MouseEvent) : void
		{
			// go through noise pattern
			r.y = (r.y + 1) % noise.height;
			
			if(stage)
			{
				drawBlob(2, e.stageX, e.stageY);
			}
			// blur
			canvas.applyFilter(canvas, canvas.rect, p1, bf);
			canvas.draw(canvas, m, ct);
		}
		
		
		
		
		
		
		
		
	}
}