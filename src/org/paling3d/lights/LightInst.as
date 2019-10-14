package org.paling3d.lights {
	import org.paling3d.math.Vector3D;

	public class LightInst {
		public var l : Light;
		public var pos : Vector3D;
		public var lx : Number;
		public var ly : Number;
		public var lz : Number;
		public var r : Number;
		public var g : Number;
		public var b : Number;

		public function LightInst( l : Light) {
			this.l = l;
			pos = new Vector3D();
		}
	}
}