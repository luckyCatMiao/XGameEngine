package XGameEngine.Structure.Math.Zone
{
	
	import XGameEngine.Structure.Math.Vector2;
	
	import flash.geom.Point;

	/**
	 * The MutiZone zone defines a zone that combines other zones into one larger zone.
	 */

	public class MultiZone implements Zone2D 
	{
		private var _zones : Array;
		private var _areas : Array;
		private var _totalArea : Number;
		
		/**
		 * The constructor defines a MultiZone zone.
		 */
		public function MultiZone()
		{
			_zones = new Array();
			_areas = new Array();
			_totalArea = 0;
		}
		
		/**
		 * The addZone method is used to add a zone into this MultiZone object.
		 * 
		 * @param zone The zone you want to add.
		 */
		public function addZone( zone:Zone2D ):void
		{
			_zones.push( zone );
			var area:Number = zone.getArea();
			_areas.push( area );
			_totalArea += area;
		}
		
		/**
		 * The removeZone method is used to remove a zone from this MultiZone object.
		 * 
		 * @param zone The zone you want to add.
		 */
		public function removeZone( zone:Zone2D ):void
		{
			var len:int = _zones.length;
			for( var i:int = 0; i < len; ++i )
			{
				if( _zones[i] == zone )
				{
					_totalArea -= _areas[i];
					_areas.splice( i, 1 );
					_zones.splice( i, 1 );
					return;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains( x:Number, y:Number ):Boolean
		{
			var len:int = _zones.length;
			for( var i:int = 0; i < len; ++i )
			{
				if( Zone2D( _zones[i] ).contains( x, y ) )
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLocation():Vector2
		{
			var selectZone:Number = Math.random() * _totalArea;
			var len:int = _zones.length;
			for( var i:int = 0; i < len; ++i )
			{
				if( ( selectZone -= _areas[i] ) <= 0 )
				{
					return Vector2.pointToV2(Zone2D( _zones[i] ).getLocation());
				}
			}
			if( _zones.length == 0 )
			{
				throw new Error( "Attempt to use a MultiZone object that contains no Zones" );
			}
			else
			{
				return Vector2.pointToV2(Zone2D( _zones[0] ).getLocation());
			}
			
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getArea():Number
		{
			return _totalArea;
		}
		
		
	}
}
