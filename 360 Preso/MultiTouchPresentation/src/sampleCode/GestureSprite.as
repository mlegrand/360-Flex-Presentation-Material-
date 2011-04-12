package sampleCode
{
	import flash.display.Sprite;
	
	
	import spark.components.Image;
	
	public class GestureSprite extends Image
	{
		public function GestureSprite()
		{
			super();
			var r:RotatableScalable = new RotatableScalable(this);
		}
	}
}