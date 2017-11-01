package XGameEngine.Collections
{
	
	/**
	 *队列 先进先出 
	 * @author Administrator
	 * 
	 */	
	public class Quene
	{
		private var list:List;
		public function Quene(flag_canNull:Boolean=false,flag_canSame:Boolean=false,comparefun:Function=null)
		{
			this.list=new List(flag_canNull,flag_canSame,comparefun);
		}
		
		public function add(o:Object)
		{
			list.add(o);
		}
		
		public function remove():Object
		{
			var o:Object=list.get(list.size-1);
			
			list.remove(o);
			return o;
		}
		
		public function peak():Object
		{
			return list.get(list.size-1);
		}
	}
}