package org.paling3d.geom {
	import org.paling3d.math.Matrix4x4;
	import org.paling3d.objects.Object3D;
	import org.paling3d.view.Viewport3D;

	public class RenderInfos {
		public var display :  Viewport3D;
		public var vertexes : Vector.<Number>;
		public var lightning : Vector.<Number>;
		public var uvcoords : Vector.<Number>;
		public var colors : Vector.<Number>;
		public var indexes : Vector.<int>;
		public var triangles : Vector.<Triangle>;
		public var objects : Vector.<Object3D>;
		public var camera:Matrix4x4;//Sound3D use
		public function RenderInfos(display : Viewport3D) {
			this.display = display;
			objects= new Vector.<Object3D>();
		}
		public function addObject(o : Object3D) : void {
			this.objects.push(o);
		} 
		public function removeObject(o : Object3D) : Boolean {
			
			var index:int= this.objects.indexOf(o);
			
			if(index!=-1) {
				this.objects.splice(index,1);
				return true;
			}
			else  return false;
			
		}
	}
}