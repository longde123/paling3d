package  org.paling3d.math
{
	import org.paling3d.geom.Point3D;
 
	
	public class BoundingSphere
	{
		//The non squared maximum vertex distance.
		public var maxDistance:Number;
		
		//The squared maximum vertex distance.
		public var radius:Number;
		
		/**
		 * @Author Ralph Hauwert
		 */
		public function BoundingSphere(maxDistance:Number)
		{
			this.maxDistance = maxDistance;
			this.radius = Math.sqrt(maxDistance);
		}
		
		public static function getFromVertices(vertices:Vector.<Point3D>):BoundingSphere
		{
			var max :Number = 0;
			var d   :Number;
			var v:Point3D;
			for each(v in vertices )
			{
				d = v.x*v.x + v.y*v.y + v.z*v.z;
				max = (d > max)? d : max;
			}
			return new BoundingSphere(max);
		}

	}
}