package org.paling3d.geom {
	import org.paling3d.Paling3D;

	public class Stats {
		public var objects : int;
		public var primitives : int;
		public var triangles : int;
		public var drawCalls : int;
		public var shapeCount : int;

		public var transformTime : Number;
		public var sortTime : Number;
		public var materialTime : Number;
		public var drawTime : Number;
		public var timeLag : Number; 
		public function Stats() {
			timeLag = 0.95;
			transformTime = 0;
			materialTime = 0;
			sortTime = 0;
			drawTime = 0;
		}

		public function toString() : String {
			var data : Object = {
				objects : objects, primitives : primitives, triangles : triangles, drawCalls : drawCalls, shapeCount : shapeCount, transform :  Paling3D.f(transformTime), sort :  Paling3D.f(sortTime), material : Paling3D.f(materialTime), draw :  Paling3D.f(drawTime)
			};
			return "STATS = " + String(data);
		}
	}
}