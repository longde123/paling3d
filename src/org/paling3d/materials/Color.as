package org.paling3d.materials
{
	public class Color
	{
	 
		public var r : Number=0;
		public var g: Number=0;
		public var b: Number=0;
		public var a : Number=0;
		public var argb: uint;
		
		public function Color( r: Number, g: Number, b: Number, a: Number = 1.0 ) {
			this.r = r;
			this.g = g;
			this.b = b;
			this.a = a;
			argb = int(a * 255.0) << 24 | int(r * 255.0) << 16 | int(g * 255.0) << 8 | int(b * 255.0);
		}
		
		public function add( c : Color ):Color {
			var r:Number = r + c.r;
			var g:Number = g + c.g;
			var b:Number = b + c.b;
			var a:Number = a + c.a;
			if( r > 1 ) r = 1;
			if( g > 1 ) g = 1;
			if( b > 1 ) b = 1;
			if( a > 1 ) a = 1;
			return new Color(r,g,b,a);
		}
		
		public function scale( f : Number ) :Color{
			var r:Number = r * f;
			var g:Number = g * f;
			var b:Number = b * f;
			if( r > 1 ) r = 1;
			if( g > 1 ) g = 1;
			if( b > 1 ) b = 1;
			return new Color(r,g,b,a);
		}
		
		public function toString() :String{
			return "[Color = "+argb.toString(16)+"]";
		}
		
		public static   function ofInt( c : uint ):Color {
			return new Color(((c >> 16) & 0xFF) / 255.0,((c >> 8) & 0xFF) / 255.0,(c & 0xFF) / 255.0,(c >>> 24) / 255.0);
		}
	}
}