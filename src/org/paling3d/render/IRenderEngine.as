package org.paling3d.render
{
	import org.paling3d.cameras.Camera3D;
	import org.paling3d.objects.SceneObject3D;
	import org.paling3d.view.Viewport3D;

	public interface IRenderEngine
	{
		  function render() : void; 
		  function renderScene(scene:SceneObject3D, camera:Camera3D, viewPort:Viewport3D):void;
		  function beginRender(): void;
		  function renderObjects(): void;
		  function finishRender(): void; 
	}
}