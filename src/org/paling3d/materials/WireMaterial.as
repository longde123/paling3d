package org.paling3d.materials {
	import flash.display.BlendMode;
	import flash.display.Graphics;
	
	import org.paling3d.Paling3D;
	import org.paling3d.geom.RenderInfos;

	public class WireMaterial  extends Material {

		public var color : Color;

		public function WireMaterial(color : Color) {
			super();
			this.color = color;
		}

		override public function draw( r : RenderInfos ) : void {
			var g : Graphics = r.display.getContext(BlendMode.NORMAL);
			g.lineStyle(1, color.argb, color.a);
			g.drawTriangles(r.vertexes, r.indexes, null,Paling3D.CULLING);
			g.lineStyle();
		}
	}
}