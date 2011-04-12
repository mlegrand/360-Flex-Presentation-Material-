package
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	
	public class MTColorPicker extends Canvas
	{
		public function MTColorPicker()
		{
			super();
			addEventList()
		}
		
		
		///
		//  prop
		//
		
		
		protected var colorArray:Array = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
		
		protected var colorDrop:UIComponent;
		
		protected var overlay:UIComponent;
		
		protected var alphas: Array = [1, 1, 1, 1, 1, 1, 1];
		
		protected var bitData:BitmapData;
		
		protected var ratios:Array = [0, 42, 84, 126, 168, 210, 255]
		
		protected var mag:MagGlass;
		
		[Bindable]
		public var selectedColor:uint = 0x000000;
		
		
		override protected function createChildren() : void
		{
			super.createChildren();
			
			colorDrop = new UIComponent();
			colorDrop.height = this.height;
			colorDrop.width = this.width;
			this.addChild(colorDrop);
			
			overlay = new UIComponent();
			overlay.height = this.height;
			overlay.width = this.width;
			this.addChild(overlay);
			
			mag = new MagGlass();
			mag.height = 20;
			mag.width = 20;
			this.addChild(mag);
			mag.visible = false;
			
		}
		
		override protected function updateDisplayList(w:Number, h:Number) : void
		{
			super.updateDisplayList(w, h);
			drawCoolGrad(w, h);
			drawOverlay(w, h);
		}
		
		
		protected function drawCoolGrad(w:Number, h:Number):void
		{
			var g:Graphics = colorDrop.graphics;
			g.clear();
			var mat:Matrix = new Matrix();
			var fill:String = GradientType.LINEAR;
			mat.createGradientBox(w, h, (Math.PI/180), 0, 0);
			g.beginGradientFill(fill, colorArray, alphas, ratios, mat, 'pad', 'rgb', 0);
			g.drawRect(0,0, w, h);
			g.endFill();
		}
		
		protected function drawOverlay(w:Number, h:Number):void
		{
			var g:Graphics = overlay.graphics;
			g.clear();
			var mat:Matrix = new Matrix();
			var fill:String = GradientType.LINEAR;
			mat.createGradientBox(w, h, -90*(Math.PI/180), 0, 0);
			g.beginGradientFill(fill, [0xFFFFFF, 0x666666, 0x000000], [1, 0, 1], [0, 255/2, 255], mat, 'pad', 'rgb', 0);
			g.drawRect(0,0, w, h);
			g.endFill();
		}
		
		
		protected function addEventList():void
		{
			addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBeginHandler);
			addEventListener(TouchEvent.TOUCH_MOVE, onTouchMoveHandler);
			addEventListener(TouchEvent.TOUCH_END, onTouchEndHandler);
		}
		
		
		
		
		/////
		//  Event Handlers
		////
		
		protected function onTouchBeginHandler(event:TouchEvent):void
		{
			if(event.localX > 0 && event.localY > 0)
			{
				bitData = new BitmapData(this.width, this.height);
				bitData.draw(this);
				if(colorDrop.hitTestPoint(event.stageX, event.stageY, true))
				{
					selectedColor = bitData.getPixel(event.localX, event.localY);
					trace(selectedColor);
				}
				
				mag.x = event.localX;
				mag.y = event.localY;
				mag.visible = true;
				mag.selectedColor = selectedColor;
			}
			
		}
		
		protected function onTouchMoveHandler(event:TouchEvent):void
		{
			if(event.localX > 0 && event.localY > 0)
			{
				/*bitData = new BitmapData(this.width, this.height);
				bitData.draw(this);*/
				if(colorDrop.hitTestPoint(event.stageX, event.stageY, true) && bitData)
				{
					selectedColor = bitData.getPixel(event.localX, event.localY);
					trace(selectedColor);
				}
				mag.x = event.localX;
				mag.y = event.localY;
				
				mag.selectedColor = selectedColor;
			}
		}
		
		protected function onTouchEndHandler(event:TouchEvent):void
		{
			mag.visible = false;
		}
		
		
		
	}
}