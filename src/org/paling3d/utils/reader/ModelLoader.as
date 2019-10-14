package org.paling3d.utils.reader
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.paling3d.materials.Texture;
	import org.paling3d.objects.parsers.Collada;
	import org.paling3d.objects.parsers.ObjReader;

	public class ModelLoader
	{

		public var cur : Loader;
		public var bytes : URLLoader;
		public var queue : Vector.<ModelLoaderBytes>;

		public function ModelLoader() 
		{
			queue = new Vector.<ModelLoaderBytes>();
			 
		}

		/**
		Adds a url to load.
		@param url The url to the resource
		@param bytes Set to true for a Bytes resource, false for DisplayObject resource
		@param callb
		 **/
		public function add(url : String, bytes : Boolean, callb : Function) : void 
		{
			queue.push(new ModelLoaderBytes( url,   bytes ,callb ));
		}

		public function loadTexture( file : String, t : Texture ) : void
		{
			var me : ModelLoader = this;
			add(file, false, function(obj : *):void 
			{
				var bdata : Bitmap = (obj as Bitmap);
				if( bdata == null )
					me.onError(file, "Not a bitmap");
				else
					t.bitmap = bdata.bitmapData;
			});
		}
 
		public function loadCollada( url : String, completeHandler : Function ) : Collada 
		{
			var me :ModelLoader= this;
			if(completeHandler != null)
				onLoaded = completeHandler;
			var col : Collada = new  Collada(url);
			add(url, true, function(data : ByteArray):void 
			{
				data.position = 0;
				var x : XML = XML(data.readUTFBytes(data.length));
				col.loadXML(x);
				// load texture relative to the DAE url
				var r : RegExp =new RegExp( /[\\\/]/g);
	 
				var upath : Array = url.split(r);
			 
				upath.pop();
				var path:String = upath.join("/");
				for each(var t:AbstractModelReaderTexture  in col.textures ) 
				{
					var tpath : Array = String(t.file).split( /[\\\/]/g);
					var file : String = path + "/" + tpath.pop();
					me.loadTexture(file, t.texture);
				}
			});
			return col;
		}

		public function loadObj( url : String, completeHandler : Function ) : ObjReader
		{
			var me  :ModelLoader= this;
			var obj : ObjReader = new  ObjReader(url);
			if(completeHandler != null)
				obj.onComplete = completeHandler;
			add(url, true, obj.parse);
			return obj;
		}
	 

		public function start() : void
		{
			var me : ModelLoader = this;
			var e : ModelLoaderBytes = queue.shift();
			cur = null;
			bytes = null;
			if( e == null ) 
			{
				onLoaded();
				return;
			}
			var data:URLLoader = ModelLoaderBytes.getBytes(e.url);
			if( data != null ) 
			{
				if( e.bytes ) 
				{
					e.callb(data.data);
					start();
				} 
				else 
				{
					cur = new flash.display.Loader();
					cur.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(...arg):void 
					{
						e.callb(me.cur.content);
						me.start();
					});
					cur.loadBytes(data.data);
				}
				return;
			}
			
			if( e.bytes ) 
			{
		 
				bytes = new  URLLoader(new URLRequest(e.url));
				bytes.dataFormat = flash.net.URLLoaderDataFormat.BINARY;
				bytes.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(err : flash.events.IOErrorEvent):void 
				{ 
					me.onError(e.url, err.text);
				});
				bytes.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, function(err : flash.events.SecurityErrorEvent):void 
				{ 
					me.onError(e.url, err.text);
				});
				bytes.addEventListener(flash.events.Event.COMPLETE, function(..._):void 
				{
					e.callb(me.bytes.data);
					me.start();
				});
			} 
			else 
			{
				cur = new flash.display.Loader();
				cur.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(err : flash.events.IOErrorEvent):void 
				{ 
					me.onError(e.url, err.text);
				});
				cur.contentLoaderInfo.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, function(err : flash.events.SecurityErrorEvent):void 
				{ 
					me.onError(e.url, err.text);
				});
				cur.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(..._) :void 
				{
					e.callb(me.cur.content);
					me.start();
				});
				cur.load(new flash.net.URLRequest(e.url));
			}
		}

		public var  onError :Function=__onError;
		
		private function __onError( url : String, msg : String ) :void
		{
			throw new Error("Error while loading " + url + " (" + msg + ")");
		}
		private   function __onLoaded():void {
		}
		public var  onLoaded  :Function=__onLoaded;
	 
	}
}