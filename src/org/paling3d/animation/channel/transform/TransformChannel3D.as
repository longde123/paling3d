package org.paling3d.animation.channel.transform {
	import org.paling3d.animation.channel.Channel3D;
	import org.paling3d.animation.curve.Curve3D;
	import org.paling3d.math.Matrix4x4;
	
	/**
	 * @author Tim Knip / floorplanner.com
 	 */
	public class TransformChannel3D extends Channel3D 
	{
		public var transform : Matrix4x4;

		public function TransformChannel3D(transform : Matrix4x4) 
		{
			super();
			if(transform==null)
			{
				transform=new Matrix4x4();
				transform.identity();
			}
			this.transform = transform;
		}

		override public function clone() : Channel3D 
		{
			var channel : TransformChannel3D = new TransformChannel3D(this.transform);
			var curve : Curve3D;
			var i : int;
			
			for(i = 0; i < _curves.length; i++)
			{
				curve = _curves[i];
				channel.addCurve(curve.clone(), (i == _curves.length-1));
			}
			return channel;
		}
	}
}
