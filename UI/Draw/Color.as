package XGameEngine.UI.Draw
{
	
	/**
	 * ...
	 * @author o
	 */
	public class Color 
	{
		static public var WHITE:uint = 0xffffffff; 
		
		static public var RED:uint = 0xffff0000;
		
		static public var GREEN:uint = 0xff00ff00;
		
		static public var BLACK:uint = 0xff000000;
		
		static public var YELLOW:uint = 0xffffff00;
		
		static public var BLUE:uint = 0xff0000ff;
		
		
		
		public var a:int;
		public var r:int;
		public var g:int;
		public var b:int;
		
		
		
		
		/**
		 * 
		 * @param argb
		 * @param rgb 输入值是rgb还是argb
		 * 
		 */		
		public function Color(argb:uint,rgb:Boolean=false)
		{
			
			if(rgb)
			{
				 a=255;
				 this.r=(argb&0x00ff0000)>>16;
				 this.g=(argb&0x0000ff00)>>8;
				 this.b=(argb&0x000000ff);
			}
			else
			{
				this.a=(argb&0xff000000)>>24;
				this.r=(argb&0x00ff0000)>>16;
				this.g=(argb&0x0000ff00)>>8;
				this.b=(argb&0x000000ff);
			}
		
			
		
		}
		
		
		public function toARGBUint():uint
		{
			
			return a<<24|r<<16|g<<8|b;
			
			
		}
		
		
		public function toRGBUint():uint
		{
			
			return r<<16|g<<8|b;
			
			
		}
		
	}
	
}