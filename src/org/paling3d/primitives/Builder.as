package org.paling3d.primitives { 
	import org.paling3d.geom.Normal;
	import org.paling3d.geom.Point3D;
	import org.paling3d.geom.Triangle;
	import org.paling3d.geom.Vertex;
	import org.paling3d.materials.Material;
	import org.paling3d.geom.UV;
	import org.paling3d.math.Vector3D;

	public class Builder extends Geometry {
		private var avertexes : Vector.<Vertex>;
		private var hvertexes : Vector.<Array>;
		private var vpoints : Vector.<Point3D>;
		private var vnormals : Vector.<Normal>;
		private var vtcoords : Vector.<UV>;
		private var vzero : Vector3D;

		public function Builder(material : Material) {
 
			super(material);
		}

		
		override public function init( points : Vector.<Vector3D>, normals : Vector.<Vector3D>, tcoords : Vector.<UV> ) : void {
			if( tcoords == null ) {
				tcoords = new Vector.<UV>();
				tcoords[0] = new  UV(0, 0);
			}
			avertexes = new Vector.<Vertex>();
			hvertexes = new Vector.<Array>();
			for( var i : int = 0;i < tcoords.length;i++ )
				hvertexes[i] = new Array();
			vpoints = new Vector.<Point3D>();
			vnormals = new  Vector.<Normal>();
			vtcoords = new  Vector.<UV>();
			i = 0;
			for each(var p:Vector3D in points )
				vpoints[i++] = new Point3D(p);
			i = 0;
			for each(var n:Vector3D in normals )
				vnormals[i++] = new  Normal(n);
			vtcoords = tcoords;
			vzero = new Vector3D(0, 0, 0);
			points =null;
			normals = null;
			vertexes = null;
			triangles =new Vector.<Triangle>();
		}

		/**
		Creates and adds a new normal to the internal normals list.
		@param vIdx0 Vertex index
		@param vIdx1 Vertex index
		@param vIdx2 Vertex index
		@return New normal index
		 **/
		override public function createNormal( vIdx0 : int, vIdx1 : int, vIdx2 : int ) : int {
			var rv : int = vnormals.length;
			var n : Vector3D = new  Vector3D();
			var v0 : Point3D = vpoints[vIdx0];
			var v1 : Point3D = vpoints[vIdx1];
			var v2 : Point3D = vpoints[vIdx2];
			var d1x : Number = v1.x - v0.x;
			var d1y : Number = v1.y - v0.y;
			var d1z : Number = v1.z - v0.z;
			
			var d2x : Number = v2.x - v0.x;
			var d2y : Number = v2.y - v0.y;
			var d2z : Number = v2.z - v0.z;
			
			var pa : Number = d1y * d2z - d1z * d2y;
			var pb : Number = d1z * d2x - d1x * d2z;
			var pc : Number = d1x * d2y - d1y * d2x;
			
			var pdd : Number = Math.sqrt(pa * pa + pb * pb + pc * pc);
			
			n.x = pa / pdd;
			n.y = pb / pdd;
			n.z = pc / pdd;
			vnormals.push(new Normal(n));
			return rv;
		}

		public function makeVertex( v : int, n : int, t : int ) : int {
			 
			var vid : int = (v << 16) | n;
			var ht : Array = hvertexes[t];
			var idx : int = ht[vid];
			if( idx != 0 )
				return idx - 1;
			idx = avertexes.length;
			ht[vid] = idx + 1;
			var p : Point3D = vpoints[v];
			var _n : Normal ;
			if(n<vnormals.length)_n= vnormals[n];
			else _n=vnormals[createNormal(v,v+1,v+2)];
			
			var _t : UV = vtcoords[t];
			var _v : Vertex = new Vertex(p, _n, _t);
			avertexes[idx] = _v;
			return idx;
		}
		public function addTriangle3( v:Vector3D, n:Vector3D, t:UV) : void {
			
		}
		override public function addTriangle( v0 : int, v1 : int, v2 : int, n0 : int, n1 : int, n2 : int, t0 : int = 0, t1 : int = 0, t2 : int = 0 ) : void {
			var t : Triangle = new Triangle();
			var iv0 : int = makeVertex(v0, n0, t0);
			var iv1 : int = makeVertex(v1, n1, t1);
			var iv2 : int = makeVertex(v2, n2, t2);
			t.v0 = avertexes[iv0];
			t.v1 = avertexes[iv1];
			t.v2 = avertexes[iv2];
			
			
			t.iv0 = iv0;
			t.iv1 = iv1;
			t.iv2 = iv2;
			
			// calculate face-normal
			t.n = new  Normal(vzero);
			t.n.x = (t.v0.n.x + t.v1.n.x + t.v2.n.x) / 3;
			t.n.y = (t.v0.n.y + t.v1.n.y + t.v2.n.y) / 3;
			t.n.z = (t.v0.n.z + t.v1.n.z + t.v2.n.z) / 3;
			t.material = material;
			//t.next = triangles;
			//triangles = t;
			triangles.push(t);
		}

		public function addQuad( v0 : int, v1 : int, v2 : int, v3 : int, n0 : int, n1 : int, n2 : int, n3 : int, t0 : int = 0, t1 : int = 0, t2 : int = 0, t3 : int = 0 ) : void {
			addTriangle(v0, v1, v3, n0, n1, n3, t0, t1, t3);
			addTriangle(v1, v2, v3, n1, n2, n3, t1, t2, t3);
		}

		public function assignTo( p : Geometry ) : void {
			p.points = points;
			p.normals = normals;
			p.vertexes = vertexes;
			p.triangles = triangles;
			p.material = material;
			points = null;
			normals = null;
			vertexes = null;
			triangles =null;
			// keep material
		}

		override public function done() : void {
			var i : int;
			// build ordered points list
			i = vpoints.length;
		/*	while( i > 0 ) {
				var p : Point3D = vpoints[--i];
				p.next = points;
				points = p;
			}*/
			points=vpoints;
			// build ordered normal list
			i = vnormals.length;
			/*while( i > 0 ) {
				var n : Normal = vnormals[--i];
				n.next = normals;
				normals = n;
			}*/
			normals= vnormals;
			// build ordered vertex list
			i = avertexes.length;
			/*while( i > 0 ) {
				var v : Vertex = avertexes[--i];
				v.next = vertexes;
				vertexes = v;
			}*/
			vertexes= avertexes;
			// cleanup tmp datas
			
			
			tcoords=vtcoords;
			vzero = null;
			avertexes = null;
			hvertexes = null;
			vpoints = null;
			vnormals = null;
			vtcoords = null;
			super.done();
			ready=true;
		}
	}
}