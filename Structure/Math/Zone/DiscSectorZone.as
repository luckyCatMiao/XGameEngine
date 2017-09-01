package XGameEngine.Structure.Math.Zone
{
	

	import XGameEngine.Structure.Math.Vector2;
	
	import flash.geom.Point;

	/**
	 * The DiscSectorZone zone defines a section of a Disc zone. The disc
	 * on which it's based have a hole in the middle, like a doughnut.
	 */

	public class DiscSectorZone implements Zone2D 
	{
		private var _center:Point;
		private var _innerRadius:Number;
		private var _outerRadius:Number;
		private var _innerSq:Number;
		private var _outerSq:Number;
		private var _minAngle:Number;
		private var _maxAngle:Number;
		private var _minAllowed:Number;
		private var _minNormal:Point;
		private var _maxNormal:Point;
		
		private static var TWOPI:Number = Math.PI * 2;
		
		/**
		 * The constructor defines a DiscSectorZone zone.
		 * 
		 * @param center The centre of the disc.
		 * @param outerRadius The radius of the outer edge of the disc.
		 * @param innerRadius If set, this defines the radius of the inner
		 * edge of the disc. Points closer to the center than this inner radius
		 * are excluded from the zone. If this parameter is not set then all 
		 * points inside the outer radius are included in the zone.
		 * @param minAngle The minimum angle, in radians, for points to be included in the zone.
		 * An angle of zero is horizontal and to the right. Positive angles are in a clockwise 
		 * direction (towards the graphical y axis). Angles are converted to a value between 0 
		 * and two times PI.
		 * @param maxAngle The maximum angle, in radians, for points to be included in the zone.
		 * An angle of zero is horizontal and to the right. Positive angles are in a clockwise 
		 * direction (towards the graphical y axis). Angles are converted to a value between 0 
		 * and two times PI.
		 */
		public function DiscSectorZone( center:Point = null, outerRadius:Number = 0, innerRadius:Number = 0, minAngle:Number = 0, maxAngle:Number = 0 )
		{
			if( outerRadius < innerRadius )
			{
				throw new Error( "The outerRadius (" + outerRadius + ") can't be smaller than the innerRadius (" + innerRadius + ") in your DiscSectorZone. N.B. the outerRadius is the second argument in the constructor and the innerRadius is the third argument." );
			}
			_center = center ? center.clone() : new Point( 0, 0 );
			_innerRadius = innerRadius;
			_outerRadius = outerRadius;
			_innerSq = _innerRadius * _innerRadius;
			_outerSq = _outerRadius * _outerRadius;
			_minAngle = minAngle;
			_maxAngle = maxAngle;
			if( ! isNaN( _maxAngle ) )
			{
				while ( _maxAngle > TWOPI )
				{
					_maxAngle -= TWOPI;
				}
				while ( _maxAngle < 0 )
				{
					_maxAngle += TWOPI;
				}
				_minAllowed = _maxAngle - TWOPI;
				if( ! isNaN( _minAngle ) )
				{
					if ( minAngle == maxAngle )
					{
						_minAngle = _maxAngle;
					}
					else
					{
						_minAngle = clamp( _minAngle );
					}
				}
				calculateNormals();
			}
		}
		
		private function clamp( angle:Number ):Number
		{
			if( ! isNaN( _maxAngle ) )
			{
				while ( angle > _maxAngle )
				{
					angle -= TWOPI;
				}
				while ( angle < _minAllowed )
				{
					angle += TWOPI;
				}
			}
			return angle;
		}
		
		private function calculateNormals():void
		{
			if( ! isNaN( _minAngle ) )
			{
				_minNormal = new Point( Math.sin( _minAngle ), - Math.cos( _minAngle ) );
				_minNormal.normalize( 1 );
			}
			if( ! isNaN( _maxAngle ) )
			{
				_maxNormal = new Point( - Math.sin( _maxAngle ), Math.cos( _maxAngle ) );
				_maxNormal.normalize( 1 );
			}
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
		 * The minimum angle, in radians, for points to be included in the zone.
		 * An angle of zero is horizontal and to the right. Positive angles are in a clockwise 
		 * direction (towards the graphical y axis). Angles are converted to a value between 0 
		 * and two times PI.
		 */
		public function get minAngle() : Number
		{
			return _minAngle;
		}

		public function set minAngle( value : Number ) : void
		{
			_minAngle = clamp( value );
			calculateNormals();
		}

		/**
		 * The maximum angle, in radians, for points to be included in the zone.
		 * An angle of zero is horizontal and to the right. Positive angles are in a clockwise 
		 * direction (towards the graphical y axis). Angles are converted to a value between 0 
		 * and two times PI.
		 */
		public function get maxAngle() : Number
		{
			return _maxAngle;
		}

		public function set maxAngle( value : Number ) : void
		{
			_maxAngle = value;
			while ( _maxAngle > TWOPI )
			{
				_maxAngle -= TWOPI;
			}
			while ( _maxAngle < 0 )
			{
				_maxAngle += TWOPI;
			}
			_minAllowed = _maxAngle - TWOPI;
			_minAngle = clamp( _minAngle );
			calculateNormals();
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
			if ( distSq > _outerSq || distSq < _innerSq )
			{
				return false;
			}
			var angle:Number = Math.atan2( y, x );
			angle = clamp( angle );
			return angle >= _minAngle;
		}
		
		/**
		 * The getLocation method returns a random point inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getLocation():Point
		{
			var rand:Number = Math.random();
			var point:Point =  Point.polar( _innerRadius + (1 - rand * rand ) * ( _outerRadius - _innerRadius ), _minAngle + Math.random() * ( _maxAngle - _minAngle ) );
			point.x += _center.x;
			point.y += _center.y;
			return Vector2.pointToV2(point);
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
			return ( _outerSq - _innerSq ) * ( _maxAngle - _minAngle ) * 0.5;
		}

		
	}
}
