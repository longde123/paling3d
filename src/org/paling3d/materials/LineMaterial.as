package org.paling3d.materials
{
	import org.paling3d.geom.RenderInfos;

	public class LineMaterial extends Material
	{
 
		public function LineMaterial(color:Number = 0xFF0000, alpha:Number = 1)
		{
			super();
			this.lineColor = color;
			this.lineAlpha = alpha;
		}
		override public function draw( r : RenderInfos ):void {
			
		}
	}
}