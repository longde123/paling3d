package org.paling3d.view
{ 
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite; 
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
 
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	
  
	public class Viewport3D implements IViewport3D
	{
		 
		public var width  : int;
		public var height  : int;
		public var result : DisplayObject;
		private var scene : Sprite;
		private var bitmap : BitmapData;
		private var current : Graphics;
		private var curmode : String;//BlendMode;
		private var shapeCache : ShapeList;
		private var shapeUsed : ShapeList;
		static public var ShapeListCount:int = 0;
		
 
		
		public function Viewport3D( width : int, height : int ) {
		 
			this.width = width;
			this.height = height;
			bitmap = new BitmapData(width,height,true,0);
			result = new Bitmap(bitmap);
			scene = new  Sprite(); 
		 
		}
		 
	 
		public function beginDraw():void {
			current = null;
			curmode = null;
	
			bitmap.lock();
		}
		
		public function shapeCount():int {
			return scene.numChildren;
		}
		
		public function getContext( mode:String ):Graphics {
			 
			//mode=BlendMode.NORMAL;
			if( mode != curmode )
				setContext(mode);
			
			return current;
		}
		
		public function setContext(mode:String):void {
			 
			//这里有个环啊
			var s : ShapeList= shapeCache;
			if( s == null ) {
				s = new ShapeList();
				s.x = width >> 1;
				s.y = height >> 1;
				ShapeListCount++;
			} else
			{
				shapeCache = s.next;
			}
			s.next = shapeUsed;
			shapeUsed = s;
			s.blendMode = mode ;
	        scene.addChild(s);
			current = s.graphics;
			curmode = mode;
		}
		
		public function endDraw():void { 
			bitmap.fillRect(bitmap.rect,0);
			// I would prefer to draw the shapes by hand
			// but this crash the flash player 10
			bitmap.draw(scene);
			bitmap.unlock();
			// cleanup
			var s : ShapeList= shapeUsed;
			while( s != null ) {
			
				s.graphics.clear();
				scene.removeChild(s);;
				 
				s = s.next;
				
			}
			
		 
			shapeCache = shapeUsed;
		    shapeUsed = null; 
		}

	}
}
 import flash.display.Shape;
 class ShapeList extends Shape {
	 
	public var next : ShapeList;
	public   function ShapeList():void
	{
		super(); 
		
	}
}