package org.paling3d.geom
{
	import org.paling3d.materials.LineMaterial;
	import org.paling3d.materials.Material;
	import org.paling3d.math.Vector3D;

	public class Line3D
	{
		public var z : Number;
		public var v0 : Vector3D;
		public var v1 : Vector3D; 
		public var cV: Vector3D;		
		public var n : Normal;
		public var material : Material;
		public var size:Number;
		public function Line3D( material:LineMaterial, size:Number, vertex0:Vector3D, vertex1:Vector3D)
		{
			this.size = size;
			this.material = material;
			this.v0 = vertex0;
			this.v1 = vertex1;
			this.cV = vertex1;
		}
	}
}