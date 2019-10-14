package org.paling3d.controller
{ 
	
	import org.paling3d.geom.Point3D;
	import org.paling3d.geom.Vertex;
	import org.paling3d.math.Matrix4x4;
	import org.paling3d.math.Vector3D;
	import org.paling3d.objects.Object3D;
	import org.paling3d.objects.special.Skin3D;
	import org.paling3d.primitives.Geometry;
	 
	
	public class SkinController implements IObjectController
	{
		/** */
		public var poseMatrix:Matrix4x4;
		
		/** */
		public var bindShapeMatrix:Matrix4x4;
		
		/** */
		public var target:Skin3D;
		
		/** */
		public var joints:Array;
		
		/** */
		public var invBindMatrices:Array;
		
		/** */
		public var vertexWeights:Array;
		
		/** */
		public var input : MorphController;
		
		/**
		 * Constructor.
		 * 
		 * @param	target
		 */ 
		public function SkinController(target:Skin3D)
		{
			this.target = target;
			this.joints = new Array();
			this.invBindMatrices = new Array();
			this.vertexWeights = new Array();
		}
		
		/**
		 * Update.
		 */ 
		public function update():void
		{   
			if(!joints.length || !bindShapeMatrix)
				return;
			
			if(!_cached)
				cacheVertices();
			
			if(invBindMatrices.length != this.joints.length)
				return;
			
			var vertices:Vector.<Point3D> = target.geometry.points;
			var i:int;
			
			// reset mesh's vertices to 0
			for(i = 0; i < vertices.length; i++)
				vertices[i].x = vertices[i].y = vertices[i].z = 0;
			
			// skin the mesh!
			for(i = 0; i < joints.length; i++)
				skinMesh(joints[i], this.vertexWeights[i], invBindMatrices[i], _cached, vertices);
		}
		
		/**
		 * Cache original vertices.
		 */
		private function cacheVertices():void
		{
			this.target.transformVertices(this.bindShapeMatrix);
			this.target.geometry.ready = true;
			
			var vertices:Vector.<Point3D> = this.target.geometry.points;
			
			_cached = new Array(vertices.length);
			
			for(var i:int = 0; i < vertices.length; i++)
				_cached[i] = new Vector3D(vertices[i].x, vertices[i].y, vertices[i].z);
		}
		
		/**
		 * Skins a mesh.
		 * 
		 * @param	joint
		 * @param	meshVerts
		 * @param	skinnedVerts
		 */
		private function skinMesh(joint:Object3D, weights:Array, inverseBindMatrix:Matrix4x4, meshVerts:Array, skinnedVerts:Vector.<Point3D>):void
		{
			var i:int;
			var pos:Vector3D = new Vector3D();
			var original:Vector3D;
			var skinned:Point3D;
	 
			var matrix:Matrix4x4 = Matrix4x4.multiply(joint.world, inverseBindMatrix);//world
			
			for( i = 0; i < weights.length; i++ )
			{
				var weight:Number = weights[i].weight;
				var vertexIndex:int = weights[i].vertexIndex;
				
				if( weight <= 0.0001 || weight >= 1.0001) continue;
				
				original = meshVerts[ vertexIndex ];	
				skinned = skinnedVerts[ vertexIndex ];
				
				pos.x = original.x;
				pos.y = original.y;
				pos.z = original.z;
				
				// joint transform
				Matrix4x4.multiplyVector(matrix, pos);	
				
				//update the vertex
				skinned.x += (pos.x * weight);
				skinned.y += (pos.y * weight);
				skinned.z += (pos.z * weight);
			}
		}
		
		private var _cached:Array;
	}
}