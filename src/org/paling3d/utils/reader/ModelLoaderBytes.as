package org.paling3d.utils.reader 
{
	import flash.net.URLLoader; 
	import flash.utils.Dictionary;

	/**
	 * @author Administrator
	 */
	public class ModelLoaderBytes 
	{
		private static var dic : Dictionary=new Dictionary();
		public var  url : String;
		public var  bytes : Boolean;
		public var  callb : Function;
		public function ModelLoaderBytes(url : String, bytes : Boolean, callb : Function):void
		{
			 
			this.url=url
			this.bytes=bytes
			this.callb=callb;	
		}
		public static function getBytes( url : String) : URLLoader
		{
			return dic[url]!=null?dic[url]:null; 
		}

		public static function setBytes(url : String,data : URLLoader) : void
		{
			dic[url] = data;
		}
	}
}
