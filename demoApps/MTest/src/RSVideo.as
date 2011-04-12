package
{
	import com.mlegrand.RotatableScalable;
	
	import mx.controls.VideoDisplay;
	
	public class RSVideo extends VideoDisplay
	{
		public function RSVideo()
		{
			super();
			var rs:RotatableScalable = new RotatableScalable(this);
		}
	}
}