package org.paling3d.utils.reader 
{
	import org.paling3d.materials.Texture;

	/**
	 * @author Administrator
	 */
	public class AbstractModelReaderTexture 
	{

		public var file : String;
		public var  texture : Texture;

		public function AbstractModelReaderTexture(file : String, texture : Texture ) : void
		{
			 
			this.file=file;
			this.texture=texture;
		}
		//					me.textures.set(name, { file : filename, texture : new h3d.material.Texture() });
		 
	}
}
