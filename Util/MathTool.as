package XGameEngine.Util
{
	import XGameEngine.Structure.Math.Vector2;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author o
	 */
	public class  MathTool
	{
		
		
		
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
				return 0;
				//throw new Error("paramter can't be 0!");
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
		
	
		
		
		
		/**
		 *检查一个值是否在某个范围内  如果不在则报错 
		 * @param value
		 * @param min
		 * @param max
		 * 
		 */		
		public static function checkRange(value:Number, min:Number, max:Number):void
		{
			if (value>max)
			{
				throw new Error(value+">"+max);
			}
			else if(value<min)
			{
				throw new Error(value+"<"+min);
			}
			
		}
		
		
		
		/**
		 *收缩一个数的范围,如果小于最小值为最小值 大于最大值为最大值 
		 * @param value
		 * @param min
		 * @param max
		 * @return 
		 * 
		 */		
		static public function restrictRange(value:Number, min:Number, max:Number):Number
		{
			if (value< min)
			{
				return min;
			}
			if (value > max)
			{
				return max
			}
			
			return value;
		}
		
		
		/**
		 *返回两点间的夹角(第三个点默认第一个点的x值 第二个点的值) 
		 * @return 
		 * 
		 */		
		public static function getTwoPointRotation(p1:Point,p2:Point):Number
		{
			
			
			return Math.atan2(p2.y-p1.y,p2.x-p1.x)*180/Math.PI;
		}
		
		
		
		/**
		 *随机返回1或者-1 
		 * @return 
		 * 
		 */		
		public static function randomZF():Number
		{
			
			return Math.random()>=0.5?1:-1;
		}
		
		
		
		/**
		 *在一个范围内循环一个数 可以在一个loop循环中快速模拟常见的
		 * i++
		 * if(i>=4)
		 * {i=0}
		 * @param i 当前的值
		 * @param min 最小值
		 * @param max 最大值
		 * @param add 增加或者减去的值(可以是负值)
		 * @return 
		 * 
		 */		
		public static function loopValue(i:Number, min:Number, max:Number, add:Number):Number
		{
			var result:int=i;
			if(add>=0)
			{
				result+=add;
				if(result>max)
				{
					result=min+(result-max)-1;
				}
				
			}
			else
			{
				result+=add;
				if(result<0)
				{
					result=max-(min-result)+1;
				}
				
			}
			
			return result;
		}
	}
	
}