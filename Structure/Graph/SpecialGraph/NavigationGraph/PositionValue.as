package XGameEngine.Structure.Graph.SpecialGraph.NavigationGraph
{
	import XGameEngine.Structure.Math.Vector2;

	/**
	 *默认的路点 
	 * @author Administrator
	 * 
	 */	
	public class PositionValue
	{
		public var realPostion:Vector2;
		public var indexX:int;
		public var indexY:int;
		public function PositionValue(v:Vector2,indexX:int,indexY:int)
		{
			this.realPostion=v;
			this.indexX=indexX;
			this.indexY=indexY;
		}
		
		public function toString():String
		{
			// TODO Auto Generated method stub
			return indexX+","+indexY;
		}
		
		
		
	}
}