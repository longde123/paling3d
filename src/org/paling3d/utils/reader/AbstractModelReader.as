package org.paling3d.utils.reader 
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.paling3d.objects.Object3D;
	import org.paling3d.materials.Material;

	public class AbstractModelReader  extends EventDispatcher
	{

		public var materials : Dictionary;
		public var textures : Dictionary;
		public var objects : Dictionary;

		public var basepath : String;

		public function AbstractModelReader(url : String) 
		{
			materials = new Dictionary;
			textures = new  Dictionary();
			objects = new Dictionary();
			
			var r : RegExp = /[\\\/]/g;
			var upath : Array = url.split(r);
			upath.pop();
			basepath = upath.join("/");
		}

		public function parse( data : ByteArray ) : void
		{
		}

		public function loadTextures() : void 
		{
			var r : RegExp = /[\\\/]/g; 
			var loader : ModelLoader = new ModelLoader();
			for each( var t:AbstractModelReaderTexture in textures ) 
			{
				var tpath : Array = t.file.split(r);;
				var file : String = basepath + "/" + tpath.pop();
				loader.loadTexture(file, t.texture);
			}
			loader.onLoaded = onTexturesLoaded;
			loader.onError = onTexturesError;
			loader.start();
		}

		public function onTexturesLoaded() : void 
		{
		}

		private function onTexturesError(url : String, msg : String ) : void 
		{
			throw "Error while loading " + url + " (" + msg + ")";
		}

		public   var onComplete  : Function ;
	}
}