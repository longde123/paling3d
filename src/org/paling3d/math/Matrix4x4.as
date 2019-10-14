package org.paling3d.math
{
	import org.paling3d.Paling3D;

	public class Matrix4x4
	{
		
		static private var toDEGREES :Number = 180/Math.PI;
		static private var toRADIANS :Number = Math.PI/180;
		static private var temp : Matrix4x4 = Matrix4x4.IDENTITY; 
		static private var _sin:Function = Math.sin;
		static private var _cos:Function = Math.cos;
		
		public var _11 : Number;
		public var _12 : Number;
		public var _13 : Number;
		public var _14 : Number;
		public var _21 : Number;
		public var _22 : Number;
		public var _23 : Number;
		public var _24 : Number;
		public var _31 : Number;
		public var _32 : Number;
		public var _33 : Number;
		public var _34 : Number;
		public var _41 : Number;
		public var _42 : Number;
		public var _43 : Number;
		public var _44 : Number;
		public function Matrix4x4()
		{
			
		}
		public function copy( m:Matrix4x4 ):Matrix4x4
		{
			this._11 = m._11;	this._12 = m._12;
			this._13 = m._13;	this._14 = m._14;
			
			this._21 = m._21;	this._22 = m._22;
			this._23 = m._23;	this._24 = m._24;
			
			this._31 = m._31;	this._32 = m._32;
			this._33 = m._33;	this._34 = m._34;
			
			return this;
		}

		public function get det():Number
		{
			return	(this._11 * this._22 - this._21 * this._12) * this._33 - (this._11 * this._32 - this._31 * this._12) * this._23 +
				(this._21 * this._32 - this._31 * this._22) * this._13;
		}
		public function calculateInverse( m:Matrix4x4 ):void
		{
			var d:Number = m.det;
			
			if( Math.abs(d) > 0.001 )
			{
				d = 1/d;
				
				var m11:Number = m._11; var m21:Number = m._21; var m31:Number = m._31;
				var m12:Number = m._12; var m22:Number = m._22; var m32:Number = m._32;
				var m13:Number = m._13; var m23:Number = m._23; var m33:Number = m._33;
				var m14:Number = m._14; var m24:Number = m._24; var m34:Number = m._34;
				
				this._11 =	 d * ( m22 * m33 - m32 * m23 );
				this._12 =	-d * ( m12 * m33 - m32 * m13 );
				this._13 =	 d * ( m12 * m23 - m22 * m13 );
				this._14 =	-d * ( m12 * (m23*m34 - m33*m24) - m22 * (m13*m34 - m33*m14) + m32 * (m13*m24 - m23*m14) );
				
				this._21 =	-d * ( m21 * m33 - m31 * m23 );
				this._22 =	 d * ( m11 * m33 - m31 * m13 );
				this._23 =	-d* ( m11 * m23 - m21 * m13 );
				this._24 =	 d * ( m11 * (m23*m34 - m33*m24) - m21 * (m13*m34 - m33*m14) + m31 * (m13*m24 - m23*m14) );
				
				this._31 =	 d * ( m21 * m32 - m31 * m22 );
				this._32 =	-d* ( m11 * m32 - m31 * m12 );
				this._33 =	 d * ( m11 * m22 - m21 * m12 );
				this._34 =	-d* ( m11 * (m22*m34 - m32*m24) - m21 * (m12*m34 - m32*m14) + m31 * (m12*m24 - m22*m14) );
			}
		}
		public function invert() : void
		{
			temp.copy(this); 	
			calculateInverse(temp); 
			
		}
		public static function matrix2euler( m :Matrix4x4, euler:Vector3D=null, scale:Vector3D=null ) : Vector3D
		{
			euler = euler || new Vector3D();
			
			// need to get rid of scale
			// TODO: whene scale is uniform, we can save some cycles. s = 3x3 determinant i beleive
			var sx		:Number = (scale && scale.x == 1) ? 1 : Math.sqrt(m._11 * m._11 + m._21 * m._21 + m._31 * m._31);
			var sy		:Number = (scale && scale.y == 1) ? 1 : Math.sqrt(m._12 * m._12 + m._22 * m._22 + m._32 * m._32);
			var sz		:Number = (scale && scale.z == 1) ? 1 : Math.sqrt(m._13 * m._13 + m._23 * m._23 + m._33 * m._33);
			
			var n11		:Number = m._11 / sx;
			var n21		:Number = m._21 / sy;
			var n31		:Number = m._31 / sz;
			var n32		:Number = m._32 / sz;
			var n33		:Number = m._33 / sz;
			
			n31 = n31 > 1 ? 1 : n31;
			n31 = n31 < -1 ? -1 : n31;
			
			// zyx
			euler.y = Math.asin(-n31);
			euler.z = Math.atan2(n21, n11);
			euler.x = Math.atan2(n32, n33);
			
			// TODO: fix singularities
			
			// yzx
			//euler.z = Math.asin(-m._21);
			//euler.y = Math.atan2(m._31, m._11);
			//euler.x = Math.atan2(-m._23, m._22);
			
			// zxy
			//euler.x = Math.asin(-m._32);
			//euler.z = Math.atan2(-m._12, m._22);
			//euler.y = Math.atan2(-m._31, m._33);
			
			if(Paling3D.useDEGREES)
			{
				euler.x *= toDEGREES;
				euler.y *= toDEGREES;
				euler.z *= toDEGREES;
			}
			
			//  Clamp values
			// euler.x = euler.x < 0 ? euler.x + 360 : euler.x;
			// euler.y = euler.y < 0 ? euler.y + 360 : euler.y;
			// euler.z = euler.z < 0 ? euler.z + 360 : euler.z;
			
			return euler;
		}
		public function reset():void
		{
			identity();
		}
		public function copy3x3( m:Matrix4x4 ):Matrix4x4
		{
			this._11 = m._11;   this._12 = m._12;   this._13 = m._13;
			this._21 = m._21;   this._22 = m._22;   this._23 = m._23;
			this._31 = m._31;   this._32 = m._32;   this._33 = m._33;
			
			return this;
		}

		public static function translationMatrix( x:Number, y:Number, z:Number ):Matrix4x4
		{
			//trace("translation matrix"); 
			var m:Matrix4x4 = IDENTITY;
			
			m._14 = x;
			m._24 = y;
			m._34 = z;
			
			return m;
		}
		public static function scaleMatrix( x:Number, y:Number, z:Number ):Matrix4x4
		{
			//trace("scalematrix"); 
			var m:Matrix4x4 = IDENTITY;
			
			m._11 = x;
			m._22 = y;
			m._33 = z;
			
			return m;
		}

		public static function get IDENTITY():Matrix4x4
		{
			//trace("Matrix.IDENTITY"); 
			var m: Matrix4x4=new Matrix4x4();
			m.setMatrix3DArray( 
				[
					1, 0, 0, 0,
					0, 1, 0, 0,
					0, 0, 1, 0,
					0, 0, 0, 1
				]
			);
			return m;
		}
		public static function multiplyVector( m:Matrix4x4, v:Vector3D ):void
		{
			var vx:Number = v.x;
			var vy:Number = v.y;
			var vz:Number = v.z;
			
			v.x = vx * m._11 + vy * m._12 + vz * m._13 + m._14;
			v.y = vx * m._21 + vy * m._22 + vz * m._23 + m._24;
			v.z = vx * m._31 + vy * m._32 + vz * m._33 + m._34;
		}
		public static function multiply( a:Matrix4x4, b:Matrix4x4 ):Matrix4x4
		{
			//trace("matrix.multiply"); 
			var m:Matrix4x4 = new Matrix4x4();
			
			m.multiply4x4( a, b );
			
			return m;
		}
		public static function rotationMatrix( x:Number, y:Number, z:Number, rad:Number, targetmatrix:Matrix4x4 = null ):Matrix4x4
		{
			
			var m:Matrix4x4;
			if(!targetmatrix) 
			{
				//trace("rotationmatrix"); 
				m = new Matrix4x4();
				m.identity();
			}
			else m = targetmatrix; 
			
			var nCos:Number	= Math.cos( rad );
			var nSin:Number	= Math.sin( rad );
			var scos:Number	= 1 - nCos;
			
			var sxy	:Number = x * y * scos;
			var syz	:Number = y * z * scos;
			var sxz	:Number = x * z * scos;
			var sz	:Number = nSin * z;
			var sy	:Number = nSin * y;
			var sx	:Number = nSin * x;
			
			m._11 =  nCos + x * x * scos;
			m._12 = -sz   + sxy;
			m._13 =  sy   + sxz;
			m._14 = 0;
			
			m._21 =  sz   + sxy;
			m._22 =  nCos + y * y * scos;
			m._23 = -sx   + syz;
			m._24 = 0;
			
			m._31 = -sy   + sxz;
			m._32 =  sx   + syz;
			m._33 =  nCos + z * z * scos;
			m._34 = 0;
			
			return m;
		}

		public function setMatrix3DArray(arr:Array=null):void
		{
			if(arr==null)return;
			
			_11 =arr[0]
			_12 =arr[1]
			_13 =arr[2]
			_14 =arr[3]
			
			_21 =arr[4]
			_22 =arr[5]
			_23 =arr[6]
			_24 =arr[7]
			
			_31 =arr[8]
			_32 =arr[9]
			_33 =arr[10]
			_34 =arr[11]
			
			_41 =arr[12]
			_42 =arr[13]
			_43 =arr[14]
			_44 =arr[15]
			
		} 
		public static function clone( m:Matrix4x4 ):Matrix4x4
		{
			//trace("matrix3D.clone");
			var m:Matrix4x4=new Matrix4x4
			
			m.setMatrix3DArray(
				[
					m._11, m._12, m._13, m._14,
					m._21, m._22, m._23, m._24,
					m._31, m._32, m._33, m._34
				]
			);
			return m;
		}
		 

		public function zero():void {
			_11 = 0.0; _12 = 0.0; _13 = 0.0; _14 = 0.0;
			_21 = 0.0; _22 = 0.0; _23 = 0.0; _24 = 0.0;
			_31 = 0.0; _32 = 0.0; _33 = 0.0; _34 = 0.0;
			_41 = 0.0; _42 = 0.0; _43 = 0.0; _44 = 0.0;
		}
		
		public function identity():void {
			_11 = 1.0; _12 = 0.0; _13 = 0.0; _14 = 0.0;
			_21 = 0.0; _22 = 1.0; _23 = 0.0; _24 = 0.0;
			_31 = 0.0; _32 = 0.0; _33 = 1.0; _34 = 0.0;
			_41 = 0.0; _42 = 0.0; _43 = 0.0; _44 = 1.0;
		}
		
		public function initRotateX( a : Number ):void {
			var cos:Number = Math.cos(a);
			var sin:Number = Math.sin(a);
			_11 = 1.0; _12 = 0.0; _13 = 0.0; _14 = 0.0;
			_21 = 0.0; _22 = cos; _23 = sin; _24 = 0.0;
			_31 = 0.0; _32 = -sin; _33 = cos; _34 = 0.0;
			_41 = 0.0; _42 = 0.0; _43 = 0.0; _44 = 1.0;
		}
		
		public function initRotateY( a : Number ):void {
			var cos:Number = Math.cos(a);
			var sin :Number= Math.sin(a);
			_11 = cos; _12 = 0.0; _13 = -sin; _14 = 0.0;
			_21 = 0.0; _22 = 1.0; _23 = 0.0; _24 = 0.0;
			_31 = sin; _32 = 0.0; _33 = cos; _34 = 0.0;
			_41 = 0.0; _42 = 0.0; _43 = 0.0; _44 = 1.0;
		}
		
		public function initRotateZ( a : Number ):void {
			var cos:Number = Math.cos(a);
			var sin :Number= Math.sin(a);
			_11 = cos; _12 = sin; _13 = 0.0; _14 = 0.0;
			_21 = -sin; _22 = cos; _23 = 0.0; _24 = 0.0;
			_31 = 0.0; _32 = 0.0; _33 = 1.0; _34 = 0.0;
			_41 = 0.0; _42 = 0.0; _43 = 0.0; _44 = 1.0;
		}
		
		public function initTranslate( x : Number, y : Number, z : Number ):void {
			_11 = 1.0; _12 = 0.0; _13 = 0.0; _14 = 0.0;
			_21 = 0.0; _22 = 1.0; _23 = 0.0; _24 = 0.0;
			_31 = 0.0; _32 = 0.0; _33 = 1.0; _34 = 0.0;
			_41 = x; _42 = y; _43 = z; _44 = 1.0;
		}
		
		public  function translate( x : Number, y : Number, z : Number ):void {
			_41 += x;
			_42 += y;
			_43 += z;
		}
		
		public function initScale( x : Number, y : Number, z : Number ):void {
			_11 = x; _12 = 0.0; _13 = 0.0; _14 = 0.0;
			_21 = 0.0; _22 = y; _23 = 0.0; _24 = 0.0;
			_31 = 0.0; _32 = 0.0; _33 = z; _34 = 0.0;
			_41 = 0.0; _42 = 0.0; _43 = 0.0; _44 = 1.0;
		}
		public function calculateMultiply( a:Matrix4x4, b:Matrix4x4 ):void
		{
			var a11:Number = a._11; var b11:Number = b._11;
			var a21:Number = a._21; var b21:Number = b._21;
			var a31:Number = a._31; var b31:Number = b._31;
			var a12:Number = a._12; var b12:Number = b._12;
			var a22:Number = a._22; var b22:Number = b._22;
			var a32:Number = a._32; var b32:Number = b._32;
			var a13:Number = a._13; var b13:Number = b._13;
			var a23:Number = a._23; var b23:Number = b._23;
			var a33:Number = a._33; var b33:Number = b._33;
			var a14:Number = a._14; var b14:Number = b._14;
			var a24:Number = a._24; var b24:Number = b._24;
			var a34:Number = a._34; var b34:Number = b._34;
			
			this._11 = a11 * b11 + a12 * b21 + a13 * b31;
			this._12 = a11 * b12 + a12 * b22 + a13 * b32;
			this._13 = a11 * b13 + a12 * b23 + a13 * b33;
			this._14 = a11 * b14 + a12 * b24 + a13 * b34 + a14;
			
			this._21 = a21 * b11 + a22 * b21 + a23 * b31;
			this._22 = a21 * b12 + a22 * b22 + a23 * b32;
			this._23 = a21 * b13 + a22 * b23 + a23 * b33;
			this._24 = a21 * b14 + a22 * b24 + a23 * b34 + a24;
			
			this._31 = a31 * b11 + a32 * b21 + a33 * b31;
			this._32 = a31 * b12 + a32 * b22 + a33 * b32;
			this._33 = a31 * b13 + a32 * b23 + a33 * b33;
			this._34 = a31 * b14 + a32 * b24 + a33 * b34 + a34;
		}
		// 3x4 multiply by default
		public function multiply3x4( a : Matrix4x4, b : Matrix4x4 ):void {
			var a11:Number = a._11; var a12:Number = a._12; var a13:Number = a._13;
			var a21:Number = a._21; var a22:Number = a._22; var a23:Number = a._23;
			var a31:Number = a._31; var a32:Number = a._32; var a33:Number = a._33;
			var a41:Number = a._41; var a42:Number = a._42; var a43:Number = a._43;
			var b11:Number = b._11; var b12:Number = b._12; var b13:Number = b._13;
			var b21:Number = b._21; var b22:Number = b._22; var b23:Number = b._23;
			var b31:Number = b._31; var b32:Number = b._32; var b33:Number = b._33;
			var b41:Number = b._41; var b42:Number = b._42; var b43:Number = b._43;
			
			_11 = a11 * b11 + a12 * b21 + a13 * b31;
			_12 = a11 * b12 + a12 * b22 + a13 * b32;
			_13 = a11 * b13 + a12 * b23 + a13 * b33;
			_14 = 0;
			
			_21 = a21 * b11 + a22 * b21 + a23 * b31;
			_22 = a21 * b12 + a22 * b22 + a23 * b32;
			_23 = a21 * b13 + a22 * b23 + a23 * b33;
			_24 = 0;
			
			_31 = a31 * b11 + a32 * b21 + a33 * b31;
			_32 = a31 * b12 + a32 * b22 + a33 * b32;
			_33 = a31 * b13 + a32 * b23 + a33 * b33;
			_34 = 0;
			
			_41 = a41 * b11 + a42 * b21 + a43 * b31 + b41;
			_42 = a41 * b12 + a42 * b22 + a43 * b32 + b42;
			_43 = a41 * b13 + a42 * b23 + a43 * b33 + b43;
			_44 = 1;
		}
		
		public function multiply4x4( a : Matrix4x4, b : Matrix4x4 ):void {
			var a11:Number = a._11; var a12:Number = a._12; var a13:Number = a._13; var a14:Number = a._14;
			var a21:Number = a._21; var a22:Number = a._22; var a23:Number = a._23; var a24:Number = a._24;
			var a31:Number = a._31; var a32:Number = a._32; var a33:Number = a._33; var a34:Number = a._34;
			var a41:Number = a._41; var a42:Number = a._42; var a43:Number = a._43; var a44:Number = a._44;
			var b11:Number = b._11; var b12:Number = b._12; var b13:Number = b._13; var b14:Number = b._14;
			var b21:Number = b._21; var b22:Number = b._22; var b23:Number = b._23; var b24:Number = b._24;
			var b31:Number = b._31; var b32:Number = b._32; var b33:Number = b._33; var b34:Number = b._34;
			var b41:Number = b._41; var b42:Number = b._42; var b43:Number = b._43; var b44:Number = b._44;
			
			_11 = a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41;
			_12 = a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42;
			_13 = a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43;
			_14 = a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44;
			
			_21 = a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41;
			_22 = a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42;
			_23 = a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43;
			_24 = a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44;
			
			_31 = a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41;
			_32 = a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42;
			_33 = a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43;
			_34 = a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44;
			
			_41 = a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41;
			_42 = a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42;
			_43 = a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43;
			_44 = a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44;
		}
		
		public  function multiply3x4_4x4( a : Matrix4x4, b : Matrix4x4 ):void {
			var a11:Number = a._11; var a12:Number = a._12; var a13:Number = a._13;
			var a21:Number = a._21; var a22:Number = a._22; var a23:Number = a._23;
			var a31:Number = a._31; var a32:Number = a._32; var a33:Number = a._33;
			var a41:Number = a._41; var a42:Number = a._42; var a43:Number = a._43;
			var b11:Number = b._11; var b12:Number = b._12; var b13:Number = b._13; var b14:Number = b._14;
			var b21:Number = b._21; var b22:Number = b._22; var b23:Number = b._23; var b24:Number = b._24;
			var b31:Number = b._31; var b32:Number = b._32; var b33:Number = b._33; var b34:Number = b._34;
			var b41:Number = b._41; var b42:Number = b._42; var b43:Number= b._43; var b44:Number = b._44;
			
			_11 = a11 * b11 + a12 * b21 + a13 * b31;
			_12 = a11 * b12 + a12 * b22 + a13 * b32;
			_13 = a11 * b13 + a12 * b23 + a13 * b33;
			_14 = a11 * b14 + a12 * b24 + a13 * b34;
			
			_21 = a21 * b11 + a22 * b21 + a23 * b31;
			_22 = a21 * b12 + a22 * b22 + a23 * b32;
			_23 = a21 * b13 + a22 * b23 + a23 * b33;
			_24 = a21 * b14 + a22 * b24 + a23 * b34;
			
			_31 = a31 * b11 + a32 * b21 + a33 * b31;
			_32 = a31 * b12 + a32 * b22 + a33 * b32;
			_33 = a31 * b13 + a32 * b23 + a33 * b33;
			_34 = a31 * b14 + a32 * b24 + a33 * b34;
			
			_41 = a41 * b11 + a42 * b21 + a43 * b31 + b41;
			_42 = a41 * b12 + a42 * b22 + a43 * b32 + b42;
			_43 = a41 * b13 + a42 * b23 + a43 * b33 + b43;
			_44 = a41 * b14 + a42 * b24 + a43 * b34 + b44;
		}
		
		public function inverse3x4( m : Matrix4x4 ) :void{
			var m11:Number = m._11; var m12:Number = m._12; var m13:Number = m._13;
			var m21:Number = m._21; var m22:Number = m._22; var m23:Number = m._23;
			var m31:Number = m._31; var m32:Number = m._32; var m33:Number = m._33;
			_11 = m22*m33 - m23*m32;
			_12 = m13*m32 - m12*m33;
			_13 = m12*m23 - m13*m22;
			_14 = 0;
			_21 = m23*m31 - m21*m33;
			_22 = m11*m33 - m13*m31;
			_23 = m13*m21 - m11*m23;
			_24 = 0;
			_31 = m21*m32 - m22*m31;
			_32 = m12*m31 - m11*m32;
			_33 = m11*m22 - m12*m21;
			_34 = 0;
			_41 = -m._41;
			_42 = -m._42;
			_43 = -m._43;
			_44 = 1;
			var det:Number = m11 * _11 + m12 * _21 + m13 * _31;
			if( det < Paling3D.EPSILON ) {
				zero();
				return;
			}
			var invDet:Number = 1.0 / det;
			_11 *= invDet; _12 *= invDet; _13 *= invDet;
			_21 *= invDet; _22 *= invDet; _23 *= invDet;
			_31 *= invDet; _32 *= invDet; _33 *= invDet;
		}
		
		public  function project( v : Vector3D, out : Vector3D ):  Number {
			var px:Number = _11 * v.x + _21 * v.y + _31 * v.z + _41;
			var py:Number = _12 * v.x + _22 * v.y + _32 * v.z + _42;
			var pz:Number = _13 * v.x + _23 * v.y + _33 * v.z + _43;
			var w:Number = 1.0 / (_14 * v.x + _24 * v.y + _34 * v.z + _44);
			out.x = px * w;
			out.y = py * w;
			out.z = pz;
			return w;
		}
		
		public  function transform( v : Vector3D, out : Vector3D )  : void {
			var px:Number = _11 * v.x + _21 * v.y + _31 * v.z + _41;
			var py:Number = _12 * v.x + _22 * v.y + _32 * v.z + _42;
			var pz:Number = _13 * v.x + _23 * v.y + _33 * v.z + _43;
			out.x = px;
			out.y = py;
			out.z = pz;
		}
		
		public function toString():String {
			return "MAT=[\n" +
				"  [ " + Paling3D.f(_11) + ", " + Paling3D.f(_12) + ", " + Paling3D.f(_13) + ", " + Paling3D.f(_14) + " ]\n" +
				"  [ " + Paling3D.f(_21) + ", " + Paling3D.f(_22) + ", " + Paling3D.f(_23) + ", " + Paling3D.f(_24) + " ]\n" +
				"  [ " + Paling3D.f(_31) + ", " + Paling3D.f(_32) + ", " + Paling3D.f(_33) + ", " + Paling3D.f(_34) + " ]\n" +
				"  [ " + Paling3D.f(_41) + ", " + Paling3D.f(_42) + ", " + Paling3D.f(_43) + ", " + Paling3D.f(_44) + " ]\n" +
				"]";
		}
		
		public function toVector():Vector.<Number> {
			
			var v:Vector.<Number> = new Vector.<Number>();
			v.push(_11,_12,_13,_14,_21,_22,_23,_24,_31,_32,_33,_34,_41,_42,_43,_44);
			 
			return v;
		}
	}
}