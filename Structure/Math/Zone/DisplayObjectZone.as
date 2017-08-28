package XGameEngine.Structure.Math.Zone
{
	
	import XGameEngine.Structure.Math.Vector2;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * The DisplayObjectZone zone defines a shaped zone based on a DisplayObject.
	 * The zone contains the shape of the DisplayObject. The DisplayObject must be
	 * on the stage for it to be used, since it's position on stage determines the 
	 * position of the zone.
	 */

	public class DisplayObjectZone implements Zone2D
	{
		private var _displayObject : DisplayObject;
		private var _renderer : DisplayObject;
		private var _area : Number;

		
		/**
		 * The constructor creates a DisplayObjectZone object.
		 * 
		 * @param displayObject The DisplayObject that defines the zone.
		 * @param emitter The renderer that you plan to use the zone with. The 
		 * coordinates of the DisplayObject are translated to the local coordinate 
		 * space of the renderer.
		 */
		public function DisplayObjectZone( displayObject : DisplayObject)
		{
			_displayObject = displayObject;
		
			calculateArea();
		}
			
		private function calculateArea():void
		{
			if( ! _displayObject )
			{
				return;
			}
			
			var bounds:Rectangle = _displayObject.getBounds( _displayObject.stage );
			
			_area = 0;
			var right:Number = bounds.right;
			var bottom:Number = bounds.bottom;
			for( var x : int = bounds.left; x <= right ; ++x )
			{
				for( var y : int = bounds.top; y <= bottom ; ++y )
				{
					if ( _displayObject.hitTestPoint( x, y, true ) )
					{
						++_area;
					}
				}
			}
		}

		/**
		 * The DisplayObject that defines the zone.
		 */
		public function get displayObject() : DisplayObject
		{
			return _displayObject;
		}
		public function set displayObject( value : DisplayObject ) : void
		{
			_displayObject = value;
			calculateArea();
		}

		/**
		 * The contains method determines whether a point is inside the zone.
		 * 
		 * @param point The location to test for.
		 * @return true if point is inside the zone, false if it is outside.
		 */
		public function contains( x : Number, y : Number ) : Boolean
		{
			var point:Point = new Point( x, y );
			point = _renderer.localToGlobal( point );
			return _displayObject.hitTestPoint( point.x, point.y, true );
		}

		/**
		 * The getLocation method returns a random point inside the zone.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getLocation() : Vector2
		{
			var bounds:Rectangle = _displayObject.getBounds( _displayObject.root );
			do
			{
				var x : Number = bounds.left + Math.random( ) * bounds.width;
				var y : Number = bounds.top + Math.random( ) * bounds.height;
			}
			while( !_displayObject.hitTestPoint( x, y, true ) );
			var point:Point = new Point( x, y );
			point = displayObject.root.localToGlobal( point);
			return Vector2.pointToV2(point);
		}

		/**
		 * The getArea method returns the size of the zone.
		 * It's used by the MultiZone class to manage the balancing between the
		 * different zones.
		 * 
		 * @return the size of the zone.
		 */
		public function getArea() : Number
		{
			return _area;
		}

		
	}
}
