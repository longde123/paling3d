package org.paling3d.animation.channel.transform 
{
	import org.paling3d.animation.curve.Curve3D;	
	import org.paling3d.animation.channel.Channel3D;	
	import org.paling3d.math.Matrix4x4;	
	import org.paling3d.animation.channel.transform.TransformChannel3D;
	
	/**
	 * @author Tim Knip / floorplanner.com
	 */
	public class MatrixChannel3D extends TransformChannel3D 
	{
		/**
		 * Constructor.
		 * 
		 * @param transform
		 */
		public function MatrixChannel3D(transform : Matrix4x4) 
		{
			super(transform);
		}
		
		/**
		 * 
		 */
		override public function clone() : Channel3D 
		{
			var channel : MatrixChannel3D = new MatrixChannel3D(this.transform);
			var curve : Curve3D;
			var i : int;
			
			for(i = 0; i < _curves.length; i++)
			{
				curve = _curves[i];
				channel.addCurve(curve.clone(), (i == _curves.length-1));
			}
			return channel;
		}
		
		/**
		 * 
		 */
		override public function update(time : Number) : void 
		{
			super.update(time);
			
			var i : int;
			var m : Matrix4x4 = this.transform;
			var curves : Array = _curves;
			var numCurves : int = curves.length;
			var props : Array = [
				"_11", "_12", "_13", "_14",
				"_21", "_22", "_23", "_24",
				"_31", "_32", "_33", "_34",
				"_41", "_42", "_43", "_44"
			];
			
			if(curves && numCurves > 11)
			{
				for(i = 0; i < numCurves; i++)
				{
					m[ props[i] ] = output[i];
				}
			}
		}
	}
}
