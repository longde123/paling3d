package org.paling3d.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import org.paling3d.view.Viewport3D;
	import org.paling3d.render.BasicRenderEngine;
	import org.paling3d.geom.Stats;

	public class StatusPanel extends Sprite 
	{

		public static var DEFAULT_WIDTH :int= 90;

		public static var COLOR_MS :uint= 0x00FF00;
		public static var COLOR_FPS :uint= 0xFFFF00;
		public static var COLOR_MEM:uint = 0x00FFFF;

		static public var initialized :Boolean= false;

		public var world :  BasicRenderEngine;

		private var w : int;
		private var h : int;
		private var graph : BitmapData;
		private var graph_hi : BitmapData;
		private var  graph_h : int;
		private var  tf_fps : TextField;
		private var  tf_ms : TextField;
		private var  tf_mem : TextField;
		private var  format : TextFormat;

		private var  fps : int;
		private var  timer : Number;
		private var  ms : int;
		private var  ms_prev : Number;
		private var  mem : Number;
		private var  mouseDown : Boolean;

		private var  tf_objects : TextField;

		
		public function StatusPanel( world : BasicRenderEngine,  w : int=-1,  h : int=-1) 
		{
			
			super();
			this.world = world;
			this.w = ( w != -1 ) ? w : DEFAULT_WIDTH;
			this.h = ( h != -1 ) ? h : 150;
			
			graph_h = 50;
			mouseDown = false;
			
			if(stage)init();
				else addEventListener(Event.ADDED_TO_STAGE,init);
		}

		
		private  function init(e:*=null) :void
		{
			
			fps = ms = 0;
			timer = ms_prev = mem = 0.0;
			
			graph = new BitmapData(w, graph_h, false, 0x333333);
			var bmp:Bitmap = new Bitmap(graph);
			bmp.y = 125;
			addChild(bmp);
			
			graph_hi = new BitmapData(w, graph_h, false, 0x333333);
			var bmp2:Bitmap  = new Bitmap(graph_hi);
			bmp2.y = 125 + graph_h;
			addChild(bmp2);
			
			//format = new TextFormat( "__sans", 8 );
			format = new TextFormat("Arial", 8);
			
			graphics.beginFill(0x222222);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
			tf_fps = new TextField();
			tf_ms = new TextField();
			tf_mem = new TextField();
			
			tf_fps.defaultTextFormat = tf_ms.defaultTextFormat = tf_mem.defaultTextFormat = format;
			tf_fps.width = tf_ms.width = tf_mem.width = w;
			tf_fps.selectable = tf_ms.selectable = tf_mem.selectable = false;
			
			tf_fps.textColor = 0xFFFF00;
			tf_fps.text = "FPS: ";
			addChild(tf_fps);
			
			tf_ms.y = 10;
			tf_ms.textColor = COLOR_MS;
			tf_ms.text = "MS: ";
			addChild(tf_ms);
			
			tf_mem.y = 20;
			tf_mem.textColor = 0x00FFFF;
			tf_mem.text = "MEM: ";
			addChild(tf_mem);
			
			tf_objects = new TextField();
			tf_objects.selectable = false;
			tf_objects.defaultTextFormat = format;
			tf_objects.width = w;
			tf_objects.y = 30;
			tf_objects.textColor = 0xcccccc;
			tf_objects.text = "MSHS: ";
			addChild(tf_objects);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			addListener();
		}

		private function addListener() :void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.CLICK, mouseClickHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseExitHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseExitHandler);
			addEventListener(Event.ENTER_FRAME, update);
		}

		private function removeListener()  :void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			removeEventListener(MouseEvent.CLICK, mouseClickHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseExitHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseExitHandler);
			removeEventListener(Event.ENTER_FRAME, update);
		}

		private function mouseClickHandler( e : MouseEvent )  :void
		{
			handleMouseFPS();
		}

		private function mouseDownHandler( e : MouseEvent )  :void
		{
			mouseDown = true;
			var self :StatusPanel= this;
			Delegate.callLater(400, function() :void
			{
				self.addEventListener(Event.ENTER_FRAME, mouseHoldHandler);
			});
		}

		private function mouseExitHandler( e : MouseEvent )  :void
		{
			mouseDown = false;
			removeEventListener(Event.ENTER_FRAME, mouseHoldHandler);
		}

		private function mouseOutHandler( e : MouseEvent ) :void
		{
			mouseDown = false;
			removeEventListener(Event.ENTER_FRAME, mouseHoldHandler);
		}

		private function mouseHoldHandler( e : Event )  :void
		{
			if( mouseDown ) 
			{
				handleMouseFPS();
			}
		}

		private function handleMouseFPS()  :void
		{
			if( this.mouseY > this.height * .5 ) 
			{
				if( stage.frameRate > 1 ) stage.frameRate--;
			} 
			else 
			{
				if( stage.frameRate < 999 ) stage.frameRate++;
			}
			tf_fps.text = "FPS: " + fps + " / " + stage.frameRate;
		}

		private function keyDownHandler( e : KeyboardEvent )  :void
		{
			if( e.ctrlKey && e.keyCode == 73 ) 
			{
				visible = !visible;
				if( visible ) addListener() else removeListener();
			}
		}

		private function update(..._)  :void
		{
			
			timer = getTimer();
			fps++;
			
			var memGraph :Number= Math.min(graph_h, Math.sqrt(Math.sqrt(mem * 5000))) - 2;
			
			if( timer - 1000 > ms_prev ) 
			{
				ms_prev = int(timer);
				mem = System.totalMemory / 1048576;
				var fpsGraph :Number= Math.min(50, 50 / stage.frameRate * fps);
				graph.scroll(1, 0);
				graph.fillRect(new Rectangle(0, 0, 1, graph_h), 0x000000);
				graph.setPixel(0, int(graph_h - fpsGraph), 0xFFFF00);
				graph.setPixel(0, int(graph_h - ( int(timer - ms) >> 1 )), 0x00FF00);
				graph.setPixel(0, int(graph_h - memGraph), COLOR_MEM);
				tf_fps.text = "FPS: " + fps + " / " + stage.frameRate;
				tf_mem.text = "MEM: " + mem;
				fps = 0;
			}
			
			graph_hi.scroll(1, 0);
			graph_hi.fillRect(new Rectangle(0, 0, 1, graph.height), 0x222222);
			graph_hi.setPixel(0, int(graph.height - ( int(timer - ms) >> 1 )), COLOR_MS);
			graph_hi.setPixel(0, int(graph.height - memGraph), COLOR_MEM);
			
			tf_ms.text = "MS: " + ( timer - ms );
			ms = int(timer);
			
			var s:String = "";
			var stats:Stats = world.stats;
			s += "objects: " + stats.objects;
			s += "\ntriangles: " + stats.triangles;
			s += "\ndrawCalls: " + stats.drawCalls;
			s += "\nshapeCount: " + stats.shapeCount;
			s += "\nquality: " + stage.quality;
			
			s += "\ntransformTime: " + stats.transformTime;
			s += "\nsortTime:  " + stats.sortTime;
			s += "\nDRWTime: " + (stats.materialTime + stats.drawTime);
			s += "\nShapeListCount: "+   (Viewport3D.ShapeListCount);
			
			tf_objects.text = s;
		}
	}
}