package org.paling3d.cameras
{
	import org.paling3d.math.Matrix4x4;
	import org.paling3d.math.Vector3D;
	import org.paling3d.objects.Object3D;

	public class Camera3D  extends Object3D 
	{ 
		 
		public var target : Vector3D;
		public var up : Vector3D;
		
		public var mcam : Matrix4x4;
		public var mproj : Matrix4x4;
		public var m : Matrix4x4;
		public var wmin : Number;
		public var wmax : Number;
		
		public function Camera3D( pos : Vector3D=null, target : Vector3D=null, up : Vector3D =null) {
			
			super("Camera3D"); 
			this.position = (pos == null) ? new Vector3D(0,-100,0) : pos;
			this.target = (target == null) ? new Vector3D(0,0,0) : target;
			this.up = (up == null) ? new Vector3D(0,0,1) : up;
			
			mcam = new Matrix4x4();
			mproj = new Matrix4x4();
			m = new Matrix4x4();
			updateProjection(Math.PI/4,1e-10,100);
			update();
			
			 
		}
		
		public function updateProjection( fovAngle : Number, zNear : Number, zFar : Number, zoom : Number= 1.0, stretch : Number= 1.0 ) :void{
			// use Right-Handed
			var cotan:  Number  = (zoom * 150.0) / Math.tan(fovAngle / 2);
			mproj.zero();
			mproj._11 = cotan;
			mproj._22 = cotan * stretch;
			// maps (znear,zfar) to (0,zfar)
			var q:  Number  = zFar / (zFar - zNear);
			mproj._33 = q;
			mproj._43 = -q * zNear;
			// w = 1/-z
			mproj._34 = -1;
			this.wmin = -1.0/zNear;
			this.wmax = -1.0/zFar;
		}
		
		public function update():void {
			// use Right-Handed
			var az:  Vector3D  = target.sub(position);
			az.normalize();
			var ax :  Vector3D = up.cross(az);
			ax.normalize();
			// this can happen if the camera line-of-view is parallel to the up vector
			// in that case, choose another orthogonal vector
			if( ax.length() == 0 ) {
				ax.x = az.y;
				ax.y = az.z;
				ax.z = az.x;
			}
			var ay:  Vector3D  = az.cross(ax);
			mcam._11 = ax.x;
			mcam._12 = ay.x;
			mcam._13 = az.x;
			mcam._14 = 0;
			mcam._21 = ax.y;
			mcam._22 = ay.y;
			mcam._23 = az.y;
			mcam._24 = 0;
			mcam._31 = ax.z;
			mcam._32 = ay.z;
			mcam._33 = az.z;
			mcam._34 = 0;
			mcam._41 = -ax.dot(position);
			mcam._42 = -ay.dot(position);
			mcam._43 = -az.dot(position);
			mcam._44 = 1;
			m.multiply4x4(mcam,mproj);
		}

	}
}