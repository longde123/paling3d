package org.paling3d.geom {
	import org.paling3d.math.Vector3D;

	public class Normal {
		public var x : Number;
		public var y : Number;
		public var z : Number;
		public var lum : Number;
		public var r : Number;
		public var g : Number;
		public var b : Number;
		//public var next : Normal;

		public function Normal( p : Vector3D ) {
			this.x = p.x;
			this.y = p.y;
			this.z = p.z;
		}
	}
}