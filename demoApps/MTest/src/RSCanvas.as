package
{
	import com.mlegrand.RotatableScalable;
	
	import mx.containers.Canvas;
	
	public class RSCanvas extends Canvas
	{
		public function RSCanvas()
		{
			super();
			var rs:RotatableScalable = new RotatableScalable(this);
		}
	}
}