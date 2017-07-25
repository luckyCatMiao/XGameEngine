package XGameEngine.Util
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author o
	 */
	public class  MathTool
	{
		/**
		 * 
		 * @param rect
		 * @return 
		 * 
		 */		
		static public function rectToPointArray(rect:Rectangle):Vector.<Point>
		{
		var array:Vector.<Point> = new Vector.<Point>;
		array[0] = new Point(rect.x,rect.y);
		array[1] = new Point(rect.x+rect.width,rect.y);
		array[2] = new Point(rect.x,rect.y+rect.height);
		array[3] = new Point(rect.x+rect.width,rect.y+rect.height);
			
			return array;
		}
		
		
		
		/**
		 * 返回数的正负信息 正数返回1 负数返回-1 0报错
		 * @param	i
		 * @return
		 */
		static public function getPVMSG(i:Number):Number
		{
			
			if (i > 0)
			{
				return 1;
			}
			else if (i < 0)
			{
				return -1;
			}
			else
			{
				throw new Error("paramter can't be 0!");
			}
			
		}
		
		
		
		/**
		 * 根据第二个数的正负设置第一个数的正负 使两者相同
		 * @param	i
		 * @return
		 */
		static public function setNPNumber(i:Number,i2:Number):Number
		{
			if (i2 > 0)
			{
				i = Math.abs(i);
			}
			else if (i2 < 0)
			{
				i = Math.abs(i) * -1;
			}
			
			return i;
		}
		
		/**
		 *两个数是否正负相同? 
		 * @param value
		 * @param scaleX
		 * @return  相同返回1,不同返回-1
		 * 
		 */		
		public static function isSameZF(value1:Number, value2:Number):Number
		{
		 	//都大于0	
			if(value1>=0&&value2>=0)
			{
				return 1;
			}
			//都小于0
			else if(value1<0&&value2<0)
			{
				return 1;
			}
			//不相同
			else
			{
				return -1;
			}
			
		}
	}
	
}