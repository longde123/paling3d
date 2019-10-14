package org.paling3d.objects
{ 
	import org.paling3d.Paling3D;
	import org.paling3d.geom.RenderInfos;
	import org.paling3d.geom.Stats;
	import org.paling3d.materials.Material;
	import org.paling3d.math.Matrix4x4;
	import org.paling3d.math.Quaternion;
	import org.paling3d.math.Vector3D;
	import org.paling3d.objects.proto.ObjectContainer3D;
	import org.paling3d.primitives.Builder;
	import org.paling3d.primitives.Geometry;

	public class Object3D extends ObjectContainer3D
	{
		
		public var name : String;
		
		public var geometry : Geometry ;
		public var transform : Matrix4x4;
		public var world : Matrix4x4;
		public var view : Matrix4x4;
		
		
		
		 
		public function set useOwnContainer(value:Boolean):void
		{
			_useOwnContainer = value;
			setParentContainer(this, true);
		}
		
		public function get useOwnContainer():Boolean
		{
			return _useOwnContainer;
		}
		
		 
		/**
		 * An Number that sets the X coordinate of a object relative to the origin of its parent.
		 */
		public function get x():Number
		{
			return this.transform._14;
		}
		
		public function set x( value:Number ):void
		{
			this.transform._14 = value;
		}
		
		/**
		 * An Number that sets the Y coordinate of a object relative to the origin of its parent.
		 */
		public function get y():Number
		{
			return this.transform._24;
		}
		
		public function set y( value:Number ):void
		{
			this.transform._24 = value;
		}
		
		/**
		 * An Number that sets the Z coordinate of a object relative to the origin of its parent.
		 */
		public function get z():Number
		{
			return this.transform._34;
		}
		
		public function set z( value:Number ):void
		{
			this.transform._34 = value;
		}
		
		/**
		 * A Number3D containing the current x, y, and z of the DisplayObject3D
		 */
		
		public function get position():Vector3D
		{
			_position.reset(this.x, this.y, this.z);
			return _position;
		}
		
		public function set position(n:Vector3D):void
		{
			this.x = n.x;
			this.y = n.y;
			this.z = n.z;
		}
		
		/**
		 * Specifies the rotation around the X axis from its original orientation.
		 */
		public function get rotationX():Number
		{
			if( this._rotationDirty ) updateRotation();
			
			return Paling3D.useDEGREES ? this._rotationX * toDEGREES : this._rotationX;
		}
		
		public function set rotationX( rot:Number ):void
		{
			this._rotationX = Paling3D.useDEGREES ? rot * toRADIANS : rot;
			
			this._transformDirty = true;
		}
		
		/**
		 * Specifies the rotation around the Y axis from its original orientation.
		 */
		public function get rotationY():Number
		{
			if( this._rotationDirty ) updateRotation();
			
			return Paling3D.useDEGREES ? this._rotationY * toDEGREES : this._rotationY;
		}
		
		public function set rotationY( rot:Number ):void
		{
			this._rotationY = Paling3D.useDEGREES ? rot * toRADIANS : rot;
			
			this._transformDirty = true;
		}
		
		/**
		 * Specifies the rotation around the Z axis from its original orientation.
		 */
		public function get rotationZ():Number
		{
			if( this._rotationDirty ) updateRotation();
			
			return Paling3D.useDEGREES ? this._rotationZ * toDEGREES : this._rotationZ;
		}
		
		public function set rotationZ( rot:Number ):void
		{
			this._rotationZ = Paling3D.useDEGREES ? rot * toRADIANS : rot;
			
			this._transformDirty = true;
		}
		
		// ___________________________________________________________________ S C A L E
		
		/**
		 * Sets the 3D scale as applied from the registration point of the object.
		 */
		public function get scale():Number
		{
			if( this._scaleX == this._scaleY && this._scaleX == this._scaleZ )
				if( Paling3D.usePERCENT ) return this._scaleX * 100;
				else return this._scaleX;
				else return NaN;
		}
		
		public function set scale( scale:Number ):void
		{
			if( this._rotationDirty ) updateRotation();
			
			
			if( Paling3D.usePERCENT ) scale /= 100;
			
			this._scaleX = this._scaleY = this._scaleZ = scale;
			
			this._transformDirty = true;
		}
		
		
		/**
		 * Sets the scale along the local X axis as applied from the registration point of the object.
		 */
		public function get scaleX():Number
		{
			if( Paling3D.usePERCENT ) return this._scaleX * 100;
			else return this._scaleX;
		}
		
		public function set scaleX( scale:Number ):void
		{
			if( this._rotationDirty ) updateRotation();
			
			if( Paling3D.usePERCENT ) this._scaleX = scale / 100;
			else this._scaleX = scale;
			
			 
			this._transformDirty = true;
		}
		
		/**
		 * Sets the scale along the local Y axis as applied from the registration point of the object.
		 */
		public function get scaleY():Number
		{
			if( Paling3D.usePERCENT ) return this._scaleY * 100;
			else return this._scaleY;
		}
		
		public function set scaleY( scale:Number ):void
		{
			if( this._rotationDirty ) updateRotation();
			
			if( Paling3D.usePERCENT ) this._scaleY = scale / 100;
			else this._scaleY = scale;
			
			this._transformDirty = true;
		}
		
		/**
		 * Sets the scale along the local Z axis as applied from the registration point of the object.
		 */
		public function get scaleZ():Number
		{
			if( Paling3D.usePERCENT ) return this._scaleZ * 100;
			else return this._scaleZ;
		}
		
		public function set scaleZ( scale:Number ):void
		{
			if( this._rotationDirty ) updateRotation();
			
			if( Paling3D.usePERCENT ) this._scaleZ = scale / 100;
			else this._scaleZ = scale;
			
			this._transformDirty = true;
		}
		
		
		
		
		/**
		 * The X coordinate of a object relative to the scene coordinate system.
		 */
		public function get sceneX():Number
		{
			return this.world._14;
		}
		
		/**
		 * The Y coordinate of a object relative to the scene coordinate system.
		 */
		public function get sceneY():Number
		{
			return this.world._24;
		}
		
		/**
		 * The Z coordinate of a object relative to the scene coordinate system.
		 */
		public function get sceneZ():Number
		{
			return this.world._34;
		}
		
		/**
		 * The default material for the object instance. Materials collect data about how objects appear when rendered.
		 */
		public function set material(material:Material):void
		{
			if(_material){
				//	_material.unregisterObject(this);
			}
			_material = material;
			if (_material){
				//	_material.registerObject(this);
				geometry.material=_material;
			}
		}
		
		public function get material():Material
		{
			return _material;
		}
		
		
		public function set autoCalcScreenCoords(autoCalculateScreenCoords:Boolean):void
		{
			_autoCalcScreenCoords = autoCalculateScreenCoords;
		}
		
		public function get autoCalcScreenCoords():Boolean
		{
			return _autoCalcScreenCoords ;
		}
		//=====================================================
		public function Object3D( name:String) {
			geometry=new Builder(null); 
			
			this.transform = Matrix4x4.IDENTITY;
			this.world     = Matrix4x4.IDENTITY;
			this.view      = Matrix4x4.IDENTITY;

			this.name = name;
			
			
			this.x =  0;
			this.y =  0;
			this.z =  0;
			
			rotationX = 0;
			rotationY = 0;
			rotationZ = 0;
			
			_localRotationX = _localRotationY = _localRotationZ = 0;
			
			var scaleDefault:Number = Paling3D.usePERCENT? 100 : 1;
			scaleX = scaleDefault;
			scaleY = scaleDefault;
			scaleZ = scaleDefault;
			_tempScale = new Vector3D();
			
			this.visible = true;
			
			this.id = _newID++;
			this.name = name || String( this.id );
			
			_numClones = 0;
			
			
			this._transformDirty  = false;
			this._rotationDirty  = false;
		}
		public function project(parent:Object3D, renderSessionData:RenderInfos):void
		{
			  if( this._rotationDirty ) updateRotation();
			  if( this._transformDirty ) updateTransform();
			
			  this.world.multiply4x4( parent.world, this.transform ); 
		 	  this.view.multiply4x4( parent.view, this.transform ); 
			 //whys 
			for each( var child:Object3D in this._childrenByName )
			{
				if( child.visible )
				{
					renderSessionData.addObject(child);
					child.project(this,renderSessionData);
				}
			}
			
		}
		public function transformVertices( transformation:Matrix4x4 ):void
		{
			geometry.transformVertices(transformation);
			
		} 
		public  function addGeometry(p: Geometry):void {
		//	if( geometry )
				geometry= p;
 
			 
		}
		
		public function set scene(p_scene:SceneObject3D):void
		{
			// set scene property
			_scene = p_scene;
			
			for each( var child:Object3D in this._childrenByName )
			{
				if(child.scene == null) child.scene = _scene;
			}
		}
		
		public function get scene():SceneObject3D
		{
			return _scene;
		}
		public override function addChild( child : Object3D, name:String=null ):Object3D
		{
			child = super.addChild( child, name );
			
			if( child.scene == null ) child.scene = scene;
			if( this.useOwnContainer){
				child.parentContainer = this;
			}
			return child;
		}
		protected function setParentContainer(parent:Object3D, assign:Boolean = true):void{
			
			if(assign && parent != this)
				parentContainer = parent;
			
			for each(var do3d:Object3D in children){
				
				do3d.setParentContainer(parent, assign);
			}
		}	
		 
		public function copyTransform( reference:* ):void
		{
			if(reference is Object3D)
			{
				var do3d:Object3D = Object3D(reference);
				if(do3d._transformDirty){
					do3d.updateTransform();
				}
			}
			
			var trans  :Matrix4x4 = this.transform;
			var matrix :Matrix4x4 = (reference is Object3D)? reference.transform : reference;
			
			trans._11 = matrix._11;		trans._12 = matrix._12;
			trans._13 = matrix._13;		trans._14 = matrix._14;
			
			trans._21 = matrix._21;		trans._22 = matrix._22;
			trans._23 = matrix._23;		trans._24 = matrix._24;
			
			trans._31 = matrix._31;		trans._32 = matrix._32;
			trans._33 = matrix._33;		trans._34 = matrix._34;
			
			this._transformDirty = false;
			this._rotationDirty  = true;
		}
		public function updateTransform():void
		{	
			_rot.setFromEuler(_rotationY, _rotationZ, _rotationX);
			
			// Rotation
			this.transform.copy3x3( _rot.matrix );
			
			// Scale
			_tempMatrix.reset(); 
			_tempMatrix._11 = this._scaleX;
			_tempMatrix._22 = this._scaleY;
			_tempMatrix._33 = this._scaleZ; 
			 this.transform.multiply4x4( this.transform, _tempMatrix );
			  
			_transformDirty = false;
		}
		
		// Update rotation values
		private function updateRotation():void
		{			
			_tempScale.x = Paling3D.usePERCENT ? _scaleX * 100 : _scaleX;
			_tempScale.y = Paling3D.usePERCENT ? _scaleY * 100 : _scaleY;
			_tempScale.z = Paling3D.usePERCENT ? _scaleZ * 100 : _scaleZ;
			
			_rotation = Matrix4x4.matrix2euler(this.transform, _rotation, _tempScale);
			
			this._rotationX = _rotation.x * toRADIANS;
			this._rotationY = _rotation.y * toRADIANS;
			this._rotationZ = _rotation.z * toRADIANS;
			
			this._rotationDirty = false;
		}

		public var parent :ObjectContainer3D;
		public var screen :Vector3D = new Vector3D();
		public var visible :Boolean=true;
		public var id :int;
		public var parentContainer		:Object3D;
		protected var _useOwnContainer	:Boolean = false;
		protected var _scene 			:SceneObject3D = null;
		public var flipLightDirection	:Boolean = false;
		protected var _transformDirty 	:Boolean = false; 
		
		
		/**
		 * pre-made Number3Ds and Matrix3Ds for use in the lookAt function
		 * and others
		 * 
		 */
		private	var _position 			:Vector3D = Vector3D.ZERO;
		private	var _lookatTarget   	:Vector3D = Vector3D.ZERO;
		private	var _zAxis 				:Vector3D = Vector3D.ZERO;
		private	var _xAxis 				:Vector3D = Vector3D.ZERO;
		private	var _yAxis 				:Vector3D = Vector3D.ZERO;
		private var _rotation			:Vector3D  = Vector3D.ZERO; 
		private var _rotationDirty  	:Boolean = false;
		private var _rotationX      	:Number;
		private var _rotationY     	 	:Number;
		private var _rotationZ      	:Number;
		private var _scaleX         	:Number;
		private var _scaleY         	:Number;
		private var _scaleZ         	:Number;
		private var _scaleDirty     	:Boolean = false;
		private var _tempScale			:Vector3D;
		private var _numClones			:uint	= 0;
		private var _material			:Material;
		private var _rot				:Quaternion = new Quaternion();
		
		private var _qPitch		:Quaternion = new Quaternion();
		private var _qYaw		:Quaternion = new Quaternion();
		private var _qRoll		:Quaternion = new Quaternion();
		
		private var _localRotationX	:Number = 0;
		private var _localRotationY	:Number = 0;
		private var _localRotationZ	:Number = 0;
		
		private var _autoCalcScreenCoords:Boolean = false;
		
		
		/**
		 * Relative directions.
		 */
		static private const FORWARD  	:Vector3D = new Vector3D(  0,  0,  1 );
		static private const BACKWARD 	:Vector3D = new Vector3D(  0,  0, -1 );
		static private const LEFT     	:Vector3D = new Vector3D( -1,  0,  0 );
		static private const RIGHT    	:Vector3D = new Vector3D(  1,  0,  0 );
		static private const UP       	:Vector3D = new Vector3D(  0,  1,  0 );
		static private const DOWN     	:Vector3D = new Vector3D(  0, -1,  0 );
		
		private static var _tempMatrix	:Matrix4x4 = Matrix4x4.IDENTITY; 
		private static var _tempQuat	:Quaternion = new Quaternion(); 
		private static var _newID		:int = 0;
		private static var toDEGREES 	:Number = 180/Math.PI;
		private static var toRADIANS 	:Number = Math.PI/180;
		private static var entry_count	:uint = 0;
		
	}
}