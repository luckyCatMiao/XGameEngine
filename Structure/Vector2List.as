package XGameEngine.Structure
{
	import XGameEngine.Structure.Math.Vector2;

	/**
	 *因为比较常用 as3又没有泛型 所以单独建立一个类  
	 * @author Administrator
	 * 
	 */	
	public class Vector2List
	{
		private var list:List;
		public function Vector2List(flag_canNull:Boolean=false,flag_canSame:Boolean=false,comparefun:Function=null)
		{
			this.list=new List(flag_canNull,flag_canSame,comparefun);
		}
		
		public function add(x:Number, y:Number):void
		{
			addVector2(new Vector2(x,y));
			
		}
		public function addVector2(v:Vector2):void
		{
			
			list.add(v);
		}
		
		
		public function get size():int
		{
			return list.size;
		}
		
		public function get(index:int):Vector2
		{
			return list.get(index) as Vector2;
		}
	}
}