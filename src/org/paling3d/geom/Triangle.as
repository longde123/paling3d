package org.paling3d.geom {
	import org.paling3d.materials.Material;

	final public class Triangle {
		public var z : Number;
		public var v0 : Vertex;
		public var v1 : Vertex;
		public var v2 : Vertex;
		public var n : Normal;
		public var material : Material;
		
		
		public var iv0 : uint;
		public var iv1 : uint;
		public var iv2 : uint;
		
		//public var next : Triangle;

		public function Triangle() {
			
		}
	}
}