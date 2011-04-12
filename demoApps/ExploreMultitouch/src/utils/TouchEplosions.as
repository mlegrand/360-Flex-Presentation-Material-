package utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import mx.core.UIComponent;
	import mx.geom.RoundedRectangle;
	
	public class TouchEplosions extends UIComponent
	{
		
		private var particleMaxSpeed:Number = 5;
		private var particleFadeSpeed:Number = 5;
		private var particleTotal:Number = 20;
		private var particleRange:Number = 100;
		
		//public
		[Bindable]
		public var blurFilter:Boolean;
		[Bindable]
		public var alphaFade:Boolean;

		
		public function TouchEplosions()
		{
			super();
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			addEventListener(TouchEvent.TOUCH_BEGIN, touchEvent_touchBeginHandler);
			addEventListener(MouseEvent.CLICK, mouseClickHandler);
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			this.graphics.clear();
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0,0, w, h);
			this.graphics.endFill();
		}
		
		protected function mouseClickHandler(event:MouseEvent):void
		{
			createExplosion(event.localX, event.localY);
		}
		
		protected function touchEvent_touchBeginHandler(event:TouchEvent):void
		{
			createExplosion(event.localX, event.localY);
		}
		
		protected function getBitmapFilter():BitmapFilter 
		{
			var blurX:Number = 5;
			var blurY:Number = 5;
			return new BlurFilter(blurX,blurY,BitmapFilterQuality.HIGH);
		}
		
		protected function createExplosion(localX:Number, localY:Number):void
		{
			if(localX == 0 || localY == 0)
			{
				return;
			}
			for (var i:Number = 0; i < particleTotal; i++) 
			{
				var myBmp:MovieClip = new MovieClip();
				var randomColor:int = getRandomColor();
				var bmd:BitmapData = new BitmapData(80, 80, false, randomColor);
				var rect:RoundedRectangle = new RoundedRectangle(0, 0, 80, 80, 20);
				bmd.fillRect(rect, randomColor);
				var bm:Bitmap = new Bitmap(bmd);
				myBmp.addChild(bm);
				var particle_mc:MovieClip = new MovieClip();
				addChild(particle_mc);
				if(blurFilter)
				{	
					var filter:BitmapFilter = getBitmapFilter();
					var myFilters:Array = new Array();
					myFilters.push(filter);
					particle_mc.filters = myFilters;
				}
				particle_mc.x = -myBmp.width/2;
				particle_mc.y = -myBmp.height/2;
				
				particle_mc.addChild(myBmp);
				particle_mc.x = localX;
				particle_mc.y = localY;
				particle_mc.rotation = Math.random()*360;
				if(alphaFade)
				{
					particle_mc.alpha = Math.random()*1;
				}
				particle_mc.speedX = Math.random()*particleMaxSpeed-Math.random()*particleMaxSpeed;
				particle_mc.speedY = Math.random()*particleMaxSpeed-Math.random()*particleMaxSpeed;
				particle_mc.speedX *= particleMaxSpeed;
				particle_mc.speedY *= particleMaxSpeed;
				particle_mc.addEventListener(Event.ENTER_FRAME, moveFragment);
			}
		}	
		
		protected function getRandomColor():uint
		{
			return Math.random()*0xFFFFFF;
		}
		
		protected function moveFragment(e:Event):void 
		{
			if(alphaFade)
			{
			e.target.alpha -= .05;
			}
			e.target.x += e.target.speedX;
			e.target.y += e.target.speedY;
			e.target.scaleX -= .1;
			e.target.scaleY -= .1;
			
			if (e.target.scaleX <= 0) 
			{
				e.target.removeEventListener(Event.ENTER_FRAME, moveFragment);
				removeChild(e.target as DisplayObject);
			}
		}
	}
}