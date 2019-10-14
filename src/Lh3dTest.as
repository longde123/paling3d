package
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.paling3d.*;
	import org.paling3d.cameras.Camera3D;
	import org.paling3d.controller.*;
	import org.paling3d.events.FileLoadEvent;
	import org.paling3d.geom.Vertex;
	import org.paling3d.lights.Light;
	import org.paling3d.materials.BitmapMaterial;
	import org.paling3d.materials.Color;
	import org.paling3d.materials.ColorMaterial;
	import org.paling3d.materials.Material;
	import org.paling3d.materials.RGBMaterial;
	import org.paling3d.materials.ShadeModel;
	import org.paling3d.materials.WireMaterial;
	import org.paling3d.math.*;
	import org.paling3d.objects.*;
	import org.paling3d.objects.parsers.DAE;
	import org.paling3d.primitives.Geometry;
	import org.paling3d.render.BasicRenderEngine;
	import org.paling3d.scenes.Scene3D;
	import org.paling3d.utils.StatusPanel;
	import org.paling3d.utils.reader.AbstractModelReader;
	import org.paling3d.utils.reader.ModelLoader;
	import org.paling3d.view.Viewport3D; 
	import org.paling3d.render.*;
	[SWF(width="800",height="600",frameRate="30",backgroundColor="#ffffff")] 
	public class Lh3dTest extends Sprite
	{

		
		
		
		
		 
		public 	var world : BasicRenderEngine;
		public 	var light : Light;
		public 	var light2 : Light;
		public 	var cam : Camera3D;
		public 	var time : Number;
		public 	var collada :  AbstractModelReader;
		public 	var xmove : Number;
		public 	var ymove : Number;
		private var dae:DAE;
		public var scene:Scene3D;
		public function Lh3dTest() 
		{
			 
			//Paling3D.useRIGHTHANDED=true;
			var display : Viewport3D = new Viewport3D(this.stage.stageWidth, this.stage.stageHeight);
			this.addChild(display.result);
			cam = new Camera3D();
			
			var pos:Vector3D=cam.position;
			pos.set(30,30,10);
			cam.position=pos;
			time = 0;
			xmove = 0; 
			ymove = 0;
			light = new Light(new Vector3D(0, 0, -100), new  Color(100, 10, 50), false);
			light2 = new  Light(new Vector3D(0, 0, 200), new  Color(0, 50, 0), false);
			
			scene=new Scene3D();
			
			world = new  BasicRenderEngine();
			world.renderScene(scene,cam,display);
			world.axisSize = 1;
			world.addLight(light);
			world.addLight(light2);
		
			var statusPanel:StatusPanel = new  StatusPanel(world);
			this.addChild(statusPanel);
			
			dae= new DAE(true,"DAE");
			dae.addEventListener(FileLoadEvent.LOAD_COMPLETE,__LOAD_COMPLETE);
 	  	   dae.load("res/pg_stand.dae");
			 
		
		
		   return;  
			var loader:ModelLoader = new  ModelLoader();
			collada = loader.loadCollada("res/axisCube.dae", __loadCollada);
			// collada = loader.loadObj("res/axisCube.obj", __loadCollada);
			loader.start();
			
			
			
			return;  
		 
			pos.set(3, 3, 1);
			cam.position=pos;
			dae.load("res/cube.dae");
			 
		}
		private function __loadCollada():void
		{
			for each(var o :Object3D in collada.objects ) project(o); 
			init();
			trace("__loadCollada")
		}
		private function __LOAD_COMPLETE(e:FileLoadEvent):void
		{
			dae.visible=true;
			project(dae);
			init();
			 //dae.rotationY =  90;
			// dae.x=50; 
			
		}
		
		public function project( o :Object3D):void
		{
		 trace("project "+o.name);			 
			scene.addChild(o);			 
				 
		}
		public function init() :void
		{
			var me:Lh3dTest = this;
			this.addEventListener(Event.ENTER_FRAME, function(...arg):void
			{ 
			 	render() ;
			});
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e : KeyboardEvent):void
			{  
				me.onKeyDown(e.keyCode); 
			});
			this.stage.addEventListener(KeyboardEvent.KEY_UP, function(e : KeyboardEvent):void
			{  
				me.onKeyUp(e.keyCode); 
			});
		}

		public	function getColor( mat :  Material ) :Color
		{
			var color:Color = null;
			var m_Color: ColorMaterial = (mat as ColorMaterial);
			if( m_Color != null ) color = m_Color.ambient.add(m_Color.diffuse);
			var m_Bitmap:BitmapMaterial = (mat as BitmapMaterial);
			if( m_Bitmap != null ) color = getColor(m_Bitmap.sub);
			var m_Wire:WireMaterial = (mat as WireMaterial);
			if( m_Wire != null ) color = m_Wire.color;
			if( color == null ) color = new  Color(0.5, 0.5, 0.5, 1);
			return color;
		}

		public function onKeyDown( k : int ) :void
		{
			switch( k ) 
			{
				case Keyboard.DOWN: 
					xmove = -0.1;
				case Keyboard.UP: 
					xmove = 0.1;
				case Keyboard.LEFT: 
					ymove = -0.1;
				case Keyboard.RIGHT: 
					ymove = 0.1;
			}
		}

		public function onKeyUp( k : int ) :void
		{
			var o :Object3D;
			var p: Geometry ;
			 switch( k ) 
			{
				case  87://W
					for each( o in world.listObjects() )
					//	for each( p in o.geometry ) 
					{
						p = o.geometry;
						if(p.material!=null)
						{
							var colorWM :Color= getColor(p.material);
							p.material.free();
							p.setMaterial(new WireMaterial(colorWM));
						}
					}
					break;
				case 80://"P".code:
					var vcolor:RGBMaterial = new RGBMaterial();
					for each( o in world.listObjects() )
					//	for each( p in o.geometry ) 
					{
						p = o.geometry;
						if(p.material!=null)
						{
							var color :Color= getColor(p.material).scale(0.3);
							// colorize vertexes with material color
							var v:Vertex;
							//= p.vertexes;
							//while( v != null )
							for(var j:int=0;j<p.vertexes.length;j++ ) 							 
							{
								v =p.vertexes[j];
							 
								v.cr = color.r;
								v.cb = color.b;
								v.cg = color.g;
								//v = v.next;
							}
							// set vertex color material
							var bmat:BitmapMaterial = (p.material as BitmapMaterial);
							if( bmat == null )
							{
									p.setMaterial(vcolor);
							}
							else 
							{
								bmat.sub = vcolor;
								bmat.shade =  ShadeModel.RGBLight;
							}
						}
					}
					break;
				case 81://"Q".code:
					var qualities:Array = [StageQuality.BEST,StageQuality.HIGH,StageQuality.MEDIUM,StageQuality.LOW];
					var qpos:int = 0;
					// fu*n, the enums are lowercase while reading the attribute is uppercase
					var q:String = String(this.stage.quality).toLowerCase();
					for(var i: int= 0;i<qualities.length;i++ )
						if( q == String(qualities[i]).toLowerCase() ) 
					{
						qpos = i;
						break;
					}
					qpos++;
					this.stage.quality = qualities[qpos % qualities.length];
					break;
			 
				case Keyboard.LEFT:
					ymove = 0; 
					break;
				case Keyboard.RIGHT:
					ymove = 0; 
					break;
				case Keyboard.DOWN: 
					xmove = 0;
					 
					break;
				case Keyboard.UP: 
					xmove = 0; 
					break;
			} 
			 
		}

		public function render():void 
		{
			// update camera depending on mouse position
			if(!dae.playing)
			{
				dae.play();
			 
				
			}
			var dy:Number = (this.mouseY / world.display.height - 0.5) * 2;
			var dx :Number= (this.mouseX / world.display.width - 0.5) * 2;
			var p:Vector3D = world.camera.position;
			var t:Vector3D = world.camera.target;
			if (0)
			{
				var dt:Vector3D = t.sub(p);
			
				dt.normalize();
				var lt:Vector3D = dt.cross(world.camera.up);
				lt.normalize();
				p.x += dt.x * xmove + lt.x * ymove;
				p.y += dt.y * xmove + lt.y * ymove;
				p.z += dt.z * xmove + lt.z * ymove;
				var a:Number = (-dx * 1.2 + 1) * Math.PI;
				t.set(Math.cos(a) + p.x, Math.sin(a) + p.y, (-dy + 0.3) * 3 + p.z);
			}else
			{
				// rotate camera around target
				var dp :Vector3D = p.sub(t);
				var x_rot :Number= dx*0.1;
				var sin:Number = Math.sin(x_rot);
				var cos:Number = Math.cos(x_rot);
				dp = new Vector3D( cos*dp.x + sin*dp.y, -sin*dp.x + cos*dp.y, dp.z);
				// Change camera height...
				dp.z -= dy*0.1;
				var new_p :Vector3D = t.add(dp);
				p.set(new_p.x, new_p.y, new_p.z );
			}
			world.camera.position=p;
			world.camera.update();
			
			// rotate light direction
			time += 0.03;
			light.power = light.directional ? 1.0 : 2.0;
			light.position.x = -Math.cos(time) * 3;
			light.position.y = -Math.sin(time) * 3;
			light.position.z = light.directional ? -3 : 3;
			light2.position.x = -Math.cos(time / 2) * 2;
			light2.position.y = -Math.sin(time / 3) * 4;
			light2.position.z = light2.directional ? -2 : 2;
			
			// render
		/*	world.render();
			return; */
			world.beginRender(); 
			world.renderObjects();
			if( !light.directional )
				world.drawPoint(light.position, light.color, 3);
			if( !light2.directional )
				world.drawPoint(light2.position, light2.color, 3);
			world.finishRender();
			
		 
		}
	}
}