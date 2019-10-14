package org.paling3d.animation.channel.transform {
	import org.paling3d.animation.channel.Channel3D;	
	import org.paling3d.animation.key.LinearCurveKey3D;	
	import org.paling3d.math.Matrix4x4;	
	import org.paling3d.animation.curve.Curve3D;	

	/**
	 * @author Tim Knip / floorplanner.com
	 */
	public class TransformStackChannel3D extends TransformChannel3D 
	{
		protected var channels : Array;
		
		/**
		 * 
		 */
		public function TransformStackChannel3D(transform : Matrix4x4) 
		{
			super(transform);
			this.channels = new Array();
		}

		/**
		 * 
		 */
		override public function addCurve(curve : Curve3D, updatesTimes : Boolean=true) : Curve3D 
		{
			throw new Error("[TransformStackChannel3D] Can't add curves to a TransformStackChannel3D!");
		}

		/**
		 * 
		 */
		public function addChannel(channel : TransformChannel3D) : TransformChannel3D
		{
			if(channels.indexOf(channel) == -1)
			{
				channels.push(channel);
				updateStartAndEndTime();
				return channel;
			}
			return null;	
		}

		/**
		 * Bakes this MatrixStackChannel into a single MatrixChannel3D.
		 * 
		 * @param sampleRate
		 * 
		 * @return The created MatrixChannel3D or null on failure.
		 * 
		 * @see lh3d.animation.channel.matrix.TransformChannel3D 
		 */
		public function bake(numSamples : uint) : MatrixChannel3D 
		{
			var step : Number = (endTime - startTime) / numSamples;
			var baked : MatrixChannel3D = new MatrixChannel3D(null);
			var curves : Array = new Array(12);
			var time : Number = startTime;
			var i : int;
			
			for(i = 0; i < 12; i++)
			{
				curves[i] = new Curve3D();
			}
			
			for(i = 0; i <= numSamples; i++)
			{
				update(time);
				
				curves[0].addKey(new LinearCurveKey3D(time, transform._11));
				curves[1].addKey(new LinearCurveKey3D(time, transform._12));
				curves[2].addKey(new LinearCurveKey3D(time, transform._13));
				curves[3].addKey(new LinearCurveKey3D(time, transform._14));
				
				curves[4].addKey(new LinearCurveKey3D(time, transform._21));
				curves[5].addKey(new LinearCurveKey3D(time, transform._22));
				curves[6].addKey(new LinearCurveKey3D(time, transform._23));
				curves[7].addKey(new LinearCurveKey3D(time, transform._24));
				
				curves[8].addKey(new LinearCurveKey3D(time, transform._31));
				curves[9].addKey(new LinearCurveKey3D(time, transform._32));
				curves[10].addKey(new LinearCurveKey3D(time, transform._33));
				curves[11].addKey(new LinearCurveKey3D(time, transform._34));

				time += step;	
			}
			
			for(i = 0; i < 12; i++)
			{
				baked.addCurve(curves[i]);	
			}
			
			return baked;
		}
		
		/**
		 * 
		 */
		override public function clone() : Channel3D 
		{
			var channel : TransformStackChannel3D = new TransformStackChannel3D(this.transform);
			var ch : TransformChannel3D;
			var i : int;
			
			for(i = 0; i < channels.length; i++)
			{
				ch = channels[i];
				channel.addChannel(ch.clone() as TransformChannel3D);
			}
			return channel;
		}
		
		/**
		 * 
		 */
		override public function update(time : Number) : void 
		{
			var channel : TransformChannel3D;
			var i : int;
			
			transform.identity();
			
			for(i = 0; i < channels.length; i++)
			{
				channel = channels[i];	
				channel.update(time);
				
				transform.multiply4x4(transform, channel.transform); 
			}
		}

		override public function updateStartAndEndTime() : void 
		{
			var channel : TransformChannel3D;
			var i : int;
			
			if(channels.length == 0)
			{
				startTime = endTime = 0;
				return;
			}
			
			startTime = Number.MAX_VALUE;
			endTime = -startTime;
			
			for(i = 0; i < channels.length; i++)
			{
				channel = channels[i];	
				startTime = Math.min(startTime, channel.startTime);
				endTime = Math.max(endTime, channel.endTime);
			}
		}
	}
}
