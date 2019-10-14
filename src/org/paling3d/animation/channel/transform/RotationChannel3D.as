package org.paling3d.animation.channel.transform {
	import org.paling3d.animation.channel.Channel3D;
	import org.paling3d.animation.curve.Curve3D;
	import org.paling3d.math.Matrix4x4;
	import org.paling3d.math.Vector3D;

	/**
	 * @author Tim Knip / floorplanner.com
	 */
	public class RotationChannel3D extends TransformChannel3D 
	{
		public var axis : Vector3D;
		
		public function RotationChannel3D(axis : Vector3D) 
		{
			super(null);
		
			this.axis = axis;
		}

		/**
		 * 
		 */
		override public function clone() : Channel3D 
		{
			var channel : RotationChannel3D = new RotationChannel3D(this.axis.clone());
			var curve : Curve3D;
			var i : int;
			
			for(i = 0; i < _curves.length; i++)
			{
				curve = _curves[i];
				channel.addCurve(curve.clone(), (i == _curves.length-1));
			}
			return channel;
		}
		
		override public function update(time : Number) : void 
		{
			if(!_curves || !_curves.length)
			{
				return;
			}
			
			super.update(time);

			transform = Matrix4x4.rotationMatrix(axis.x, axis.y, axis.z, output[0], transform);
		}
	}
}
