package utils
{
	import mx.core.UIComponent;
	
	public class MagGlass extends UIComponent
	{
		
		private var _selectedColor:uint = 0x000000;
		public function get selectedColor():uint
		{
			return _selectedColor;
		}

		public function set selectedColor(value:uint):void
		{
			_selectedColor = value;
			invalidateDisplayList();
		}
		
		
		public function MagGlass()
		{
			super();
		}
		
		
		override protected function updateDisplayList(w:Number, h:Number) : void
		{
			super.updateDisplayList(w, h);
			graphics.clear();
			graphics.beginFill(selectedColor);
			graphics.lineStyle(2, 0xFFFFFF, 0.75);
			graphics.drawCircle(-10, -10, w);
			graphics.endFill();
		}
		


	}
}