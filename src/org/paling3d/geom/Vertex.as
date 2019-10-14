package org.paling3d.geom {
 
	final public class Vertex {
		// datas
		public var p : Point3D;
		public var n : Normal;
		public var u : Number;
		public var v : Number;
		public var cr : Number;
		public var cg : Number;
		public var cb : Number;
		// light
		public var lum : Number;
		public var r : Number;
		public var g : Number;
		public var b : Number;
	//	public var next : Vertex;

		public function Vertex( p : Point3D, n : Normal, t : UV ) {
			this.p = p;
			this.n = n;
			this.u = t.u;
			this.v = t.v;
			this.cr = 0.0;
			this.cg = 0.0;
			this.cb = 0.0;
		}
		
		public function clone():Vertex
		{
			return null;
		}
	}
}