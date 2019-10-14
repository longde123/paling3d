package org.paling3d.materials {
	import flash.display.BitmapData;

	public class Texture {
		public var bitmap : BitmapData;

		public function Texture() {
		 
			bitmap = EMPTY_BITMAP;
		}

		public  function free() : void {
			bitmap.dispose();
		}

		static public var EMPTY_BITMAP : BitmapData = new BitmapData(1, 1, true, 0xFFFF00FF);
	}
}