package org.paling3d.math
{
	import org.paling3d.Paling3D;

	public class Vector3D
	{

		public var x : Number;
		public var y : Number;
		public var z : Number;
		static public function get ZERO():Vector3D
		{
			return new Vector3D( 0, 0, 0 );
		}
		public function reset(newx:Number = 0, newy:Number = 0, newz:Number = 0):void
		{
			x = newx; 
			y = newy; 
			z = newz; 
		}
		public function Vector3D( x : Number = 0., y : Number = 0., z : Number = 0. ) : void 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}

		public  function sub( v : Vector3D ) : Vector3D 
		{
			return new Vector3D(x - v.x, y - v.y, z - v.z);
		}

		public  function add( v : Vector3D ) : Vector3D 
		{
			return new Vector3D(x + v.x, y + v.y, z + v.z);
		}

		public  function cross( v : Vector3D ) : Vector3D 
		{
			return new Vector3D(y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x);
		}

		public  function dot( v : Vector3D ) : Number
		{
			return x * v.x + y * v.y + z * v.z;
		}

		public  function length() : Number 
		{
			return Math.sqrt(x * x + y * y + z * z);
		}

		public function normalize() : void 
		{
			var k : Number = length();
			if( k < Paling3D.EPSILON )
			{ 
				k = 0 ;
			}
			else
			{ 
				k = 1.0 / k;
			}
			x *= k;
			y *= k;
			z *= k;
		}

		public function set(x : Number ,y : Number ,z : Number ) : void 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}

		public  function scale( f : Number ) : void 
		{
			x *= f;
			y *= f;
			z *= f;
		}

		public  function copy() : Vector3D
		{
			return new Vector3D(x, y, z);
		}
		public  function clone() : Vector3D
		{
			return new Vector3D(x, y, z);
		}
		public function toString() : String
		{
			return "{" + Paling3D.f(x) + "," + Paling3D.f(y) + "," + Paling3D.f(z) + "}";
		}
	}
}