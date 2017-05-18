package XGameEngine.GameObject.CommonComponent
{
	import XGameEngine.Structure.List;
	
	/**
	 * ...
	 * @author o
	 */
	public class FunComponent
	{
		
		private var delayFuns:List = new List();
		public function FunComponent()
		{
			
		}
		
		
		/**
		 * 添加一个延迟调用的方法 需要手动累计延迟值
		 * @param	string
		 * @param	number
		 * @param	addMoveEffect
		 * @param	array
		 */
		public function addRecallFun(string:String, number:Number, fun:Function, array:Array=null)
		{
			var r:ReCallFun = new ReCallFun();
			r.name = string;
			r.delay = number;
			r.currentSum = 0;
			r.recall = fun;
			r.params = array;
			for each(var f:ReCallFun in delayFuns.Raw)
			{
				if (r.name == string)
				{
					throw new Error("the name " + string + " has existed!");
				}
			}
			delayFuns.add(r);
		}
		
		public function AddInvokeTime(name:String):void 
		{
			for each(var f:ReCallFun in delayFuns.Raw)
			{
				if (f.currentSum % f.delay == 0)
				{
					if (f.params != null)
					{
						f.recall(f.params);
					}
					else
					{
						f.recall();
					}
					
				}
				f.currentSum++;
				
			}
		}
		
		
	}
	
}

class ReCallFun
{
	var name:String;
	var delay:Number;
	var currentSum:Number;
	var recall:Function;
	var params:Array;
}
