package org.paling3d.animation.channel.geometry 
{
	import org.paling3d.geom.Point3D;
	import org.paling3d.geom.Vertex;
	import org.paling3d.primitives.Geometry;
	 

	/**
	 * The VerticesChannel3D animates the GeometryObject3D#vertices array.
	 * 
	 * @see lh3d.proto.GeometryObject3D
	 * @see lh3d.geom.renderables.Vertex3D
	 * 
	 * @author Tim Knip / floorplanner.com
	 */
	public class VerticesChannel3D extends GeometryChannel3D 
	{  
		/**
		 * 
		 */
		public function VerticesChannel3D(geometry : Geometry) 
		{ 
			super(geometry);
		}
		
		/**
		 * 
		 */
		override public function update(time : Number) : void 
		{
			var curves : Array = _curves;
			var numCurves : int = curves.length;
			
			if(!_geometry || !_geometry.vertexes )//why || (_geometry.vertices.length * 3) != numCurves)
			{
				return;
			}
			
			var verts : Array = _geometry.points;
			var numVerts : int = verts.length;
			var v :Point3D;  //	import org.papervision3d.core.geom.renderables.Vertex3D;
			var  j : int = 0;
			
			super.update(time); 
			for(j=0;j< verts.length;j += 3;) {			 
			 
				v = verts[j]; 
				v.x = output[j];
				v.y = output[j+1];
				v.z = output[j+2];
				
				
				
			
			}
		}
	}
}
