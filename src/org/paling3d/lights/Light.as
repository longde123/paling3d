package org.paling3d.lights
{
	import org.paling3d.math.Vector3D;
	import org.paling3d.materials.Color;

	public class Light
	{
		public var position :  Vector3D;
		public var color : Color;
		public var directional : Boolean;
		public var power : Number;
		public function Light(pos:  Vector3D,color: Color,directional: Boolean,power: Number=1.0) {
			this.position = pos;
			this.color = color;
			this.directional = directional;
			this.power = power;
		}
	}
}