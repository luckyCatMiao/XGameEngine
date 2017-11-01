package XGameEngine.Math
{
	/**
	 *包含两个Number
	 * @author Administrator
	 * 
	 */	
	public class Number2
	{
		public var v1:Number;
		public var v2:Number;
		public function Number2(v1:Number,v2:Number)
		{
				this.v1=v1;
				this.v2=v2;
		}
		
		/**
		 *检查是否v1比v2更大 不是的话则报错 
		 * 
		 */		
		public function checkBigger():void
		{
			if(v1>v2)
			{
				throw new Error();
			}
			
		}
		
		public function toString():String
		{
		
			return v1+" "+v2;
		}
		
		
	}
}