package away3d.entities {
	import away3d.materials.WireframeMaterial;

	import flash.geom.Vector3D;

	/**
	 * @author jerome BIREMBAUT  Twitter: Seraf_NSS
	 */
	public class WireFrameGrid extends Lines {
		public function WireFrameGrid(material : WireframeMaterial = null, ceil:uint=10,size:uint=1000) {
			super(material);

			var ceilSize:uint = size/ceil;
			for ( var i:int = -ceil; i <= ceil; i++ )
			{

				addLine( new Vector3D( size, 0, i*ceilSize ), new Vector3D( -size, 0, i*ceilSize ), .3 );

				addLine(  new Vector3D( i*ceilSize, 0, size ), new Vector3D( i*ceilSize, 0, -size ), .3 );
				
			}
			
			
			
		}
	}
}
