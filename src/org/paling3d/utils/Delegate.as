 
package    org.paling3d.utils  {
	import flash.display.Sprite;	
	import flash.display.DisplayObject;	
	import flash.events.Event;	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;        

 
	public class Delegate {               
		// Create a wrapper for a callback function.
		// Tacks the additional args on to any args normally passed to the
		// callback.
		public static function create(handler:Function,...args):Function {
			return function(...innerArgs):void {
				var handlerArgs:Array = [];
				if(innerArgs != null) handlerArgs = innerArgs;
				if(args != null) handlerArgs = handlerArgs.concat(args);
				handler.apply(this, handlerArgs);
			};
		}
		
		public static function callLater(delayMs:int, handler:Function, ...args):Timer {
			var timer:Timer = new Timer(delayMs, 1);
			var d:Function = Delegate.create(afterDelay, handler, args);
			timerDelegates[timer] = d;
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, d);
			timer.start();
            
			return timer;
		}
		
		public static function callTimeOut(handler:Function, delayMs:int, ...args):Timer {		//	同 CallLater ，格式同 setTimeOut
			var timer:Timer = new Timer(delayMs, 1);   
			var d:Function = Delegate.create(afterDelay, handler, args);            
			timerDelegates[timer] = d;                     
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, d);
			timer.start(); 
            
			return timer;
		}
		
		private static function afterDelay( e:TimerEvent, handler:Function, args:Array ):void {
			try{
				handler.apply(null, args);
				cancel(e.target as Timer);  
			}catch(e:Error){}
		}
		
		public static function cancel( thing:* ):void {
			if(thing==null) return;
			if(thing is Timer) {
				var timer:Timer = thing as Timer;		
				timer.reset();               	                   
				if(timerDelegates[timer] != null) {
					timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerDelegates[timer]); 
					timer.removeEventListener(TimerEvent.TIMER, timerDelegates[timer]); 
					delete timerDelegates[timer];
				} 
			} 			
			if(thing is Function) {
				var handler:Function = thing as Function;
				var delegate:Function = enterFrameDelegates[handler];
				if(enterFrameDelegates[handler]!=null) {
					disp.removeEventListener( Event.ENTER_FRAME, enterFrameDelegates[handler]);
					delete enterFrameDelegates[handler];
				}
			}
		}     
		
		public static function onEnterFrame( handler:Function, ...args):void {
			var delegate:Function = Delegate.create(afterEnterFrame, handler, args);            
			enterFrameDelegates[handler] = delegate;              
			disp.addEventListener(Event.ENTER_FRAME, delegate);
		}
		
		private static function afterEnterFrame( e:Event, handler:Function, args:Array ):void {
			handler.apply(null, args);
			cancel(e.target as Timer);   
		}
		public static function onTimerFrame(delayMs:int, handler:Function, ...args):Timer {
			
			var timer:Timer = new Timer(delayMs);
			var d:Function = Delegate.create(afterTimerFrame, handler, args);            
			timerDelegates[timer] = d;                     
			timer.addEventListener(TimerEvent.TIMER, d);
			timer.start(); 
            
			return timer;
		}
		public static function clear() : void{
             var _loc_1:*;
            for (_loc_1 in timerDelegates){
                // label
                cancel(_loc_1 as Timer);
            }// end of for ... in
            return;
        }// end function
		private static function afterTimerFrame( e:Event, handler:Function, args:Array ):void {
			handler.apply(null, args);
			//cancel(e.target as Timer);   
		}     
		static private var timerDelegates:Dictionary = new Dictionary(true);
		static private var enterFrameDelegates:Dictionary = new Dictionary(true);
		static private var disp:Sprite = new Sprite;
	}
}
