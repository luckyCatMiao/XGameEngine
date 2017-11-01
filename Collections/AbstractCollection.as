package XGameEngine.Collections
{

	public class AbstractCollection
	{
		
		/**
		 *是否允许空值 
		 */		
		protected var flag_canNull:Boolean;
		/**
		 *是否允许重复值 
		 */		
		protected var flag_canSame:Boolean;
		/**
		 *比较是否相等的方法 
		 */		
		protected var comparefun:Function;
		
		
		
		public function AbstractCollection(flag_canNull:Boolean=false,flag_canSame:Boolean=false,comparefun:Function=null)
		{
			
			this.flag_canNull=flag_canNull;
			this.flag_canSame=flag_canSame;
			this.comparefun=comparefun;
		}
		
		
		
	}
}