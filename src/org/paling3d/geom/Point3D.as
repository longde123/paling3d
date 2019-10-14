package org.paling3d.geom {
	import org.paling3d.math.Vector3D;

	final public class Point3D {

		public var x : Number;
		public var y : Number;
		public var z : Number;
		public var sx : Number;
		public var sy : Number;
		public var w : Number;
		//public var next : Point3D;

		public function Point3D(p : Vector3D ) {
			this.x = p.x;
			this.y = p.y;
			this.z = p.z;
		}
	}
}