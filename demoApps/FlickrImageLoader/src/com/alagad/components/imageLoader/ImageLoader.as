package com.alagad.components.imageLoader
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	public class ImageLoader extends Image
	{
		
		//public var source:String = "";
		
		protected var _lineColor:uint = 0xFFFFFF;
		
		protected var line:UIComponent = new UIComponent();
		
		protected var textLabel:Label
		
		public function ImageLoader()
		{
			super();
			addEventListeners();
			addLine();
			textLabel = new Label();
		}
		
		override protected function createChildren() : void
		{
			super.createChildren();
			this.addChild(textLabel)
			textLabel.setStyle('textSize', 250);	
			textLabel.y = 0;
			textLabel.x = 0;
			textLabel.text = 'SERIOUSLY';
		}
		
		protected function addLine():void
		{
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			g.beginFill(_lineColor);
			g.drawRect(0,0,this.height, 10)
			line.addChild(s);
			//this.addChild(line);
		}
		
		protected function addEventListeners():void
		{
			//this.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		
		protected function progressHandler(event:ProgressEvent):void
		{
			//textLabel.text =  Math.ceil((bytesLoaded/bytesTotal) *100).toString() + ' %';
		}
		
	}
}