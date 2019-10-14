package org.paling3d.materials
{
	import flash.display.BitmapData;
	
	import org.paling3d.Paling3D;
	import org.paling3d.geom.RenderInfos;

	public class Material
	{
		static public var DEFAULT_COLOR :int = 0x000000;
		static public var DEBUG_COLOR :int = 0xFF00FF;
		public var name:String;
		public var id:int;
		public var shade : int;
		public var pointLights : Boolean;
		public var useFog : Boolean;
		public var doubleSided: Boolean;
		public var tiled:Boolean;
		public var lineColor  :Number = 0xFFFFFF * Math.random();
		public var lineAlpha  :Number = 1;
		public var fillColor  :Number = DEFAULT_COLOR;
		public var fillAlpha  :Number = 1; 
		function Material() {
			shade =Paling3D.DEFAULT_SHADE_MODEL;
			pointLights = true;
		}
		static public function get DEFAULT():Material
		{
			var defMaterial :Material = new WireMaterial( Color.ofInt(DEFAULT_COLOR)); //RH, it now returns a wireframe material.
			defMaterial.lineColor   = 0xFFFFFF * Math.random();
			defMaterial.lineAlpha   = 1;
			defMaterial.fillColor   = DEFAULT_COLOR;
			defMaterial.fillAlpha   = 1;
			defMaterial.doubleSided = false;
			
			return defMaterial;
		}
		public function buildAmbientDiffuseBitmap( bmp : BitmapData, ambient : Color, diffuse : Color ):void{
			var size:int = bmp.width;
			var d:Number = 1 / (size - 1);
			for(var i: int= 0;i<size;i++ ) {
				var k:Number = i * d;
				var r:Number = ambient.r + diffuse.r * k;
				var g:Number = ambient.g + diffuse.g * k;
				var b:Number = ambient.b + diffuse.b * k;
				var a:Number = ambient.a + diffuse.a * k;
				if( r > 1 ) r = 1;
				if( g > 1 ) g = 1;
				if( b > 1 ) b = 1;
				if( a > 1 ) a = 1;
				bmp.setPixel32(i,0,new Color(r,g,b,a).argb);
			}
		}
		
		public function update():void {
			// TO OVERRIDE
		}
		
		public function free():void {
			// TO OVERRIDE
		}
	 
		public function draw( r :  RenderInfos ):void {
			// TO OVERRIDE
		}
		public function clone():Material {
			// TO OVERRIDE
			return null;
		}
	}
}