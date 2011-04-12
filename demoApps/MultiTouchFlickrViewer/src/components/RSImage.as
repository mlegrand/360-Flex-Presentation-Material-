package components
{
	import mx.controls.Image;
	
	public class RSImage extends Image
	{
		public function RSImage()
		{
			super();
			var rs:RotatableScalable = new RotatableScalable(this);
		}
	}
}