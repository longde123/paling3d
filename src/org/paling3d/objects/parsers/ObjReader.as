package org.paling3d.objects.parsers
{
	import flash.utils.ByteArray;
	
	import org.paling3d.objects.Object3D;
	import org.paling3d.math.Vector3D;
	import org.paling3d.materials.BitmapMaterial;
	import org.paling3d.materials.Color;
	import org.paling3d.materials.ColorMaterial;
	import org.paling3d.materials.Material;
	import org.paling3d.materials.Texture;
	import org.paling3d.geom.UV;
	import org.paling3d.primitives.Builder;
	import org.paling3d.utils.reader.AbstractModelReader;
	import org.paling3d.utils.reader.AbstractModelReaderTexture;
	import org.paling3d.utils.reader.ModelLoader;
	import org.paling3d.utils.StringTools;

	public class ObjReader extends AbstractModelReader
	{

		public var texturesOk : Boolean;
		public var modelsOk : Boolean;

		/** original .obj file **/
		public var doc : String;

		public var objectList : Vector.<TMaterialName> = new Vector.<TMaterialName>();
		public var points : Vector.<Vector3D>;
		public var normals : Vector.<Vector3D>;
		public var uvs : Vector.<UV>;

		public var builder : Builder; 

		public function ObjReader(url : String) 
		{
			super(url);
			
			objectList = new Vector.<TMaterialName>;
			points = new Vector.<Vector3D>();
			normals = new Vector.<Vector3D>();
			uvs = new Vector.<UV>();
		}

		public override function parse(data :ByteArray) :void
		{
			var me : ObjReader = this;
			data.position = 0;
			doc = data.readUTFBytes(data.length);
 
			var i:int = doc.indexOf("mtllib");
			if(i < 0) 
			{
				me.texturesOk = true;
				me.parseModels();
			} 
			else 
			{
				var end:int = doc.indexOf(".mtl");
				if(end < 0) return;
				i += 7;
				end += 4;
				var mtlUrl :String= basepath + "/" + doc.substr(i, end - i);
				var loader :ModelLoader= new ModelLoader();
				loader.add(mtlUrl, true, parseMtl);
				// 			loader.onError = contLoad;
				loader.start();
			}
		}
 
		private function  finalize(name: String,ambient: Color,diffuse: Color ,filename: String,mode: int,alpha: Number) : void 
		{
			var me : ObjReader = this;
			if(name == null) return;
			var mat : Material;
				
			if(ambient == null)
					ambient = new Color(0, 0, 0, 1.0);
			if(diffuse == null)
					diffuse = new Color(0, 0, 0, 1.0);
			if(filename != null) 
			{
				me.textures[name] = new AbstractModelReaderTexture(filename, new Texture()) ;
				var sub : ColorMaterial = new  ColorMaterial(ambient, diffuse);
				mat = new BitmapMaterial(sub, AbstractModelReaderTexture(me.textures[name]).texture);
			} 
			else 
			{
				mat = new ColorMaterial(ambient, diffuse);
			}
			me.materials[name] = mat;
			name = null;
			filename = null;
			ambient = null;
			mode = 0;
			alpha = 1.0;
		}

		private function mkColor(f : Array ) : Color
		{
			var r : Number = Number(f[1]);
			var g : Number = (f[2] == null) ? r : Number(f[2]);
			var b : Number = (f[3] == null) ? r : Number(f[3]);
			var a : Number = (f[4] == null) ? 1.0 : Number(f[4]);
			return new Color(r, g, b, a);
		}

		private function parseMtl( data : ByteArray) : void 
		{
			var me : ObjReader = this;
		 
			
			data.position = 0;
			var parts : Array = data.readUTFBytes(data.length).split("\n");
			var name : String = null;
			var filename : String = null;
			var ambient : Color = null;
			var diffuse : Color = null;
			var mode : int = 0;
			var alpha : Number = 1.0;
			
			
		
			for each(var s :String in parts) 
			{
				 s=StringTools.trim(s);
				var f : Array =s.split( /[\s]+/g);
				if(f==null)continue;
				switch (f[0])
				{
					case "newmtl":
						 
						finalize(name, ambient, diffuse, filename, mode, alpha); 
						name = f[1];
						break;
					case "Ns": // specular exponent (usually 0-1000)
						break;
					case "Ka": 
						// ambient reflectivity r g b
						ambient = mkColor(f);
						break;
					case "Kd": 
						// diffuse reflectivity r g b
						diffuse = mkColor(f);
						break;
					case "Ks": // specifies the specular reflectivity using RGB values
						break;
					case "Ni": // Specifies the optical density for the surface.  This is also known as index of refraction.
					// 1.0 == no bend
						break;
					case "d": 
						// Specifies the dissolve for the current material (alpha)
						alpha = Number(f[1]);
						break;
					case "illum":
						// 				0		Color on and Ambient off
						// 				1		Color on and Ambient on
						// 				2		Highlight on
						// 				3		Reflection on and Ray trace on
						// 				4		Transparency: Glass on
						//				Several more
						mode = int(f[1]);
						break;
					case "map_Kd":
						filename = f[1];
						break;
				}
			}
			finalize(name, ambient, diffuse, filename, mode, alpha);
			loadTextures();
			parseModels();
		}

		private function closePrimitive(container : Object3D ,hasPrims:Boolean) : Boolean 
		{
			var me :ObjReader= this;
			if(me.builder != null) 
			{
				var b:Builder = me.endMesh();
				if(b != null) 
				{
					container.addGeometry(b);
					hasPrims = true;
					return true;
				}
			}
			return false;
		}

		private function  mkVector(f:Array) : Vector3D  
		{
			return new  Vector3D(Number(f[1]), Number(f[2]), Number(f[3]));
		}

		private function parseModels() :void
		{
			var me :ObjReader= this;
 
			var parts :Array= doc.split("\n");
			var container : Object3D = new Object3D("default");
			objects["default"]=container;
			var hasPrims:Boolean = false;
			var currentMaterialName:String = "";
			var switchPrim:Boolean = false;
			builder = null;
			 
			
 
			
			for(var i : int = 0;i < parts.length;i++) 
			{
				var s:String =StringTools.trim( parts[i]);
				 
				var f :Array= s.split(/[\s]+/g);
				if(f==null)continue;
			 
				switch(f[0]) 
				{
					case "mtllib": // material library, handled above
						break;
					case "v": 
						// vertices
						switchPrim = true;
						points.push(mkVector(f));
						break;
					case "vt": 
						// texture vertices
						switchPrim = true;
						uvs.push(new UV(Number(f[1]), (f[2] == null) ? 0.0 : Number(f[2])));
						break;
					case "vn": 
						// vertex normals i, j, k
						switchPrim = true;
						normals.push(mkVector(f));
						break;
					case "g": 
						// group name
						 if(f.length != 2)
						 {
							 throw new Error("Not able to parse multiple groupnames");
						 }
						var groupname :String= (f[1] == null) ? "default" : f[1];
						closePrimitive(container, hasPrims);
						if(!hasPrims || container.name == groupname) 
						{
							container.name = groupname;
						} 
						else 
						{ 
							// new group
							container = new Object3D(groupname);
							if(objects[groupname])
								throw new Error("Object named " + groupname + " already exists");
							objects[groupname]=container;
						}
						break;
					case "s": 
						// smoothing group
						switchPrim = true;
						break;
					case "usemtl": 
						// material name
						switchPrim = true;
						currentMaterialName = f[1];
						break;
					case "f": 
						// face f -4 -3 -2 -1 or f 1 2 3 4 or f v1/[vt1]/[vn1] v2/vt2/vn2   v3/vt3/vn3
						if((switchPrim && closePrimitive(container, hasPrims)) || builder == null)
							startMesh(currentMaterialName);
						switchPrim = false;
					
						var spec0:Array = f[1].split("/");
						var spec1:Array = f[2].split("/");
						var spec2:Array = f[3].split("/");
						var spec3:Array = (f[4] == null) ? [] : f[4].split("/");
						var v0:int = getIndex(spec0[0], points, true);
						var v1:int = getIndex(spec1[0], points, true);
						var v2:int = getIndex(spec2[0], points, true);
						var v3:int = getIndex(spec3[0], points, true);
						var uv0:int = getIndex(spec0[1], uvs, false);
						var uv1:int = getIndex(spec1[1], uvs, false);
						var uv2:int = getIndex(spec2[1], uvs, false);
						var uv3:int = getIndex(spec3[1], uvs, false);
						var n0:int = getIndex(spec0[2], normals, false);
						var n1:int = getIndex(spec1[2], normals, false);
						var n2:int = getIndex(spec2[2], normals, false);
						var n3:int = getIndex(spec3[2], normals, false);
						
						var added :int= -1;
						if(n0 == 0 || n1 == 0 || n2 == 0)
							added = builder.createNormal(v0, v1, v2);
						n0 = (n0 == 0) ? added : n0;
						n1 = (n1 == 0) ? added : n1;
						n3 = (n3 == 0) ? added : n3;
						
						
						if(f[4] == null) 
						{ 
							//f v1/[vt1]/[vn1] v2/vt2/vn2 v3/vt3/vn3
							builder.addTriangle(v0, v1, v2, n0, n1, n2, defUv(uv0, 0), defUv(uv1, 1), defUv(uv2, 2));
						} 
						else 
						{ 
							// f 1 2 3 4
							if(n3 == -1)
								n3 = builder.createNormal(v1, v2, v3);
							builder.addTriangle(v0, v1, v3, n0, n1, n3, defUv(uv0, 0), defUv(uv1, 1), defUv(uv3, 2));
							builder.addTriangle(v1, v2, v3, n1, n2, n3, defUv(uv1, 0), defUv(uv2, 1), defUv(uv3, 2));
						}
						break;
				}
			}
			closePrimitive(container, hasPrims);
			modelsOk = true;
			completeTest();
		}

		private function defUv(u : int, i : int) : int 
		{
			return (u == 0) ? i : u;
		}

		private function getIndex(s : String, a:* ,  noNull :Boolean= true) : int
		{
			var v : int = int(s);
			if(v == 0) return noNull  ? 0 : 0;
													
			if(v < 0) return a.length + v;
													
			return v - 1;
		}

		override public function onTexturesLoaded() : void 
		{
			texturesOk = true;
			completeTest();
		}

		private function completeTest() : void 
		{
			if(texturesOk && modelsOk)
				onComplete();
		}

		private function startMesh(materialName : String) : void 
		{
			if(uvs.length == 0)
				uvs.push(new UV(0.0, 1.0));
			if(uvs.length == 1)
				uvs.push(new UV(0.5, 0.0));
			if(uvs.length == 2)
				uvs.push(new UV(1.0, 1.0));
			
			builder = new Builder(materials[materialName]);
			builder.init(points, normals, uvs);
		}

		private function endMesh() : Builder 
		{
			if(builder != null) 
			{
				builder.done();
				var b :Builder= builder;
				builder = null;
				return b;
			}
			return null;
		}
	}
} 
class TMaterialName 
{
	public var obj : Object;
	public var   materialName : String;
}