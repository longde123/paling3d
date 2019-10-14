package org.paling3d.objects.special
{
	import org.paling3d.geom.RenderInfos;
	import org.paling3d.objects.Object3D;
	import org.paling3d.objects.TriangleMesh3D;

	public class Skin3D extends TriangleMesh3D
	{
		public function Skin3D(name:String)
		{
			super(name);
		}
		public override function project(parent:Object3D, renderSessionData:RenderInfos):void
		{
			// skins are already transformed into world-space by the skinning algorithm!
			// so we need to set its #transform to the parent#transform and invert...
			 this.transform.copy(parent.world);
			  this.transform.invert(); 
			return super.project(parent, renderSessionData );
		}
	}
		 
}