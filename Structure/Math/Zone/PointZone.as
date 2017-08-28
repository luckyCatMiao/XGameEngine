package XGameEngine.Structure.Math.Zone
{
	

	import XGameEngine.Structure.Math.Vector2;
	
	import flash.geom.Point;

	/**
	 * The PointZone zone defines a zone that contains a single point.
	 */

	public class PointZone implements Zone2D
	{
		private var _point:Point;
		
		/**
		 * The constructor defines a PointZone zone.
		 * 
		 * @param point The point that is the zone.
		 */
		public function PointZone( point:Point = null )
		{
			if( point == null )
			{
				_point = new Point( 0, 0 );
			}
			else
			{
			_point = point;
		}
		}
		
		/**
		 * The point that is the zone.
		 */
		public function get point() : Point
		{
			return _point;
		}

		public function set point( value : Point ) : void
		{
			_point = value;
		}

		/**
		 * The x coordinate of the point that is the zone.
		 */
		public function get x() : Number
		{
			return _point.x;
		}

		public function set x( value : Number ) : void
		{
			_point.x = value;
		}

		/**
		 * The y coordinate of the point that is the zone.
		 */
		public function get y() : Number
		{
			return _point.y;
		}

		public function set y( value : Number ) : void
		{
			_point.y = value;
		}

		/**
		 * The contains method determines whether a point is inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @param x The x coordinate of the location to test for.
		 * @param y The y coordinate of the location to test for.
		 * @return true if point is inside the zone, false if it is outside.
		 */
		public function contains( x:Number, y:Number ):Boolean
		{
			return _point.x == x && _point.y == y;
		}
		
		/**
		 * The getLocation method returns a random point inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getLocation():Vector2
		{
			return new Vector2(x,y);
		}
		
		/**
		 * The getArea method returns the size of the zone.
		 * This method is used by the MultiZone class. Usually, 
		 * it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getArea():Number
		{
			// treat as one pixel square
			return 1;
		}

	
	}
}
