package
{
	import com.mlegrand.RotatableScalable;
	
	import mx.controls.DataGrid;
	
	public class RSDataGrid extends DataGrid
	{
		public function RSDataGrid()
		{
			super();
			var rs:RotatableScalable = new RotatableScalable(this);
		}
	}
}