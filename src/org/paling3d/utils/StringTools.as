package org.paling3d.utils
{
	public class StringTools
	{
		public function StringTools()
		{
		}
		static public function ltrim(char:String):String{
			if(char==null){
				return null;
			}
			var pattern:RegExp=/^[\s]+/;
			return char.replace(pattern,"");
		}
		
		static public function rtrim(char:String):String{
			if(char==null){
				return null;
			}
			var pattern:RegExp=/^[\s|\r]+$/;
			return char.replace(pattern,"");
		} 
		static public function trim(char:String):String
		{
			if(char==null){
				return null;
			}
			return trimEnter(rtrim(ltrim(char)));
		}
		//取掉字符串的前后回车
		public static function trimEnter(returnString:String):String {
			for (; returnString.substr(0, 1) == String.fromCharCode(13); returnString=returnString.substr(1)) {
			}
			for (; returnString.substr(returnString.length-1, 1) == String.fromCharCode(13); returnString=returnString.substr(0, returnString.length-1)) {
			}
			return returnString;
		}
		 
		
	}
}