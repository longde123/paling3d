package org.paling3d.materials {
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	
	import org.paling3d.Paling3D;
	import org.paling3d.geom.RenderInfos;

	public class ColorMaterial extends Material {

		public var ambient : Color;
		public var diffuse : Color;
		private var bmp : BitmapData;

		public function ColorMaterial( ambient : Color, diffuse : Color ) {
			super();
			this.ambient = ambient;
			this.diffuse = diffuse;
		}

		override public function update() : void {
			if( bmp == null )
				bmp = new BitmapData(256, 1, true, 0);
			buildAmbientDiffuseBitmap(bmp, ambient, diffuse);
		}

		override public function free() : void {
			if( bmp != null ) bmp.dispose();
		}

		override public function draw( r : RenderInfos ) : void {
			 
			if( bmp == null )
				update();
			var g : Graphics = r.display.getContext(BlendMode.NORMAL);
			g.beginBitmapFill(bmp, null, false, false);
			g.drawTriangles(r.vertexes, r.indexes, r.lightning,Paling3D.CULLING);
		}

		public function toString() : String {
			return "[ColorMaterial " + ambient.argb.toString(8) + ":" + diffuse.argb.toString(8) + "]";
		}
	}
}