package XGameEngine.Math.Function
{
	import XGameEngine.Constant.Error.ParamaterError;
	import XGameEngine.Collections.List;
	import XGameEngine.Math.Vector2;

	public class FunctionTool
	{
		
		/**
		 *获取两个函数的交点(返回0至多个)  
		 * @param f1 函数1
		 * @param f2 函数2
		 * @return 
		 * 
		 */		
		static public function getFunctionCrossPoints(f1:AbstracrtFunction,f2:AbstracrtFunction):List
		{
			//根据函数的类型特殊处理
			
			//求两个一次函数的交点
			if(f1 is LinearFunction&&f2 is LinearFunction)
			{
				return getTwoLinearFunCrossPoints(f1 as LinearFunction,f2 as LinearFunction);
			}
			else
			{
				throw new ParamaterError();
			}
			
		
		}
		
		/**
		 *求两个一次函数的交点 
		 * @return 
		 * 
		 */		
		private static function getTwoLinearFunCrossPoints(f1:LinearFunction,f2:LinearFunction):List
		{
			var list:List=new List();
			//如果斜率相同则返回空 否则后面会出现除0错误
			if(f1.k==f2.k)
			{
				return list;
			}
			else
			{
			//公式化简后为x=(b2-b1)/(k1-k2)
			var x:Number=(f2.b-f1.b)/(f1.k-f2.k);
			
			
			//计算出来的结果需要同时在两个函数的定义域内(如果在定义域内就在值域内,所以只用测试定义域)
			if(f1.checkInDYRange(x)==true&&f2.checkInDYRange(x)==true)
			{
				var y:Number=f1.getY(x);
				list.add(new Vector2(x,y));
				
			}
			
			}
			
			
			return list;
		}
		
	}
}