

package XGameEngine.Structure.Math.Zone
{
	

	import XGameEngine.Structure.Math.Vector2;
	
	import flash.geom.Point;

	/**
	 * The Zones interface must be implemented by all zones.
	 * 
	 * <p>A zone is a class that defined a region in 2d space. The two required methods 
	 * make it easy to get a random point within the zone and to find whether a specific
	 * point is within the zone. Zones are used to define the start location for particles
	 * (in the Position initializer), to define the start velocity for particles (in the
	 * Velocity initializer), and to define zones within which the particles die.</p>
	 */
	public interface Zone2D
	{
		/**
		 * Determines whether a point is inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @param x The x coordinate of the location to test for.
		 * @param y The y coordinate of the location to test for.
		 * @return true if point is inside the zone, false if it is outside.
		 */
		function contains( x:Number, y:Number ):Boolean;

		/**
		 * Returns a random point inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		function getLocation():Vector2;

		/**
		 * Returns the size of the zone.
		 * This method is used by the MultiZone class to manage the balancing between the
		 * different zones.
		 * 
		 * @return the size of the zone.
		 */
		function getArea():Number;
		
		
	}
}