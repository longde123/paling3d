package org.paling3d.objects.parsers
{
	import flash.utils.Dictionary;
	import flash.xml.XMLNode;
	
	import org.paling3d.math.Matrix4x4;
	import org.paling3d.objects.Object3D;
	import org.paling3d.math.Vector3D;
	import org.paling3d.materials.BitmapMaterial;
	import org.paling3d.materials.Color;
	import org.paling3d.materials.ColorMaterial;
	import org.paling3d.materials.Material;
	import org.paling3d.materials.Texture;
	import org.paling3d.geom.UV;
	import org.paling3d.primitives.Builder;
	import org.paling3d.primitives.Geometry;
	import org.paling3d.utils.reader.AbstractModelReader;
	import org.paling3d.utils.reader.AbstractModelReaderTexture;
	import org.paling3d.utils.StringTools;

	/**
	 * 
	 * @author Administrator
	 * 
	 */
	public class Collada extends AbstractModelReader 
	{

		public function Collada(url : String) 
		{
			super(url);
		}
		public function parseColor( s : String ) : Color 
		{
			var a : Array = s.split(" ");
			if( a.length != 4 ) throw new Error("Invalid color '" + s + "'");
			return new  Color(Number(a[0]), Number(a[1]), Number(a[2]), Number(a[3]));
		}

		public function parseMatrix( s : String ) :Matrix4x4
		{
			s=StringTools.trim(s)
			var f : Array = s.split(/[ \r\n\t]+/g);
			if( f.length != 16 )  throw new Error("Invalid matrix '" + s + "'");
			var a :Vector.<Number> = new  Vector.<Number>(16);
			for(var i : int = 0;i < 16;i++ )
			a[i] = Number(f[i]);
			var m:Matrix4x4 = new  Matrix4x4();
			m._11 = a[0]; 
			m._21 = a[1]; 
			m._31 = a[2]; 
			m._41 = a[3];
			m._12 = a[4]; 
			m._22 = a[5]; 
			m._32 = a[6]; 
			m._42 = a[7];
			m._13 = a[8]; 
			m._23 = a[9]; 
			m._33 = a[10]; 
			m._43 = a[11];
			m._14 = a[12]; 
			m._24 = a[13]; 
			m._34 = a[14]; 
			m._44 = a[15];
			return m;
		}

		public function resolve( id : String, h : Dictionary ) : * 
		{
			var elt : * = h[id];
			if( elt == null )
			throw new Error("Element not found '" + id + "'");
			return elt;
		}

		public function buildVertex( vdata : Array ) : Vector.<Vector3D>
		{
			var i :int= 0;
			var max:int = int(vdata.length / 3);
			var vl : Vector.<Vector3D> = new  Vector.<Vector3D>();
			for(var p : int = 0;p < max;p++ )
			vl[p] = new  Vector3D(vdata[i++], vdata[i++], vdata[i++]);
			return vl;
		}

		public function loadXML( doc : XML ) :void
		{
		 
			// Get up axis
			 
			var x : XML =  doc;
		// load textures
			for each(var i:XML in x.library_images.image ) 
			{
				 
			  
				var file :String=String( i.init_from);
		 
			 	var textures_id:String=String(i[0].@id)
				textures[textures_id] = new AbstractModelReaderTexture(file, new Texture());
			}
			// load material effects
			var matfx : Dictionary = new Dictionary();
			for each(var e:XML in x.library_effects.effect ) 
			{ 
				var profile:XMLList = e.profile_COMMON;
				// prepare <newparam/>
				var params : Dictionary = new Dictionary();
				for each(var p:* in profile.newparam ) 
				{
					var key :String;
					if( p.surface.length() != 0 )
					{
						key =String( p.surface.init_from);
					}
					else if( p.sampler2D.length() != 0 )
					{
						key =String( p.sampler2D.source);
					}
					else
					{
						key = null;
					} 
					var psid:String= String(p[0].@sid)
					params[psid] =String( key);
				}
				// parse phong
				var tech :XMLList= profile.technique;
				var phong :XMLList = tech.phong;
				var ambient:Color = parseColor(phong.ambient.color);
				var dif :XMLList = phong.diffuse;
				var mat : Material;
				
				
		 
				if( dif .texture.length() != 0) 
				{
					 
					var sampler :String= String(dif.texture[0].@texture);
					sampler=resolve(sampler, params)
					var img :String = resolve(sampler, params);
					var sub:ColorMaterial = new ColorMaterial(new Color(0, 0, 0, 1), ambient);
					var img_textures: Texture = resolve(img, textures).texture
					mat = new BitmapMaterial(sub,img_textures);
				} else if( dif.color ) 
				{
					var col: Color = parseColor(dif.color);
					mat = new ColorMaterial(ambient, col);
				} else
				throw new Error("Unknown diffuse parameters for effect " + e[0].@id);
				matfx["#" + e[0].@id] = mat;
			}
		// load materials
			for each(var m_library_materials:XML in x.library_materials.material ) 
			{
				var fxs :XMLList= m_library_materials.instance_effect;
			 
				if( fxs.length() != 1 ) 
				{
					throw new Error("Multiple-effect materials are not supported");	
				}
				var fxs_id:String=String(fxs[0].@url);
				var mat_library_materials :*= resolve(fxs_id, matfx);
				var m_id:String=String(m_library_materials[0].@id);
				materials[m_id] = mat_library_materials;
			}
			//end load materials
			// load geometries
			var geometries : Dictionary = new Dictionary();
			for each(var g:XML in x.library_geometries.geometry ) 
			{
					var mesh:XMLList = g.mesh;
					// sources
					var sources:Dictionary  = new Dictionary();
					for each(var  s_mesh:XML in mesh.source ) 
					{
						var floats :Array= String(s_mesh.float_array).split(" ");
						var floats_a:Array = new Array();
						for(  var floats_i:int= 0; floats_i<floats.length; floats_i++ )
							floats_a[ floats_i] =  floats[ floats_i] ;
						sources["#"+s_mesh[0].@id]=floats_a;
					}
					// vertices
					var vertices :Dictionary= new Dictionary();
					for each(var v :XML in mesh.vertices ) 
					{
						var v_input_id:String=String(v.input[0].@source)
						var vdata:Array = resolve(v_input_id,sources);
						vertices["#"+v[0].@id]=buildVertex(vdata);
					}
					// geometry
					var tri:XMLList = mesh.triangles;
					if( tri.length() != 1 ) throw new Error("Mesh '"+g.att.id+"' does not have triangles");
					var triangles:XML = tri[0]//.first();
					var voffset:int = 0, noffset:int = 0, toffset:int = 0;
				var vinf: Vector.<Vector3D> = null, ninf: Vector.<Vector3D> = null, tinf:  Vector.<UV>= null, stride:int = 0;
				for each( var s_triangles:XML in triangles.input ) 
				{
					var off:int = int(s_triangles[0].@offset);
					var s_source:String=String(s_triangles[0].@source)
					var s_semantic:String= String( s_triangles[0].@semantic)
					switch( s_semantic) 
					{
						case "VERTEX":
							vinf = resolve(s_source,vertices);
							voffset = off;
							break;
						case "NORMAL":
							ninf = buildVertex(resolve(s_source,sources));
							noffset = off;
							break;
						case "TEXCOORD":
							var tdata:Array = resolve(s_source,sources);
							var tdata_i:int = 0;
							var tmax :int= tdata.length >> 1;
							tinf = new  Vector.<UV>();
							
							 for(var _p :int= 0;_p<tmax;_p++ )
							 {
								 var _u:Number =Number( tdata[tdata_i++]); 
								 var _v:Number= Number( tdata[tdata_i++]);
								 tinf[_p] =  new  UV(_u ,_v  );
								 
							 }
							toffset = off;
							break;
						default: // SKIP
					}
					stride++;
				}
				if( vinf == null || ninf == null )
					throw new Error("Mesh '"+g[0].@id+"' is either missing vertex or normals");
				// parse indexes
				var indexes :Vector.<int>= new  Vector.<int>();
				var idx:Array = String(triangles.p).split(" ");
				for(var _i:int= 0;_i<idx.length;_i++ )
					indexes[_i] = int(idx[_i]);
				// build primitive
				var att_material:String=String(triangles[0].@material)
				var pmat : Material = resolve(att_material,materials);
				var pBuilder:Builder = new  Builder(pmat);
				pBuilder.init(vinf,ninf,tinf);
				geometries["#"+g[0].@id]=pBuilder;
				// fill triangles
				var pos:int = 0;
				var max:int = indexes.length;
				var dstride:int = stride * 2;
				var hasUV:Boolean = (tinf != null);
				while( pos < max ) {
					pBuilder.addTriangle(
						indexes[pos + voffset],
						indexes[pos + stride + voffset],
						indexes[pos + dstride + voffset],
						indexes[pos + noffset],
						indexes[pos + stride + noffset],
						indexes[pos + dstride + noffset],
						hasUV ? indexes[pos + toffset] : 0,
						hasUV ? indexes[pos + stride + toffset] : 0,
						hasUV ? indexes[pos + dstride + toffset] : 0
					);
					pos += stride + dstride;
				}
				pBuilder.done();
			}
			//end load geometries
			
			
			
			//这里来动画吧  我插一句
			
			
			
			
			
			
			// load objects
			 
			var visual_scene:XMLList=x.library_visual_scenes.visual_scene
			for each(var scene:XML  in visual_scene)
			{
				for each(var o:XML  in scene.node ) 
				{
					if(String( o.instance_geometry)!=""     )
					{
						var o_att_name:String=String(o[0].@name)
						var obj :Object3D= new Object3D(o_att_name);
						objects[o_att_name]=obj;
						//try {
							var o_node_matrix:String=String(o.matrix)
							obj.transform = parseMatrix(o_node_matrix)
					//	} catch(e:*) {}
						 
						var att_url:String=String(o.instance_geometry[0].@url); 
						
						var att_resolve:Geometry=resolve(att_url,geometries) 
						 
						obj.addGeometry( att_resolve);
				
					}
				 
				}
			}
			//end load objects
		}
		 
		
	}
}