package org.paling3d.animation.channel.geometry 
{
	import org.paling3d.animation.channel.Channel3D;
	import org.paling3d.primitives.Geometry;
	 
	
	/**
	 * @author Tim Knip / floorplanner.com
	 */
	public class GeometryChannel3D extends Channel3D 
	{
		/**
		 * The targeted geometry.
		 */
		protected var _geometry : Geometry;
		
		/**
		 * Constructor.
		 * 
		 * @param geometry
		 */
		public function GeometryChannel3D(geometry : Geometry) 
		{
			super();
			
			this.geometry = geometry;
		}
		
		/**
		 * The targeted geometry.
		 */
		public function set geometry(value : Geometry) : void
		{
			if(value && value.vertexes  )
			{
				_geometry = value;
			}
		}
		
		/**
		 * 
		 */
		public function get goemetry() : Geometry
		{
			return _geometry;
		}
	}
}
