package org.paling3d.animation.channel.geometry 
{
	import org.paling3d.animation.channel.Channel3D;
	import org.paling3d.geom.Point3D;
	import org.paling3d.geom.Vertex;
	import org.paling3d.primitives.Geometry;
	  

	/**
	 * The VertexChannel3D class animates a single vertex in a GeometryObject3D.
	 * 
	 * <p>You can animate a single property of the vertex ("x", "y" or "z"), or alternatively
	 * you can animate all 3 properties of the vertex.</p>
	 * 
	 * @see lh3d.animation.channel.Channel3D
	 * @see lh3d.proto.GeometryObject3D
	 * @see lh3d.geom.renderables.Vertex3D
	 * 
	 * @author Tim Knip / floorplanner.com
	 */
	public class VertexChannel3D extends GeometryChannel3D 
	{
		public static const TARGET_X 	: int = 0;
		public static const TARGET_Y 	: int = 1;
		public static const TARGET_Z 	: int = 2;
		public static const TARGET_XYZ 	: int = -1;
		
		/**
		 * The index of the targeted vertex.
		 */
		public var vertexIndex : uint;
		
		/**
		 * The targeted property of the targeted vertex.
		 * Possible values are #TARGET_X, #TARGET_Y, #TARGET_Z or #TARGET_XYZ
		 */
		public var vertexProperty : int;
		
		/**
		 * 
		 */
		protected var _clone : Geometry;

		/**
		 * Constructor
		 */
		public function VertexChannel3D(geometry : Geometry, vertexIndex : uint, vertexProperty : int = -1) 
		{
		 
			super(geometry);
			
			this.vertexIndex = vertexIndex;
			this.vertexProperty = vertexProperty;
		}

		/**
		 * 
		 */
		override public function update(time : Number) : void 
		{
			if(!_curves || !_geometry || !_clone)
			{
				return;
			}
			
			super.update(time);
			
			var o : Point3D = _clone.points[vertexIndex];   //lh3d.geom.Vertex
			var t : Point3D = _geometry.points[vertexIndex];  //lh3d.geom.Vertex
			var numCurves : int = _curves.length;
			
			if(vertexProperty == TARGET_XYZ && numCurves == 3)
			{
				t.x = o.x + output[0];
				t.y = o.y + output[1];
				t.z = o.z + output[2];
			}
			else if(numCurves == 1)
			{
				var prop : String = vertexProperty == 0 ? "x" : (vertexProperty == 1 ? "y" : "z");
				
				t[prop] = o[prop] + output[0];
			}
		}

		/**
		 * 
		 */
		override public function set geometry(value : Geometry) : void 
		{
			super.geometry = value;
			if(_geometry && _geometry.vertexes!=null)
			{
				_clone = _geometry.clone();
			}
		}
	}
}
