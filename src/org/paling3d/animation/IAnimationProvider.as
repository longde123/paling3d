package org.paling3d.animation 
{
	import org.paling3d.controller.AnimationController;			/**	 * @author Tim Knip / floorplanner.com	 */	public interface IAnimationProvider 	{		/**		 * Gets /sets the animation controller.
		 * 
		 * @see lh3d.controller.AnimationController		 */
		function set animation(value : AnimationController) : void;
		function get animation() : AnimationController;	}}