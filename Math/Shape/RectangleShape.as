
package XGameEngine.Math.Shape
{
import XGameEngine.Math.Rect;
import XGameEngine.Math.Vector2;

import flash.geom.Point;

/**
	 * The RectangleShape zone defines a rectangular shaped zone.
	 */

	public class RectangleShape implements BaseShape
	{
		private var _left : Number;
		private var _top : Number;
		private var _right : Number;
		private var _bottom : Number;
		private var _width : Number;
		private var _height : Number;
		
		static public function createZoneByRect(r:Rect):RectangleShape
		{
			var z:RectangleShape=new RectangleShape(r.x,r.y,r.x+r.width,r.y+r.height);
			
			return z;
		}
		
		/**
		 * The constructor creates a RectangleShape zone.
		 * 
		 * @param left The left coordinate of the rectangle defining the region of the zone.
		 * @param top The top coordinate of the rectangle defining the region of the zone.
		 * @param right The right coordinate of the rectangle defining the region of the zone.
		 * @param bottom The bottom coordinate of the rectangle defining the region of the zone.
		 */
		public function RectangleShape(left:Number = 0, top:Number = 0, right:Number = 0, bottom:Number = 0 )
		{
			
			
			_left = left;
			_top = top;
			_right = right;
			_bottom = bottom;
			_width = right - left;
			_height = bottom - top;
		}
		
		
		
		/**
		 * The left coordinate of the rectangle defining the region of the zone.
		 */
		public function get left() : Number
		{
			return _left;
		}

		public function set left( value : Number ) : void
		{
			_left = value;
			if( !isNaN( _right ) && !isNaN( _left ) )
			{
				_width = right - left;
			}
		}

		/**
		 * The right coordinate of the rectangle defining the region of the zone.
		 */
		public function get right() : Number
		{
			return _right;
		}

		public function set right( value : Number ) : void
		{
			_right = value;
			if( !isNaN( _right ) && !isNaN( _left ) )
			{
				_width = right - left;
			}
		}

		/**
		 * The top coordinate of the rectangle defining the region of the zone.
		 */
		public function get top() : Number
		{
			return _top;
		}

		public function set top( value : Number ) : void
		{
			_top = value;
			if( !isNaN( _top ) && !isNaN( _bottom ) )
			{
				_height = bottom - top;
			}
		}

		/**
		 * The bottom coordinate of the rectangle defining the region of the zone.
		 */
		public function get bottom() : Number
		{
			return _bottom;
		}

		public function set bottom( value : Number ) : void
		{
			_bottom = value;
			if( !isNaN( _top ) && !isNaN( _bottom ) )
			{
				_height = bottom - top;
			}
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
			return x >= _left && x <= _right && y >= _top && y <= _bottom;
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
			return Vector2.pointToV2(new Point( _left + Math.random() * _width, _top + Math.random() * _height ));
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
			return _width * _height;
		}

		
	}
}
