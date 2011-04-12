package com.multitouchup.simConnect
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Stage;
	import flash.events.DatagramSocketDataEvent;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.DatagramSocket;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	
	[Bindable]
	public class SimConnection extends EventDispatcher
	{
		
		private static var instance : SimConnection;
		
		public var gestureTolerance:int = 1;
		
		public var datagramSocket:DatagramSocket;
		
		public var touchPoints:Array = new Array();
		
		public var isGestures:Boolean;
		
		protected var flashStage:Stage;
		
		protected var numberOfActiveTouchPoints:int;
		
		protected var doubleCheckTouchPoints:Array = new Array();
		
		protected var drawnTouchPoints:Array = new Array();
		
		protected var dCanvas:Canvas;
		
		
		//gestures
		
		protected var gestureArray:Array = new Array();
		
		protected var currentGestureType:String;
		
		
		
		/**
		 * Singelton class for connecting to SimTouch or other UDP touch emulators.
		 *
		 * @param       port
		 * @param       location
		 * @param       target
		 */
		public function SimConnection(stage:Stage, port:Number = 3333,
									  location:String = '127.0.0.1', 
									  debuggerCanvas:Canvas = null, 
									  gestures:Boolean = false, 
									  target:IEventDispatcher=null)
		{
			super(target);
			if ( instance != null )
			{
				throw new Error("SimConnect is a singleton class and can only have one instance." );
			}
			this.flashStage = stage;
			instance = this;
			addUDPListener(port, location);
			//Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			isGestures = gestures
			
			if(debuggerCanvas)
			{
				this.dCanvas = debuggerCanvas
			}
		}
		
		protected function addUDPListener(port:Number, location:String) : void
		{
			datagramSocket = new DatagramSocket();
			datagramSocket.addEventListener(DatagramSocketDataEvent.DATA, dataHandler)
			datagramSocket.bind(port, location);
			datagramSocket.receive();
		}
		
		protected function dataHandler(event: DatagramSocketDataEvent):void
		{
			var b:ByteArray = event.data;
			var tempArray:Array = [];
			numberOfActiveTouchPoints = 0;
			
			if(b.bytesAvailable > 20)
			{
				//aka 60
				numberOfActiveTouchPoints = 1;
				b.position = 48;
				var t:Object = new Object();
				t.id = b.readInt();
				t.x = b.readFloat()*flashStage.width
				t.y = b.readFloat()*flashStage.height
				if(touchPoints[t.id])
				{
					if((touchPoints[t.id].x > t.x+1 || touchPoints[t.id].x < t.x-1) || (touchPoints[t.id].y > t.y+1 || touchPoints[t.id].y < t.y-1))
					{
						gestureArray[t.id] = new Object();
						gestureArray[t.id].diffX = touchPoints[t.id].x - t.x;
						gestureArray[t.id].diffY = touchPoints[t.id].y - t.y;
						dispatchTouchMove(t);
					}
				}
				else
				{
					dispatchTouchDown(t);
				}
				//update
				tempArray.push(t.id);
				touchPoints[t.id] = t;
			}
			else
			{
				for each(var touchObject:Object in touchPoints)
				{
					dispatchTouchUp(touchObject);
				}
				touchPoints = [];
				numberOfActiveTouchPoints = 0;
			}
			while(b.bytesAvailable >= 44)
			{
				//aka 104
				numberOfActiveTouchPoints++;
				b.position += 32;
				var mt:Object = new Object();
				mt.id = b.readInt();
				mt.x = b.readFloat()*flashStage.width;
				mt.y = b.readFloat()*flashStage.height;
				if(touchPoints[mt.id])
				{
					if((touchPoints[mt.id].x > mt.x+1 || touchPoints[mt.id].x < mt.x-1) || (touchPoints[mt.id].y > mt.y+1 || touchPoints[mt.id].y < mt.y-1))
					{
						gestureArray[mt.id] = new Object();
						gestureArray[mt.id].diffX = touchPoints[mt.id].x - mt.x;
						gestureArray[mt.id].diffY = touchPoints[mt.id].y - mt.y;
						dispatchTouchMove(mt);
					}
				}
				else
				{
					dispatchTouchDown(mt);
				}
				tempArray.push(mt.id)
				touchPoints[mt.id] = mt;
			}
			for each(var touchO:Object in touchPoints)
			{
				if(touchO  && tempArray.indexOf(touchO) != -1)
				{
					dispatchTouchUp(touchO);
					delete touchPoints[touchO.id];
				}
			}
		}
		
		//
		//  Draw Touch Points
		//
		
		protected function addTouchObject(t:Object) : void
		{
			var ui:UIComponent = new UIComponent();
			var g:Graphics = ui.graphics;
			var m:Matrix = new Matrix();
			m.createGradientBox(20,20, 0, -10, -10)
			g.beginGradientFill(GradientType.RADIAL, [0x666666, 0xFFFFFF], [0.25,0.5], [0, 255], m, SpreadMethod.REFLECT);
			g.lineStyle(4, 0, 0.25)
			g.drawCircle(0,0, 20);
			ui.height = 20;
			ui.width = 20;
			drawnTouchPoints[t.id] = ui;
			
			dCanvas.addChild(ui);
			
			//(flashStage.getChildAt(flashStage.numChildren-1) as UIComponent).addChild(ui);
			ui.x = t.x;
			ui.y = t.y;
		}
		
		protected function updateTouchObject(t:Object):void
		{
			var i:int = dCanvas.getChildren().indexOf(drawnTouchPoints[t.id])
			dCanvas.getChildAt(i).x = t.x;
			dCanvas.getChildAt(i).y = t.y;
			//drawnTouchPoints[t.id].x = t.x;
			//drawnTouchPoints[t.id].y = t.y;
		}
		
		protected function removeTouchObject(t:Object):void
		{
			dCanvas.removeChild(drawnTouchPoints[t.id]);
			delete drawnTouchPoints[t.id];
		}
		
		//
		//  Dispatch touch events
		//
		
		
		protected function dispatchTouchUp(t:Object):void
		{
			if(dCanvas)
			{
				removeTouchObject(t);
			}
			
			
			var currentTarget:*= getTarget(new Point(t.x, t.y));
			if(currentTarget && currentTarget.hasEventListener(TouchEvent.TOUCH_END))
			{
				currentTarget.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_END,
					true, false, t.id, false, t.x, t.y));
			}
			
			if(!isGestures)
			{
				if(currentTarget)
				{	
					currentTarget.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_END,
						true, false, t.id, false, t.x, t.y));
				}
			}
		}
		
		
		protected function dispatchTouchDown(t:Object):void
		{
			if(dCanvas)
			{
				addTouchObject(t);
			}
			var currentTarget:*= getTarget(new Point(t.x, t.y));
			if(currentTarget && currentTarget.hasEventListener(TouchEvent.TOUCH_BEGIN))
			{
				currentTarget.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_BEGIN,
					true, false, t.id, false, t.x, t.y));
			}
				
			if(!isGestures)
			{
				currentTarget.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_BEGIN,
					true, false, t.id, false, t.x, t.y));
			}
		}
		
		protected function dispatchTouchMove(t:Object):void
		{
			var currentTarget:*= getTarget(new Point(t.x, t.y));
			if(currentTarget && currentTarget.hasEventListener(TouchEvent.TOUCH_MOVE))
			{
				currentTarget.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_MOVE,
					true, false, t.id, false, t.x, t.y, 0, 0, 0, null, false, false, false, false,false));
			}
			if(!isGestures)
			{
				currentTarget.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_MOVE,
					true, false, t.id, false, t.x, t.y, 0, 0, 0, null, false, false, false, false,false));
			}
			else
			{
				if(numberOfActiveTouchPoints > 1)
				{
					sendGestures(currentTarget, t);
				}
			}
			if(dCanvas)
			{
				updateTouchObject(t);
			}
		}
		
		
		//
		//  Gestures
		//
		
		protected function sendGestures(target:DisplayObject, touch:Object):void
		{
			for each (var otherTouch:Object in touchPoints)
			{
				if(otherTouch.id != touch)
				{
					// figure out where they are going.
					
					//old
					// may not be moving
					var otherOrginDiffX : Number = (gestureArray[otherTouch.id])? (gestureArray[otherTouch.id]).diffX : 0;
					var otherOrginDiffY : Number = (gestureArray[otherTouch.id])? (gestureArray[otherTouch.id]).diffY : 0;;
					
					//primary
					// we know it moved
					var priTouchOrginDiffX : Number = touch.x + gestureArray[touch.id].diffX;
					var priTouchOrginDiffY : Number = touch.y + gestureArray[touch.id].diffY;
					
					
					//SWIPE
					if((otherOrginDiffY < -1*gestureTolerance  && priTouchOrginDiffY < -1*gestureTolerance) ||  
						(otherOrginDiffY > gestureTolerance  && priTouchOrginDiffY > gestureTolerance)  ||
						(otherOrginDiffX > gestureTolerance  && priTouchOrginDiffX > gestureTolerance) || 
						(otherOrginDiffX < -1*gestureTolerance  && priTouchOrginDiffX < -1*gestureTolerance))
					{
						//swipe
						//trace("SWIPE");
						dispatchSwipe(touch, gestureArray[touch.id].diffX, gestureArray[touch.id].diffY);
						break;
						
					}
					/*else if((otherOrginDiffY >=0  && priTouchOrginDiffY < -1*gestureTolerance) ||  
					(otherOrginDiffY <=0  && priTouchOrginDiffY > gestureTolerance)  ||
					(otherOrginDiffX >=0  && priTouchOrginDiffX > gestureTolerance) || 
					(otherOrginDiffX <=0  && priTouchOrginDiffX < -1*gestureTolerance))
					{
					
					// x
					var orginDiffX:Number = makeNumberPositive(((otherTouch.x - otherOrginDiffX) - (touch.x - priTouchOrginDiffX)))
					var newDiffX:Number = makeNumberPositive((otherTouch.x - touch.x))
					var zoomX:Boolean;
					if(orginDiffX < newDiffX)
					{
					//zoom
					zoomX = true;
					}
					else if(orginDiffX > newDiffX)
					{
					//pinch
					zoomX = false;
					}
					
					//y
					var orginDiffY:Number = makeNumberPositive(((otherTouch.y - otherOrginDiffY) - (touch.y - priTouchOrginDiffY)))
					var newDiffY:Number = makeNumberPositive((otherTouch.y - touch.y))
					var zoomY:Boolean;
					if(orginDiffY < newDiffY)
					{
					//zoom
					zoomY = true;
					}
					else if(orginDiffY > newDiffY)
					{
					//pinch
					zoomY = false;
					}
					dispatchGestureZoom(otherTouch, (orginDiffX+newDiffX), (orginDiffY+newDiffY), zoomX, zoomY)
					}*/
				}
			}
		}
		
		//
		//  Dispatch gesture events
		//
		
		
		protected function dispatchSwipe(t:Object, offsetX:Number, offsetY:Number) : void
		{
			var currentTarget:DisplayObject = getTarget(new Point(t.x, t.y));
			if(!currentTarget)
			{
				return;
			}
			currentTarget.dispatchEvent(new TransformGestureEvent(TransformGestureEvent.GESTURE_SWIPE,
				true, false, null,t.x, t.y, currentTarget.scaleX, currentTarget.scaleY, currentTarget.rotation, offsetX, offsetY));
		}
		
		
		protected function dispatchGestureZoom(t:Object, xDiff:Number, yDiff:Number, zoomX:Boolean, zoomY:Boolean):void
		{
			var currentTarget:DisplayObject = getTarget(new Point(t.x, t.y));
			var scaleX:Number;
			var scaleY:Number;
			if(!currentTarget)
			{
				return;
			}
			
			if(zoomX)
			{
				scaleX = 1 + ( xDiff/currentTarget.width);
			}
			else
			{
				scaleX = 1 - ( xDiff/currentTarget.width)
			}
			if(zoomY)
			{
				scaleY = 1 + ( yDiff/currentTarget.width);
			}
			else
			{
				scaleY = 1 - ( yDiff/currentTarget.width);
			}
			trace('ScaleX : '+scaleX);
			trace('ScaleY : '+scaleY);
			trace('TouchID : '+t.id);
			
			currentTarget.dispatchEvent(new TransformGestureEvent(TransformGestureEvent.GESTURE_ZOOM,
				true, false, null,t.x, t.y, scaleX, scaleY));
		}
		
		
		
		//
		// helper functions
		//
		
		protected function makeNumberPositive(number:Number) : Number
		{
			var r:Number;
			(number < 0)? r = number*-1 : r = number;
			return r;
		}
		
		protected function getTarget(p:Point) : DisplayObject
		{
			var objectsUnder:Array = flashStage.getObjectsUnderPoint(p);
			
			if(objectsUnder.length == 0)
			{
				return null;
			}
			
			if(objectsUnder[objectsUnder.length - 1] == this.dCanvas && objectsUnder.length>1)
			{
				return objectsUnder[objectsUnder.length - 2] as DisplayObject
			}
			
			return objectsUnder[objectsUnder.length - 1] as DisplayObject;
		}
		
	}
}