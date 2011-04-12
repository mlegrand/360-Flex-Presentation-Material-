package com.mlegrand
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	///////////////////////////////////////////////////////////////////////////////////////
	//
	//  Original class can be found at :
	//  http://touchlib.googlecode.com/svn/trunk/AS3/int/app/core/action/RotatableScalable.as
	//
	//////////////////////////////////////////////////////////////////////////////////////
	
	public class RotatableScalable
	{
		//States
		protected static const NONE:String = 'none';
		protected static const DRAGGING:String = 'dragging';
		protected static const ROTATE_SCALE:String = 'rotateScale';
		
		// 
		protected static const GRAD_PI:Number = 180/3.14159;
		protected static const HALF:Number = 0.5;
		
		
		protected var displayO:DisplayObject;
		
		protected var blobs : Array = [];
		protected var blob1 : Object;
		protected var blob2 : Object;
		protected var pointMap : Object = {};
		
		protected var state:String;
		protected var curScale:Number;
		protected var curAngle:Number;
		protected var curPosition:Point = new Point(0,0);
		
		protected var point1:Object;
		protected var point2:Object;
		
		protected var dX:Number;
		protected var dY:Number;
		protected var dAng:Number;
		
		protected var _rp:Point = new Point();
		
		//
		// Properties
		//
		public var draggable:Boolean;
		
		public function RotatableScalable(displayObject:DisplayObject)
		{
			displayO = displayObject;
			addGestureEventListeners();
			//addTouchEventListeners();
		}
		
		//
		//  Event Listeners
		//
		
		protected function addGestureEventListeners():void
		{
			displayO.addEventListener(TransformGestureEvent.GESTURE_ROTATE,
				onGestureRotate);
			displayO.addEventListener(TransformGestureEvent.GESTURE_ZOOM,
				onGesturePinch);
		}
		
		//
		//  Gesture Event Handlers
		//
		
		private function onGesturePinch(pinchEvent:TransformGestureEvent):void{
			
			pinchEvent.stopImmediatePropagation()
			var pinchMatrix:Matrix = displayO.transform.matrix;
			var pinchPoint:Point =
				pinchMatrix.transformPoint(
					new Point((displayO.width/2), (displayO.height/2)));
			pinchMatrix.translate(-pinchPoint.x, -pinchPoint.y);
			pinchMatrix.scale(pinchEvent.scaleX, pinchEvent.scaleY);
			pinchMatrix.translate(pinchPoint.x, pinchPoint.y);
			displayO.transform.matrix = pinchMatrix;
		}
		
		private function onGestureRotate(rotateEvent:TransformGestureEvent):void
		{
			rotateEvent.stopImmediatePropagation()
			var rotateMatrix:Matrix = displayO.transform.matrix;
			var rotatePoint:Point =
				rotateMatrix.transformPoint(
					new Point((displayO.width/2), (displayO.height/2)));
			rotateMatrix.translate(-rotatePoint.x, -rotatePoint.y);
			rotateMatrix.rotate(rotateEvent.rotation*(Math.PI/180));
			rotateMatrix.translate(rotatePoint.x, rotatePoint.y);
			displayO.transform.matrix = rotateMatrix ;
		}
		
		
		protected function addTouchEventListeners():void
		{
			displayO.addEventListener( TouchEvent.TOUCH_BEGIN, onTouchBegin );
			displayO.addEventListener( TouchEvent.TOUCH_END, onTouchEnd );
			displayO.addEventListener( TouchEvent.TOUCH_MOVE, onTouchMove );
			displayO.addEventListener( Event.ENTER_FRAME, update );
		}
		
		//
		//  Touch Event Handlers
		//
		
		private function onTouchBegin( event : TouchEvent ) : void
		{
			var p:Point; 
			if(event.stageX == 0 && event.stageY == 0)
			{
				return;
				p = new Point(event.localX, event.localY);
			}
			else
			{
				p = new Point(event.stageX, event.stageY);
			}
			event.stopImmediatePropagation();
			pointMap[ event.touchPointID.toString() ] = p;
			addBlob( event.touchPointID, p.x, p.y );
		}
		
		private function onTouchEnd( event : TouchEvent ) : void
		{
			event.stopImmediatePropagation()
			removeBlob( event.touchPointID );
			delete pointMap[ event.touchPointID.toString() ];
		}
		
		private function onTouchMove( event : TouchEvent ) : void
		{
			event.stopImmediatePropagation()
			var p:Point; 
			if(event.stageX == 0 && event.stageY == 0)
			{
				p = new Point(event.localX, event.localY);
			}
			else
			{
				p = new Point(event.stageX, event.stageY);
			}

			if ( pointMap[ event.touchPointID.toString() ] )
			{
				pointMap[ event.touchPointID.toString() ].x = p.x;
				pointMap[ event.touchPointID.toString() ].y = p.y;
			}
			update(null)
		}
		
		
		
		
		
		private function addBlob(id:Number, origX:Number, origY:Number):void
		{
			for(var i:int=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return;
			}
			
			blobs.push( {id: id, origX: origX, origY: origY, myOrigX: displayO.x, myOrigY:displayO.y} );
			
			if(blobs.length == 1)
			{                
				state = DRAGGING;
				curScale = displayO.scaleX;
				curAngle = displayO.rotation;                    
				curPosition.x = displayO.x;
				curPosition.y = displayO.y;                
				blob1 = blobs[0];
			} 
			else if(blobs.length == 2)
			{
				state = ROTATE_SCALE;
				curScale = displayO.scaleX;
				curAngle = displayO.rotation;                    
				curPosition.x = displayO.x;
				curPosition.y = displayO.y;        
				
				blob1 = blobs[0];                                
				blob2 = blobs[1];        
				
				var tuioobj1 : Object = pointMap[ blob1.id ];
				var tuioobj2 : Object = pointMap[ blob2.id ];
				
				var midPoint:Point = Point.interpolate(displayO.globalToLocal(new Point(tuioobj1.x, tuioobj1.y)),displayO.globalToLocal(new Point(tuioobj2.x, tuioobj2.y)),0.5);
				
				setRegistration(midPoint.x,midPoint.y);
				
				// if not found, then it must have died..
				if(tuioobj1)
				{
					var curPt1:Point = displayO.parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));                                    
					blob1.origX = curPt1.x;
					blob1.origY = curPt1.y;
				}                
				
			}
			
		}
		
		private function removeBlob(id:Number):void
		{
			for(var i:int=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id) 
				{
					blobs.splice(i, 1);
					
					if(blobs.length == 0)
						state = NONE;
					if(blobs.length == 1) 
					{
						state = DRAGGING;                    
						
						curScale = displayO.scaleX;
						curAngle = displayO.rotation;                    
						curPosition.x = displayO.x;
						curPosition.y = displayO.y;                    
						
						blob1 = blobs[0];        
						
						var tuioobj1 : Object = pointMap[ blob1.id ];
						
						if(tuioobj1)
						{                        
							var curPt1:Point = displayO.parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));
							
							blob1.origX = curPt1.x;
							blob1.origY = curPt1.y;
						}
						
					}
					if(blobs.length >= 2) {
						state = ROTATE_SCALE;
						
						curScale = displayO.scaleX;
						curAngle = displayO.rotation;                    
						curPosition.x = displayO.x;
						curPosition.y = displayO.y;                
						
						blob1 = blobs[0];                                
						blob2 = blobs[1];        
						
						tuioobj1 = pointMap[ blob1.id ];
						
						if(tuioobj1)
						{
							curPt1 = displayO.parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));                        
							blob1.origX = curPt1.x;
							blob1.origY = curPt1.y;
						}                                    
					}
					return;                    
				}
			}            
		}
		
		
		
		private function getAngleTrig(X:Number, Y:Number): Number
		{
			if (X == 0.0)
			{
				if(Y < 0.0)
					return 270;
				else
					return 90;
			} else if (Y == 0)
			{
				if(X < 0)
					return 180;
				else
					return 0;
			}
			
			if ( Y > 0.0)
				if (X > 0.0)
					return Math.atan(Y/X) * GRAD_PI;
				else
					return 180.0-Math.atan(Y/-X) * GRAD_PI;
				else
					if (X > 0.0)
						return 360.0-Math.atan(-Y/X) * GRAD_PI;
					else
						return 180.0+Math.atan(-Y/-X) * GRAD_PI;
		}         
		
		
		
		
		private function update(e:Event):void
		{
			
			if(state == DRAGGING)
			{
				var tuioobj:Object = pointMap[ blob1.id ];
				
				if(!tuioobj)
				{
					removeBlob(blob1.id);
					return;
				}
				
				var curPt:Point = displayO.parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));  
				
				var oldX:Number, oldY:Number;
				oldX = displayO.x;
				oldY = displayO.y;
				
				displayO.x = (curPosition.x + (curPt.x - (blob1.origX )) > 0)? curPosition.x + (curPt.x - (blob1.origX ))  : 0 ;        
				displayO.y = (curPosition.y + (curPt.y - (blob1.origY )) > 0)? curPosition.y + (curPt.y - (blob1.origY ))  : 0;
				
				dX *= HALF;
				dY *= HALF;                        
				dAng *= HALF;
				dX += displayO.x - oldX;
				dY += displayO.y - oldY;        
				
			} 
			else if(state == ROTATE_SCALE)
			{
				
				var tuioobj1 : Object = pointMap[ blob1.id ];
				
				if(!tuioobj1)
				{
					removeBlob(blob1.id);
					return;
				}                
				
				var curPt1:Point = displayO.parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));                                
				
				var tuioobj2 : Object = pointMap[ blob2.id ];
				// if not found, then it must have died..
				if(!tuioobj2)
				{
					removeBlob(blob2.id);
					return;
				}                                
				
				var curPt2:Point = displayO.parent.globalToLocal(new Point(tuioobj2.x, tuioobj2.y));                
				var curCenter:Point = Point.interpolate(curPt1, curPt2, 0.5);    
				
				var origPt1:Point = new Point(blob1.origX, blob1.origY);
				var origPt2:Point = new Point(blob2.origX, blob2.origY);
				var centerOrig:Point = Point.interpolate(origPt1, origPt2, 0.5);
				var offs:Point = curCenter.subtract(centerOrig);
				
				var len1:Number = Point.distance(origPt1, origPt2);
				var len2:Number = Point.distance(curPt1, curPt2);                    
				var len3:Number = Point.distance(origPt1, new Point(0,0));
				
				var newscale:Number = curScale * len2 / len1;
				
				if(newscale<4)
				{
					
					setProperty2('scaleX', newscale);
					setProperty2('scaleY', newscale);
				}
				var origLine:Point = origPt1;
				origLine = origLine.subtract(origPt2);
				
				var ang1:Number = getAngleTrig(origLine.x, origLine.y);
				
				var curLine:Point = curPt1;
				curLine = curLine.subtract(curPt2);
				
				var ang2:int = getAngleTrig(curLine.x, curLine.y);
				var oldAngle:int = displayO.rotation;
				
				setProperty2("rotation", curAngle + (ang2 - ang1));    
				
				oldX = displayO.x;
				oldY = displayO.y;
				
				dX *= HALF;
				dY *= HALF;        
				dAng *= HALF;                
				
				dX += displayO.x - oldX;
				dY += displayO.y - oldY;
				
				dAng += displayO.rotation - oldAngle;
				
				
				
				
			} else {
				if(dX != 0 || dY != 0)
				{
					//this.released(dX, dY, dAng);
					dX = 0;
					dY = 0;
					dAng = 0;
				}
			}
			
		}    
		
		
		
		public function setRegistration(x:Number=0, y:Number=0):void{
			_rp = new Point(x, y);
		}
		
		public function setProperty2(prop:String, n:Number):void{
			var a:Point = new Point();
			var b:Point = new Point();
			if(displayO.parent != null){
				a = displayO.parent.globalToLocal(displayO.localToGlobal(_rp));
				displayO[prop] = n;
				b = displayO.parent.globalToLocal(displayO.localToGlobal(_rp));
			}else{
				a = displayO.localToGlobal(_rp);
				displayO[prop] = n;
				b = displayO.localToGlobal(_rp);
			}
			displayO.x -= b.x - a.x;
			displayO.y -= b.y - a.y;
		}
	}
}