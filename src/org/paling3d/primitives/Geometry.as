package org.paling3d.primitives { 
	 
	import org.paling3d.geom.*;
	import org.paling3d.geom.UV;
	import org.paling3d.materials.BitmapMaterial;
	import org.paling3d.materials.Material;
	import org.paling3d.math.AxisAlignedBoundingBox;
	import org.paling3d.math.BoundingSphere;
	import org.paling3d.math.Matrix4x4;
	import org.paling3d.math.Vector3D; 
	public class Geometry {
	
		
		protected var _boundingSphere:BoundingSphere;
		protected var _boundingSphereDirty :Boolean = true;
		protected var _aabb:AxisAlignedBoundingBox;
		protected var _aabbDirty:Boolean = true;
		
		public var ready:Boolean=false;
		public var points : Vector.<Point3D>;//array
		public var normals : Vector.<Normal>;//array
		public var tcoords : Vector.<UV>;
		
		public var vertexes : Vector.<Vertex>; //array
		public var triangles : Vector.<Triangle>;//array
		public var material : Material;
  
		
		public function done() : void {
			
			
			
		}
		
		  
		/**
		 * Radius square of the mesh bounding sphere
		 */
		public function get boundingSphere():BoundingSphere
		{
			if( _boundingSphereDirty ){
				_boundingSphere = BoundingSphere.getFromVertices(points);
				_boundingSphereDirty = false;
			}
			return _boundingSphere;
		}
		
		/**
		 * Returns an axis aligned bounding box, not world oriented.
		 * 
		 * @Author Ralph Hauwert - Added as an initial test.
		 */
		public function get aabb():AxisAlignedBoundingBox
		{
			if(_aabbDirty){
				_aabb = AxisAlignedBoundingBox.createFromVertices(points);
				_aabbDirty = false;
			}
			return _aabb;
		}
		
		public function createNormal( vIdx0 : int, vIdx1 : int, vIdx2 : int ) : int {
			return -1;
		}
		public function addTriangle( v0 : int, v1 : int, v2 : int, n0 : int, n1 : int, n2 : int, t0 : int = 0, t1 : int = 0, t2 : int = 0 ) : void {
			
		}
		public function init( points : Vector.<Vector3D>, normals : Vector.<Vector3D>, tcoords : Vector.<UV> ) : void {
			
		}
		
		public function clone(parent:Geometry = null):Geometry
		{
			return null;
		}
		public function transformVertices(transformation:Matrix4x4 ):void
		{
			 
				var m11 :Number = transformation._11,
				m12 :Number = transformation._12,
				m13 :Number = transformation._13,
				m21 :Number = transformation._21,
				m22 :Number = transformation._22,
				m23 :Number = transformation._23,
				m31 :Number = transformation._31,
				m32 :Number = transformation._32,
				m33 :Number = transformation._33,
				
				m14 :Number = transformation._14,
				m24 :Number = transformation._24,
				m34 :Number = transformation._34,
				
				i        :int    = points.length,
				
				vertex   :Point3D;
			
			
				while(i>0)
				{
					vertex = points[--i]; 
					// Center position
					var vx :Number = vertex.x;
					var vy :Number = vertex.y;
					var vz :Number = vertex.z;
					
					var tx :Number = vx * m11 + vy * m12 + vz * m13 + m14;
					var ty :Number = vx * m21 + vy * m22 + vz * m23 + m24;
					var tz :Number = vx * m31 + vy * m32 + vz * m33 + m34;
					
					vertex.x = tx;
					vertex.y = ty;
					vertex.z = tz;
				}
			 
		}
 
		public function Geometry(material : Material) {
			this.material = material;
			points =new Vector.<Point3D>();
			normals = null;
			vertexes = null;
			triangles =new Vector.<Triangle>();
		}

		public function setMaterial( m : Material) : void {
			this.material = m; 
			
			var t : Triangle;
			for(var i:int=0;i<triangles.length;i++)
			{
				t=triangles[i];
				t.material = m;
			}
		}
	}
}