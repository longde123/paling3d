package org.paling3d.primitives { 
	import org.paling3d.geom.UV;
	import org.paling3d.math.Vector3D; 
	import org.paling3d.materials.Material;

	public class UVSphere extends Geometry {

		public var radius : Number;
		public var hradius : Number;
		public var slices : int;
		public var rings : int;
		public var invertednormals : Boolean;

		public function UVSphere(material : Material, radius : Number, hradius : Number, slices : int, rings : int, invertednormals = false) {
			super(material);
			this.radius = radius;
			this.hradius = hradius;
			this.slices = slices < 3 ? 3 : slices;
			this.rings = rings < 1 ? 1 : rings;
			this.invertednormals = invertednormals;
			init();
		}

		public function init() {
			var points : Vector.<Vector3D> = new  Vector.<Vector3D>();
			var normals : Vector.<Vector3D> = new  Vector.<Vector3D>();
			var vindexes : Vector = new  Vector();
			var tcoords : Vector.<UV> = new  Vector.<UV>();
			var n = invertednormals ? -1 : 1;
			
			var unitw : Number = 1 / slices;
			var unith : Number = 1 / (1 + rings);
			
			var tlevels : Vector = new  Vector(rings, true);
			var levels : Vector = new  Vector(rings, true);
			var angle : Number = 2 * Math.PI / slices;
			var alpha : Number = Math.PI / (rings + 1);
			for(var ring : int = 0;ring < rings;ring++) {
				var level : Vector = levels[ring] = new  Vector(slices, true);
				var tlevel : Vector = tlevels[ring] = new  Vector(slices + 1, true);
				
				var a : Number = alpha * (ring + 1);
				var z : Number = -Math.cos(a);
				var r : Number = Math.sin(a) * radius;
				
				for(var slice : int = 0;slice < slices;slice++) {
					var x = Math.cos(angle * slice);
					var y = Math.sin(angle * slice);
					normals.push(new Vector3D(x * n, y * n, z * n));
					points.push(new Vector3D(x * r, y * r, z * hradius));
					level[slice] = points.length - 1;
					tcoords.push(new UV(unitw * slice, 1 - ring * unith));
					tlevel[slice] = tcoords.length - 1;
				}
				tcoords.push(new UV(1, 1 - ring * unith));
				tlevel[slices] = tcoords.length - 1;
			}
			
			// top
			normals.push(new Vector3D(0, 0, n));
			points.push(new Vector3D(0, 0, hradius));
			var topvertex : int = points.length - 1;
			var tleveltop : Vector = new Vector(slices, true);
			for(var slice : int = 0;slice < slices;slice++) {
				tcoords.push(new UV(unitw * slice + unitw / 2, 0));
				tleveltop[slice] = tcoords.length - 1;
			}
			
			// bottom
			normals.push(new Vector3D(0, 0, -n));
			points.push(new Vector3D(0, 0, -hradius));
			var bottomvertex : int = points.length - 1;
			var tlevelbottom : Vector = new Vector(slices, true);
			for(var slice : int = 0;slice < slices;slice++) {
				tcoords.push(new UV(unitw * slice + unitw / 2, 1));
				tlevelbottom[slice] = tcoords.length - 1;
			}
			
			var tindexes : Vector = new   Vector();
			var builder : Builder = new Builder(material);
			builder.init(points, normals, tcoords);
			
			var n1 : int = invertednormals ? 1 : 0;
			var n2 : int = invertednormals ? 0 : 1;
			var level : int = levels[0];
			for(var i : int = 0;i < slices;i++) {
				var index1 : int = i + n1 == slices ? 0 : i + n1;
				var index2 : int = i + n2 == slices ? 0 : i + n2;
				builder.addTriangle(bottomvertex, level[index2], level[index1], bottomvertex, level[index2], level[index1], tlevelbottom[i], tlevels[0][i], tlevels[0][i + 1]);
			}
			
			for(var i : int = 0;i < levels.length - 1;i++) {
				var levelbottom : int = levels[i];
				var leveltop : int = levels[i + 1];
				var tlevelbottom : int = tlevels[i];
				var tleveltop : int = tlevels[i + 1];
				for(var j : int = 0;j < slices;j++) {
					var index1 : int = j + n1 == slices ? 0 : j + n1;
					var index2 : int = j + n2 == slices ? 0 : j + n2;
					builder.addQuad(leveltop[index1], levelbottom[index1], levelbottom[index2], leveltop[index2], leveltop[index1], levelbottom[index1], levelbottom[index2], leveltop[index2], tleveltop[j + n1], tlevelbottom[j + n1], tlevelbottom[j + n2], tleveltop[j + n2]);
				}
			}
			
			level = levels[levels.length - 1];
			for(var i : int = 0;i < slices;i++) {
				var index1 : int = i + n1 == slices ? 0 : i + n1;
				var index2 : int = i + n2 == slices ? 0 : i + n2;
				builder.addTriangle(topvertex, level[index1], level[index2], topvertex, level[index1], level[index2], tleveltop[i], tlevels[tlevels.length - 1][i + 1], tlevels[tlevels.length - 1][i]);
			}
			builder.done();
			builder.assignTo(this);
		}
	}
}