package org.paling3d
{
	import flash.display.TriangleCulling;
	
	import org.paling3d.materials.ShadeModel;
	import org.paling3d.utils.log.PaperLogger;

	public class Paling3D
	{
		public function Paling3D()
		{
		}
		public static  var EPSILON: Number = 1e-10;
		public static  var CULLING :  String =TriangleCulling.POSITIVE ;
		
		public static var DEFAULT_SHADE_MODEL:int = ShadeModel.Gouraud;
		
		// round to 4 significant digits, eliminates <1e-10
		public static function f( v : Number ):Number {
			var neg:  Number ;
			if( v < 0 ) {
				neg = -1.0;
				v = -v;
			} else
			{
				neg = 1.0;
			}
			var digits:  Number  = (4 - Math.log(v) / Math.log(10));
			if( digits < 1 )
				digits = 1;
			else if( digits >= 10 )
				return 0;
			var exp:  Number  = Math.pow(10,digits);
			return Math.floor(v * exp + .49999) * neg / exp;
		}
		
		
		
		//=======
		// ___________________________________________________________________ SETTINGS
		
		
		
		/**
		 * Indicates if the angles are expressed in degrees (true) or radians (false). The default value is true, degrees.
		 */
		public static var useDEGREES  :Boolean = true;
		
		/**
		 * Indicates if the scales are expressed in percent (true) or from zero to one (false). The default value is false, i.e. units.
		 */
		public static var usePERCENT  :Boolean = false;
		
		/**
		 * 
		 */
		public static var useRIGHTHANDED :Boolean = false;
		
		// ___________________________________________________________________ STATIC
		
		/**
		 * Enables engine name to be retrieved at runtime or when reviewing a decompiled swf.
		 */
		public static var NAME     :String = 'Papervision3D';
		
		/**
		 * Enables version to be retrieved at runtime or when reviewing a decompiled swf.
		 */
		public static var VERSION  :String = '2.0.0';
		
		/**
		 * Enables version date to be retrieved at runtime or when reviewing a decompiled swf.
		 */
		public static var DATE     :String = 'March 12th, 2009';
		
		/**
		 * Enables copyright information to be retrieved at runtime or when reviewing a decompiled swf.
		 */
		public static var AUTHOR   :String = '(c) 2006-2008 Copyright by Carlos Ulloa | John Grden | Ralph Hauwert | Tim Knip | Andy Zupko';
		
		/**
		 * This is the main Logger Controller.
		 */
		public static var PAPERLOGGER : PaperLogger = PaperLogger.getInstance();
	}
}