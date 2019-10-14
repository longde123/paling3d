package org.paling3d.materials {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.TriangleCulling;
 
	import flash.geom.Matrix;
	
	import org.paling3d.Paling3D;
	import org.paling3d.geom.RenderInfos;

	public class BitmapMaterial extends Material {
		public var sub : Material;
		public var smooth : Boolean;
		public var texture : Texture;
		 
		public function BitmapMaterial( sub : Material, texture : Texture ) {
			super();
			this.sub = sub;
			this.smooth = true;
			this.texture = texture;
		}

		override public function free() : void {
			if( sub != null ) sub.free();
		}
		 
		override public function draw( r : RenderInfos  ) : void {
			 
		   if( sub != null ) sub.draw(r);
		 
	 
			var g : Graphics = r.display.getContext(BlendMode.MULTIPLY);
			g.beginBitmapFill(texture.bitmap, null, false, smooth); 
			  g.drawTriangles(r.vertexes, r.indexes, r.uvcoords,Paling3D.CULLING);
		}
		
		
		
	}
}