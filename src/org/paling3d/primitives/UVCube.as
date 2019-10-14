package org.paling3d.primitives {
	import org.paling3d.geom.UV;
	import org.paling3d.math.Vector3D;
	import org.paling3d.materials.Material;

	public class UVCube extends Geometry {

		static public var N : Number = 0.57735027;
		static public var vindexes : Array = [0, 3, 2, 1,   0, 4, 7, 3,   1, 5, 4, 0,    2, 6, 5, 1,   3, 7, 6, 2,   5, 6, 7, 4];
		static public var tindexes : Array = [3, 4, 1, 0,   3, 7, 8, 4,   2, 6, 7, 3,   13,11,10,12,   4, 8, 9, 5,  10,11, 8, 7];
		//                      TOP           REAR          LEFT          FRONT          RIGHT        BOTTOM

		public var width : Number;
		public var height : Number;
		public var length : Number;
		public var invertednormals : Boolean;

		public function UVCube(material : Material, width : Number, height : Number, length : Number, invertednormals : Boolean = false) {
			super(material);
				
			this.width = width;
			this.height = height != null ? height : width;
			this.length = length != null ? length : width;
			this.invertednormals = invertednormals;
				
			init();
		}

		public function init() : void {
			var x : Number = width / 2;
			var y : Number = height / 2;
			var z : Number = length / 2;
				
			var points : Vector.<Vector3D> = Vector.<Vector3D>(new Vector3D(-x, -y, z), new Vector3D(-x, y, z), new Vector3D(x, y, z), new Vector3D(x, -y, z), new Vector3D(-x, -y, -z), new Vector3D(-x, y, -z), new Vector3D(x, y, -z), new Vector3D(x, -y, -z));
				
			var n : Number = invertednormals ? -1 : 1;
			var normals : Vector.<Vector3D> = Vector.<Vector3D>(new Vector3D(0, 0, n), new Vector3D(0, -n, 0), new Vector3D(-n, 0, 0), new Vector3D(0, n, 0), new Vector3D(n, 0, 0), new Vector3D(0, 0, -n));
				
			var t1 : Number = 1 / 3;
			var t2 : Number = 2 / 3;
			var tcoords : Vector.<UV> = Vector.<UV>(new UV(t1, 0), new UV(t2, 0), new UV(0, 0.25), new UV(t1, 0.25), new UV(t2, 0.25), new UV(1, 0.25), new UV(0, 0.5), new UV(t1, 0.5), new UV(t2, 0.5), new UV(1, 0.5), new UV(t1, 0.75), new UV(t2, 0.75), new UV(t1, 1), new UV(t2, 1));
				
			var builder : Builder = new Builder(material);
			builder.init(points, normals, tcoords);
				
			var p : Number = 0;
			var n0 : Number = invertednormals ? 3 : 0;
			var n1 : Number = invertednormals ? 2 : 1;
			var n2 : Number = invertednormals ? 1 : 2;
			var n3 : Number = invertednormals ? 0 : 3;
			var indexn : int = 0;
			for(indexn = 0;indexn < 6;indexn++) 
			{
				builder.addQuad(vindexes[p + n0], vindexes[p + n1], vindexes[p + n2], vindexes[p + n3], indexn, indexn, indexn, indexn, tindexes[p + n0], tindexes[p + n1], tindexes[p + n2], tindexes[p + n3]);
				p += 4;
			}
			builder.done();
			builder.assignTo(this);
		}
	}
}