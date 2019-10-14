package org.paling3d.materials
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	
	import org.paling3d.Paling3D;
	import org.paling3d.geom.RenderInfos;

	public class RGBMaterial extends Material
	{
		private var bmpR :BitmapData;
		private var bmpGB : BitmapData;

		 
		public function RGBMaterial() {
			super();
			shade = ShadeModel.RGBLight;
			init();
		}
		
		private  function init():void {
			bmpR = new BitmapData(256,1,true,0);
			bmpGB = new BitmapData(256,256,true,0);
			bmpR.lock();
			bmpGB.lock();
			for(var x: int= 0;x<256;x++ ) {
				bmpR.setPixel32(x,0,0xFF000000 | (x << 16));
				for(var y :int= 0;y<256;y++ )
					bmpGB.setPixel32(x,y,0xFF000000 | (x << 8) | y);
			}
			bmpR.unlock();
			bmpGB.unlock();
		}
		
		override public function free():void {
			bmpR.dispose();
			bmpGB.dispose();
		}
		
		override public function draw( r : RenderInfos ):void {
			
			var g :Graphics= r.display.getContext(BlendMode.NORMAL);
			g.beginBitmapFill(bmpR,null,false,false);
			g.drawTriangles(r.vertexes,r.indexes,r.lightning);
			g = r.display.getContext(BlendMode.ADD);
			g.beginBitmapFill(bmpGB,null,false,false);
			g.drawTriangles(r.vertexes,r.indexes,r.colors,Paling3D.CULLING);
		}

	}
}