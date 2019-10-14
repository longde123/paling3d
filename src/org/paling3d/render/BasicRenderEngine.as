package org.paling3d.render
{ 
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.utils.getTimer;
	
	import org.paling3d.cameras.Camera3D;
	import org.paling3d.geom.*;
	import org.paling3d.lights.*;
	import org.paling3d.materials.*;
	import org.paling3d.math.Matrix4x4;
	import org.paling3d.math.Vector3D;
	import org.paling3d.objects.Object3D;
	import org.paling3d.objects.SceneObject3D;
	import org.paling3d.primitives.*;
	import org.paling3d.view.Viewport3D;

	public class BasicRenderEngine implements IRenderEngine
	{ 
		private const DEGS_TO_RADIANS:Number = Math.PI / 180;
		public var camera : Camera3D;
		public var display  : Viewport3D;
		public var axisSize : Number;
		public var stats :  Stats;
		public var fog : Color;
		private var plights : Vector.<LightInst>;
		private var dlights :Vector.<LightInst>;
		private var objects : Vector.<Object3D>;
		private var r : RenderInfos;
		private var tmp :  Vector3D;
		private var scene:SceneObject3D;
		
		 
			// Prepare a shader for rendering
		
		public function BasicRenderEngine(  ):void {
			axisSize = 0;
			tmp = new Vector3D();
			objects = new Vector.<Object3D>();
			plights = new Vector.<LightInst>();
			dlights = new Vector.<LightInst>();
			stats = new  Stats(); 
		}
		public function  renderScene(scene:SceneObject3D, camera:Camera3D, viewPort:Viewport3D):void{
			r ||= new  RenderInfos(viewPort);
			this.camera = camera;
			this.display = viewPort;
			this.scene=scene;
			r.camera=camera.m; 
			
			 
		}
		
		 
		public function addLight(l : Light) : void {
			var lights : Vector.<LightInst> = ((l.directional)?this.dlights:this.plights);
			lights.push(new LightInst(l));
		}
		
		 
		
		public function removeLight(l : Light) : Boolean {
			var lights : Vector.<LightInst> = ((l.directional)?this.dlights:this.plights);
			
			var index:int= lights.indexOf(l);
			
			if(index!=-1) {
				lights.splice(index,1);
				return true;
			}
			return false;
		}
		
		public function listObjects() :Vector.<Object3D> {
			return this.objects;
		}
		
		public function setDisplay(d : Viewport3D) :Viewport3D {
			this.display = d;
			this.r.display = d;
			return d;
		}
		
		protected function quicksort(lo : int,hi : int) : void {
			var i : int = lo;
			var j : int = hi;
			var tbuf : Vector.<Triangle> = this.r.triangles;
			var p : Number = tbuf[lo + hi >> 1].z;
			while(i <= j) {
				while(tbuf[i].z > p) i++;
				while(tbuf[j].z < p) j--;
				if(i <= j) {
					var t : Triangle = tbuf[i];
					tbuf[i++] = tbuf[j];
					tbuf[j--] = t;
				}
			}
			if(lo < j) this.quicksort(lo,j);
			if(i < hi) this.quicksort(i,hi);
		}
		
		protected function updateLights(m : Matrix4x4,pos : Matrix4x4) : void {
			m.inverse3x4(pos); 
			var p:Vector3D;
			for each( var l:LightInst in dlights ) {
				// calculate the light position in terms of object coordinates
				p = l.pos;
				var lx:Number = p.x * m._11 + p.y * m._21 + p.z * m._31;
				var ly:Number = p.x * m._12 + p.y * m._22 + p.z * m._32;
				var lz:Number = p.x * m._13 + p.y * m._23 + p.z * m._33;
				// ... normalize it in case we have a scale in the object matrix
				var k:Number = l.l.power / Math.sqrt(lx * lx + ly * ly + lz * lz);
				l.lx = lx * k;
				l.ly = ly * k;
				l.lz = lz * k;
			}
			for each( l in plights ) {
				// calculate the light position in terms of object coordinates
				p  = l.pos;
				l.lx = p.x * m._11 + p.y * m._21 + p.z * m._31;
				l.ly = p.x * m._12 + p.y * m._22 + p.z * m._32;
				l.lz = p.x * m._13 + p.y * m._23 + p.z * m._33;
			}
		}
		
		public function render() : void {
			this.beginRender();
			this.renderObjects();
			this.finishRender();
		}
		
		
		public function beginRender() : void {
			stats.objects = 0;
			stats.primitives = 0;
			stats.triangles = 0;
			stats.drawCalls = 0;
			display.beginDraw();
			// prepare lights
			var p:Vector3D
			for each(var l:LightInst in dlights ) {
				p = l.pos;
				p.x = -l.l.position.x;
				p.y = -l.l.position.y;
				p.z = -l.l.position.z;
				l.r = l.l.color.r;
				l.g = l.l.color.g;
				l.b = l.l.color.b;
			}
			for each( l in plights ) {
				p = l.pos;
				p.x = l.l.position.x;
				p.y = l.l.position.y;
				p.z = l.l.position.z;
				l.r = l.l.color.r * l.l.power;
				l.g = l.l.color.g * l.l.power;
				l.b = l.l.color.b * l.l.power;
			}
			
			
			
			
		}
		  
		public function renderObjects() : void {
			var stats : Stats = this.stats;
			// render triangles to vbuf and tbuf
			var t:int = getTimer();
			var m : Matrix4x4 = new Matrix4x4(), tmp : Matrix4x4 = new Matrix4x4();
			this.r.triangles = new Vector.<Triangle>();
			var tbuf : Vector.<Triangle> = this.r.triangles;
			var tindex : int = 0;
			var wmin : Number = this.camera.wmin, wmax : Number = this.camera.wmax;
			var fogLum : Number = 0.0;
			r.objects=new Vector.<Object3D>(); 
		
			this.scene.project(null,r);
			
			
			objects=r.objects;
			var io:int=0;
		 
			for each(var o:Object3D in objects ) {
				// precalculate the absolute projection matrix
				// by taking the object position into account
	 
				m.multiply3x4_4x4(o.view,camera.m);  
				if( o.visible &&o.geometry.ready)
				{ 
				
					
					 
						 
							var prim:Geometry  = o.geometry;							
						 	var i:int=0;
							var p : Point3D;
						 
						
							for(i=0;i<prim.points.length;i++ ){
								p=prim.points[i];
								var pw : Number = 1.0 / (m._14 * p.x + m._24 * p.y + m._34 * p.z + m._44);
								p.sx = (m._11 * p.x + m._21 * p.y + m._31 * p.z + m._41) * pw;
								p.sy = (m._12 * p.x + m._22 * p.y + m._32 * p.z + m._42) * pw;
								p.w = pw;
								 
							}
							var t1 : Triangle;
							for(i=0;i<prim.triangles.length;i++ ){
								t1=prim.triangles[i];
								var p0 : Point3D = t1.v0.p;
								var p1 : Point3D = t1.v1.p;
								var p2 : Point3D = t1.v2.p;
								if((p2.sx - p1.sx) * (p0.sy - p1.sy) - (p0.sx - p1.sx) * (p2.sy - p1.sy) < 0) {
									if(p0.w > wmin && p0.w < wmax && p1.w > wmin && p1.w < wmax && p2.w > wmin && p2.w < wmax) {
										tbuf[tindex++] = t1;
										t1.z = t1.v0.p.w + t1.v1.p.w + t1.v2.p.w;
									}
								} 
								 
							}
							 
						 
							var l:LightInst;
							switch(  prim.material.shade) {
								case ShadeModel.NoLight:
									// set all luminance to maximum value
								{
									var v : Vertex;
									for(i=0;i<prim.vertexes.length;i++ ){
										v= prim.vertexes[i];
										v.lum = 1.0; 
									}
								}
									break;
								case ShadeModel.Flat:
								{
									this.updateLights(tmp,o.view);
									// reset normals luminance
									var n : Normal;
									for(i=0;i<prim.normals.length;i++ ){
										n= prim.normals[i];
										n.lum = 0; 
									}
									
									for each(l in dlights ) { 
										for(i=0;i<prim.triangles.length;i++ ){
											t1 = prim.triangles[i];											 
											var lum : Number = t1.n.x * l.lx + t1.n.y * l.ly + t1.n.z * l.lz;
											if(lum > 0) {
												t1.v0.n.lum += lum;
												t1.v1.n.lum += lum;
												t1.v2.n.lum += lum;
											} 
										}
									}
									
									var v2 : Vertex;
									for(i=0;i<prim.vertexes.length;i++ ){
										v2 = prim.vertexes[i];
										v2.lum = v2.n.lum;
										
									}
								}
									break;
								case ShadeModel.Gouraud:
								{
									this.updateLights(tmp,o.view);
									var n2 : Normal;
									for(i=0;i<prim.normals.length;i++ ){
										n2 = prim.normals[i];
										n2.lum = 0; 
									}
									var l2:LightInst;
									for each( l2 in dlights ) { 
										for(i=0;i<prim.normals.length;i++ ){
											n2 = prim.normals[i];  
											var lum2 : Number = n2.x * l2.lx + n2.y * l2.ly + n2.z * l2.lz;
											if(lum2 > 0) n2.lum += lum2; 
										}
									}
									
									var v3 : Vertex;
									for(i=0;i<prim.vertexes.length;i++ ){
										v3 =prim.vertexes[i];
										v3.lum = v3.n.lum;
									}
									if(prim.material.useFog && this.fog != null) {
										
										for(i=0;i<prim.vertexes.length;i++ ){
											v3 =prim.vertexes[i];
											v3.lum -= v3.p.w * fogLum;
											
										}
									}
									if( prim.material.pointLights ) {
										for each( var l3 : LightInst  in plights ) {
											
											
											for(i=0;i<prim.vertexes.length;i++ ){
												v3 =prim.vertexes[i];
												var dx : Number = l3.lx - v3.p.x;
												var dy : Number = l3.ly - v3.p.y;
												var dz : Number = l3.lz - v3.p.z;
												var lum3 : Number = v3.n.x * dx + v3.n.y * dy + v3.n.z * dz;
												if(lum3 > 0) v3.lum += lum3 * l3.l.power / (dx * dx + dy * dy + dz * dz);
												
											}
											
										}
									}
								}break;
								case ShadeModel.RGBLight:
								{
									this.updateLights(tmp,o.view);
									var n3 : Normal;
									for(i=0;i<prim.normals.length;i++ ){
										n3 = prim.normals[i];
										n3.r = 0;
										n3.g = 0;
										n3.b = 0;
										
									}
									for each( var l4 : LightInst in dlights ) {
										//n_normals = prim.normals;
										//while( n_normals != null ) 
										for(i=0;i<prim.normals.length;i++ ){
											n3 = prim.normals[i];
											
											var lum4 : Number = n3.x * l4.lx + n3.y * l4.ly + n3.z * l4.lz;
											if(lum4 > 0) {
												n3.r += lum4 * l4.r;
												n3.g += lum4 * l4.g;
												n3.b += lum4 * l4.b;
											} 
											
										}
									}
									var v4 : Vertex;
									for(i=0;i<prim.vertexes.length;i++ ){
										v4 = prim.vertexes[i];
										v4.r = v4.n.r;
										v4.g = v4.n.g;
										v4.b = v4.n.b;
									}
									if(prim.material.useFog && this.fog != null) {
										for(i=0;i<prim.vertexes.length;i++ ){
											v4 = prim.vertexes[i];
											v4.r -= v4.p.w * this.fog.r;
											v4.g -= v4.p.w * this.fog.g;
											v4.b -= v4.p.w * this.fog.b;
											
										}
									}									 
									
									// add point-lights color
									if( prim.material.pointLights ) {
										for each( var l5 : LightInst  in plights ) { 
											for(i=0;i<prim.vertexes.length;i++ ){
												v4 = prim.vertexes[i];
												var dx2 : Number = l5.lx - v4.p.x;
												var dy2 : Number = l5.ly - v4.p.y;
												var dz2 : Number = l5.lz - v4.p.z;
												var lum5 : Number = v4.n.x * dx2 + v4.n.y * dy2 + v4.n.z * dz2;
												if(lum5 > 0) {
													lum5 /= dx2 * dx2 + dy2 * dy2 + dz2 * dz2;
													v4.r += lum5 * l5.r;
													v4.g += lum5 * l5.g;
													v4.b += lum5 * l5.b;
												} 
												
											}
										}
									}
								}break;
							}
						 	 
							stats.primitives++;
					 
					}
				
					stats.objects++;
				 
			}      
			stats.triangles = tindex;
			var dt:int =  getTimer() - t;
			stats.transformTime = stats.transformTime * stats.timeLag + (1 - stats.timeLag) * dt;
			t += dt;
			if(tindex == 0) return;
			this.quicksort(0,tbuf.length - 1);
			dt = getTimer() - t;
			stats.sortTime = stats.sortTime * stats.timeLag + (1 - stats.timeLag) * dt;
			t += dt;
			var max : int = tindex;
			tindex = 0;
			var mat : Material = tbuf[tindex].material;
			var vertexes : Vector.<Number> = new Vector.<Number>(), vindex : int = 0;
			var uvcoords : Vector.<Number> = new Vector.<Number>(), uvindex : int = 0;
			var lightning : Vector.<Number> = new Vector.<Number>(), lindex : int = 0;
			var colors : Vector.<Number> = null, cindex : int = 0;
			{
				 
				switch(mat.shade ) {
					case 3:
					{
						colors = new Vector.<Number>();
					}break;
					default:{
						null;
					}break;
				}
			}
			
			while(tindex < max) {
				var t12 : Triangle = tbuf[tindex++];
				if(t12.material != mat) {
					stats.drawCalls++;
					this.r.vertexes = vertexes;
					this.r.uvcoords = uvcoords;
					this.r.lightning = lightning;
					this.r.colors = colors;
					mat.draw(this.r);
					vertexes = new Vector.<Number>();
					vindex = 0;
					uvcoords = new Vector.<Number>();
					uvindex = 0;
					lightning = new Vector.<Number>();
					lindex = 0;
					colors = null;
					cindex = 0;
					{
						 
						switch(mat.shade) {
							case 3:
							{
								colors = new Vector.<Number>();
							}break;
							default:{
								null;
							}break;
						}
					}
					mat = t12.material;
				}
				var v0 : Vertex = t12.v0, v1 : Vertex = t12.v1, v22 : Vertex = t12.v2;
				var p02 : Point3D = v0.p, p12 : Point3D = v1.p, p22 : Point3D = v22.p;
				vertexes[vindex++] = p02.sx;
				vertexes[vindex++] = p02.sy;
				vertexes[vindex++] = p12.sx;
				vertexes[vindex++] = p12.sy;
				vertexes[vindex++] = p22.sx;
				vertexes[vindex++] = p22.sy;
				uvcoords[uvindex++] = v0.u;
				uvcoords[uvindex++] = v0.v;
				uvcoords[uvindex++] = p02.w;
				uvcoords[uvindex++] = v1.u;
				uvcoords[uvindex++] = v1.v;
				uvcoords[uvindex++] = p12.w;
				uvcoords[uvindex++] = v22.u;
				uvcoords[uvindex++] = v22.v;
				uvcoords[uvindex++] = p22.w;
				if(colors == null) {
					lightning[lindex++] = v0.lum;
					lightning[lindex++] = 0.;
					lightning[lindex++] = p02.w;
					lightning[lindex++] = v1.lum;
					lightning[lindex++] = 0.;
					lightning[lindex++] = p12.w;
					lightning[lindex++] = v22.lum;
					lightning[lindex++] = 0.;
					lightning[lindex++] = p22.w;
				}
				else {
					lightning[lindex++] = v0.r + v0.cr;
					lightning[lindex++] = 0.;
					lightning[lindex++] = p02.w;
					lightning[lindex++] = v1.r + v1.cr;
					lightning[lindex++] = 0.;
					lightning[lindex++] = p12.w;
					lightning[lindex++] = v22.r + v22.cr;
					lightning[lindex++] = 0.;
					lightning[lindex++] = p22.w;
					colors[cindex++] = v0.g + v0.cg;
					colors[cindex++] = v0.b + v0.cb;
					colors[cindex++] = p02.w;
					colors[cindex++] = v1.g + v1.cg;
					colors[cindex++] = v1.b + v1.cb;
					colors[cindex++] = p12.w;
					colors[cindex++] = v22.g + v22.cg;
					colors[cindex++] = v22.b + v22.cb;
					colors[cindex++] = p22.w;
				}
			}
			stats.drawCalls++;
			this.r.vertexes = vertexes;
			this.r.uvcoords = uvcoords;
			this.r.lightning = lightning;
			this.r.colors = colors;
			mat.draw(this.r);
			dt = getTimer() - t;
			stats.materialTime = stats.materialTime * stats.timeLag + (1 - stats.timeLag) * dt;
			t += dt;
		}
		public function finishRender() :void  {
			// draw axis
			if( axisSize != 0 ) {
				var p0:Vector3D = new Vector3D();
				drawLine(p0,new Vector3D(axisSize,0,0),new Color(1,0,0));
				drawLine(p0,new Vector3D(0,axisSize,0),new Color(0,1,0));
				drawLine(p0,new Vector3D(0,0,axisSize),new Color(0,0,1));
			}
			var t:int =  getTimer();
			display.endDraw();
			var dt:int =  getTimer() - t;
			stats.drawTime = stats.drawTime * stats.timeLag + (1 - stats.timeLag) * dt;
			stats.shapeCount = display.shapeCount();
		}
		
		public function drawPoint( p :  Vector3D, color :  Color,  size:int = 1.0 ) :void{
			var g:Graphics = display.getContext(BlendMode.NORMAL);
			var w :Number= camera.m.project(p,tmp);
			if( w < camera.wmin || w > camera.wmax )
				return;
			g.beginFill(color.argb,color.a);
			g.drawCircle(tmp.x,tmp.y,size);
		}
		
		public function drawLine( p :  Vector3D, p2 : Vector3D, color :  Color,  size:Number = 1.0 )  :void {
			var w :Number= camera.m.project(p,tmp);
			if( w < camera.wmin || w > camera.wmax )
				return;
			var g :Graphics= display.getContext(BlendMode.NORMAL);
			g.moveTo(tmp.x,tmp.y);
			w = camera.m.project(p2,tmp);
			if( w < camera.wmin || w > camera.wmax )
				return;
			g.endFill();
			g.lineStyle(size,color.argb,color.a);
			g.lineTo(tmp.x,tmp.y);
			g.lineStyle();
		}
	}
}