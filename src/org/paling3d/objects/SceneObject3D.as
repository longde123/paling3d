package org.paling3d.objects
{
	import org.paling3d.geom.RenderInfos;

	public class SceneObject3D extends Object3D
	{
		public function SceneObject3D(name:String)
		{
			super(name);
		}
		override public function project(parent:Object3D, renderSessionData:RenderInfos):void
		{
	 
			for each( var child:Object3D in this._childrenByName )
			{
				if( child.visible )
				{
					renderSessionData.addObject(child);
					child.project(this,renderSessionData);
				}
			}
		}
	}
}