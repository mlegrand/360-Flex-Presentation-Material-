package xd.geometry
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class MatrixHelper
	{
		public static function location(d:DisplayObject):Point
		 {
			return new Point(d.x, d.y);
		}
		
		
		private static function tp(o:Object):Point { return new Point(o.x, o.y);}
		
		public static function deltaMatrixArray(a:Array):Matrix {
			if(a[1] && a[3])
				return deltaMatrix(tp(a[0]), tp(a[1]), tp(a[2]), tp(a[3]));
			else 
				return slideMatrix(tp(a[0]), tp(a[2]));
		}

		public static function slideMatrix(p1:Point, p2:Point):Matrix {
			var d:Point = p2.subtract(p1);
			return new Matrix(1,0,0,1,d.x, d.y);
		}
		
		public static function matrixFromBaseLine(p1:Point, p2:Point, scale:Number = 0):Matrix {
			var delta:Point = p2.subtract(p1);
			var len:Number = delta.length;
			if(len == 0) return null;
			if(scale)
				delta.normalize(len * scale);
			return new Matrix(delta.x, delta.y, -delta.y, delta.x, p1.x, p1.y);
		}
		
		private static function deltaMatrix(a1:Point, b1:Point, a2:Point, b2:Point):Matrix {
			var m1:Matrix = MatrixHelper.matrixFromBaseLine(a1,b1);
			var m2:Matrix = MatrixHelper.matrixFromBaseLine(a2,b2);
			if((!m1) || (!m2)) return null;
			m1.invert();
			m1.concat(m2);
			return m1;
		}
	}
}