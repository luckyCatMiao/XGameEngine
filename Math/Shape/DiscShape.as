package XGameEngine.Math.Shape
{
import XGameEngine.Math.Vector2;

import flash.geom.Point;

/**
	 * The DiscShape zone defines a circular zone. The zone may
	 * have a hole in the middle, like a doughnut.
	 */

	public class DiscShape implements BaseShape
	{
		private var _center:Point;
		private var _innerRadius:Number;
		private var _outerRadius:Number;
		private var _innerSq:Number;
		private var _outerSq:Number;
		
		private static const TWOPI:Number = Math.PI * 2;
		
		/**
		 * The constructor defines a DiscShape zone.
		 * 
		 * @param center The centre of the disc.
		 * @param outerRadius The radius of the outer edge of the disc.
		 * @param innerRadius If set, this defines the radius of the inner
		 * edge of the disc. Points closer to the center than this inner radius
		 * are excluded from the zone. If this parameter is not set then all 
		 * points inside the outer radius are included in the zone.
		 */
		public function DiscShape(center:Point = null, outerRadius:Number = 0, innerRadius:Number = 0 )
		{
			if( outerRadius < innerRadius )
			{
				throw new Error( "The outerRadius (" + outerRadius + ") can't be smaller than the innerRadius (" + innerRadius + ") in your DiscShape. N.B. the outerRadius is the second argument in the constructor and the innerRadius is the third argument." );
			}
			if( center == null )
			{
				_center = new Point( 0, 0 );
			}
			else
			{
			_center = center;
			}
			_innerRadius = innerRadius;
			_outerRadius = outerRadius;
			_innerSq = _innerRadius * _innerRadius;
			_outerSq = _outerRadius * _outerRadius;
		}
		
		/**
		 * The centre of the disc.
		 */
		public function get center() : Point
		{
			return _center;
		}

		public function set center( value : Point ) : void
		{
			_center = value;
		}

		/**
		 * The x coordinate of the point that is the center of the disc.
		 */
		public function get centerX() : Number
		{
			return _center.x;
		}

		public function set centerX( value : Number ) : void
		{
			_center.x = value;
		}

		/**
		 * The y coordinate of the point that is the center of the disc.
		 */
		public function get centerY() : Number
		{
			return _center.y;
		}

		public function set centerY( value : Number ) : void
		{
			_center.y = value;
		}

		/**
		 * The radius of the inner edge of the disc.
		 */
		public function get innerRadius() : Number
		{
			return _innerRadius;
		}

		public function set innerRadius( value : Number ) : void
		{
			_innerRadius = value;
			_innerSq = _innerRadius * _innerRadius;
		}

		/**
		 * The radius of the outer edge of the disc.
		 */
		public function get outerRadius() : Number
		{
			return _outerRadius;
		}

		public function set outerRadius( value : Number ) : void
		{
			_outerRadius = value;
			_outerSq = _outerRadius * _outerRadius;
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
			x -= _center.x;
			y -= _center.y;
			var distSq:Number = x * x + y * y;
			return distSq <= _outerSq && distSq >= _innerSq;
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
			var rand:Number = Math.random();
			var point:Point =  Point.polar( _innerRadius + (1 - rand * rand ) * ( _outerRadius - _innerRadius ), Math.random() * TWOPI );
			point.x += _center.x;
			point.y += _center.y;
			return Vector2.pointToV2(point);
		}
		
		/**
		 * The getArea method returns the size of the zone.
		 * This method is used by the MultiShape class. Usually,
		 * it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getArea():Number
		{
			return Math.PI * ( _outerSq - _innerSq );
		}
		
		

	}
}
