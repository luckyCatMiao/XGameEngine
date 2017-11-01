package XGameEngine.Math.Shape
{
import XGameEngine.Collections.Math.Shape.*;
import XGameEngine.Math.Vector2;

import flash.geom.Point;

/**
	 * The LineShape zone defines a zone that contains all the points on a line.
	 */

	public class LineShape implements BaseShape
	{
		private var _start:Point;
		private var _end:Point;
		private var _length:Point;
		private var _normal:Point;
		private var _parallel:Point;
		
		/**
		 * The constructor creates a LineShape zone.
		 * 
		 * @param start The point at one end of the line.
		 * @param end The point at the other end of the line.
		 */
		public function LineShape(start:Point = null, end:Point = null )
		{
			if( start == null )
			{
				_start = new Point( 0, 0 );
			}
			else
			{
				_start = start;
			}
			if( end == null )
			{
				_end = new Point( 0, 0 );
			}
			else
			{
				_end = end;
			}
			setLengthAndNormal();
		}
		
		private function setLengthAndNormal():void
		{
			_length = _end.subtract( _start );
			_parallel = _length.clone();
			_parallel.normalize( 1 );
			_normal = new Point( _parallel.y, - _parallel.x );
		}
		
		/**
		 * The point at one end of the line.
		 */
		public function get start() : Point
		{
			return _start;
		}

		public function set start( value : Point ) : void
		{
			_start = value;
			setLengthAndNormal();
		}

		/**
		 * The point at the other end of the line.
		 */
		public function get end() : Point
		{
			return _end;
		}

		public function set end( value : Point ) : void
		{
			_end = value;
			setLengthAndNormal();
		}

		/**
		 * The x coordinate of the point at the start of the line.
		 */
		public function get startX() : Number
		{
			return _start.x;
		}

		public function set startX( value : Number ) : void
		{
			_start.x = value;
			_length = _end.subtract( _start );
		}

		/**
		 * The y coordinate of the point at the start of the line.
		 */
		public function get startY() : Number
		{
			return _start.y;
		}

		public function set startY( value : Number ) : void
		{
			_start.y = value;
			_length = _end.subtract( _start );
		}

		/**
		 * The x coordinate of the point at the end of the line.
		 */
		public function get endX() : Number
		{
			return _end.x;
		}

		public function set endX( value : Number ) : void
		{
			_end.x = value;
			_length = _end.subtract( _start );
		}

		/**
		 * The y coordinate of the point at the end of the line.
		 */
		public function get endY() : Number
		{
			return _end.y;
		}

		public function set endY( value : Number ) : void
		{
			_end.y = value;
			_length = _end.subtract( _start );
		}

		/**
		 * @inheritDoc
		 */
		public function contains( x:Number, y:Number ):Boolean
		{
			// not on line if dot product with perpendicular is not zero
			if ( ( x - _start.x ) * _length.y - ( y - _start.y ) * _length.x != 0 )
			{
				return false;
			}
			// is it between the points, dot product of the vectors towards each point is negative
			return ( x - _start.x ) * ( x - _end.x ) + ( y - _start.y ) * ( y - _end.y ) <= 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLocation():Vector2
		{
			var ret:Point = _start.clone();
			var scale:Number = Math.random();
			ret.x += _length.x * scale;
			ret.y += _length.y * scale;
			
			
			return Vector2.pointToV2(ret);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getArea():Number
		{
			// treat as one pixel tall rectangle
			return _length.length;
		}

	
	}
}
