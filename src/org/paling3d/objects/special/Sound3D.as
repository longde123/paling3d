﻿package  org.paling3d.objects.special {
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import org.paling3d.cameras.Camera3D;
	import org.paling3d.geom.RenderInfos;
	import org.paling3d.objects.Object3D;
	
 	

	public class Sound3D extends Object3D
	{
		
		//any sound object
		public var sound:Sound;
		
		//This is used for sound via SoundChannel, FLV or video to be transformed.
		public var soundChannel : SoundChannel;

		//maximum distance the sound can travel
		public var maxSoundDistance:Number;
		
		/*
		* This is used to control the volume and could also be used to control the pitch and/or fader  
		* if a sound engine that supports it is used. It puts out values from -1 to 1. Values from 0 to -1 is 
		* when the object is behind the camera.
		*/
		public var soundDistance       :Number;
		
		
		//Controls the pan. It puts out values from -1 to 1.
		public var soundPan       :Number;
		
		//Works only for sound
		public function play(startTime:Number = 0, loops:int = 0,sndTransform:SoundTransform = null):void
		{
    		soundChannel = sound.play(startTime, loops, sndTransform);
    		if (soundChannel){
        		setVolume(0);
        		setPan(0);
   			}
		}

		
		public function stop(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):void
		{
			soundChannel.stop();
		}
		
		private function setPan(pan:Number):void {
			var transform:SoundTransform = SoundTransform(soundChannel.soundTransform);
			transform.pan = pan;
			soundChannel.soundTransform = transform;
		}
	
		private function setVolume(volume:Number):void {
			var transform:SoundTransform = soundChannel.soundTransform;
			transform.volume = volume;
			soundChannel.soundTransform = transform;
		}
		
		
		
		//Controls the 3d position of the sound
		public function updateSound ( camera:Camera3D ):void
		{
			var dist:Number;
			var newX:Number = this.world._14 - camera.x;
			var newY:Number = this.world._24 - camera.y;
			var newZ:Number = this.world._34 - camera.z;
			if(!maxSoundDistance) maxSoundDistance = 4000;
			var Sdist:Number = Math.sqrt(newX*newX+newY*newY+newZ*newZ);
			var Angle:Number = int(Math.atan(newX/newZ)*180/Math.PI) - camera.rotationY;
			
			if (Angle>359) Angle = (Angle%360);
			else if(Angle<=0) Angle = 360+(Angle%360);
			
			if (newZ<0) Angle = ((Angle)+180)%360;
			else if(newZ>0) Angle = Angle;
			
			if (Sdist<=maxSoundDistance) dist = 1-(Sdist/maxSoundDistance);
			else dist = 0;
			
			var ang:Number = Angle - 179;
			var Pan:Number = (ang - 180)/180;
			
			if ( ang >= -180 && ang <= 0) Pan = ((ang + 180)/90); //left ear
			else if (ang<179 && ang>0) Pan = ((ang - 179)/90); //right ear
			
			if(Pan<-1) Pan = -(Pan%1 + 1);
			else if(Pan>1) Pan = .99 - (Pan%1);
			
			soundPan = Pan;
			soundDistance = dist*(view._34/Math.abs(view._34));
			
			if(soundChannel){
				setVolume(Math.abs(soundDistance));
				setPan(soundPan);
			}
		}
		
		public function Sound3D( soundObj:Sound=null ):void
		{
			if(soundObj){
				this.sound = soundObj;
				//this.soundChannel = new SoundChannel();
			}
		}
		
		public override function project(parent:Object3D, renderSessionData:RenderInfos):void
		{
			//if( ! sorted ) this._sorted = sorted = new Array();
	
			if( this._transformDirty ) updateTransform();
			
			//why calculateScreenCoords( renderSessionData.camera );
			
			if (soundChannel) updateSound(renderSessionData.camera);//Updates 3D Sound
	
			this.view.multiply4x4( parent.view, this.transform );
			this.world.multiply4x4( parent.world, this.transform );
			
	 
		}
	}
}