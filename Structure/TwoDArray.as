package XGameEngine.Structure
{
	import XGameEngine.Constant.Error.ParamaterError;

	/**
	 *二维数组 
	 * @author Administrator
	 * 
	 */	
	public class TwoDArray
	{
		
		public static function createByTwoDArray(arr:Array):TwoDArray
		{
			//原始数组必须本质上也是一个二维数组
			if(!(arr[0] is Array))
			{
				throw new ParamaterError();
			}
		
			var twoDArray:TwoDArray=new TwoDArray((arr[0] as Array).length,	arr.length);
			var l:int=(arr[0] as Array).length;
			for(var y:int=0;y<arr.length;y++)
			{
				//每一行的元素个数必须相同
				if((arr[y] as Array).length!=l)
				{
					throw new ParamaterError();
				}
				for(var x:int=0;x<(arr[0] as Array).length;x++)
				{
					
					twoDArray.add(x,y,arr[y][x]);
				}
			}
			
			
			return twoDArray;
		}
		
		/**
		 *根据一维数组创建二维数组 
		 * @param arr 一维数组
		 * @param column 列数
		 * @return 
		 * 
		 */		
		public static function createByOneDArray(arr:Array,column:int,row:int):TwoDArray
		{
			//验证长度
			if(arr.length!=column*row)
			{
				throw new Error("数组长度不对");
			}
			
			var twoDArray:TwoDArray=new TwoDArray(column,row);
		
			for(var i:int=0;i<arr.length;i++)
			{
			
				var y:int=i/column;
				var x:int=i%column;
				

					
			    twoDArray.add(x,y,arr[i]);
		
			}
			
			
			return twoDArray;
		}
		
		
		
		/**
		 *列数 
		 */		
		private var _column:int;
		/**
		 *行数 
		 */		
		private var _row:int;
		private var array:Array;
		/**
		 *二维数组 
		 * @param column 列数
		 * @param row 行数
		 * 
		 */		
		public function TwoDArray(column:int,row:int)
		{
			
			this._column=column;
			this._row=row;
			
			initArray();
		}
		
		private function initArray():void
		{
			this.array=new Array();
			for(var i=0;i<row;i++)
			{
				array[i]=new Array();
			}
			
		}
		
		
		public function add(x:int,y:int,value:Object):void
		{
			checkIndex(x,0,_column);
			checkIndex(y,0,_row);
			array[y][x]=value;
		}
		
		/**
		 *检查索引 
		 * @param column
		 * @param param1
		 * @param _column
		 * 
		 */		
		private function checkIndex(value:int, min:int, max:int):void
		{
			if(value<min||value>=max)
			{
				throw new Error("索引越界:"+value+",合法范围:"+min+"~"+max);
			}
			
		}
		
		public function get(x:int,y:int):Object
		{
			checkIndex(x,0,_column);
			checkIndex(y,0,_row);
			
			return array[y][x];
		}
		
		public function clear()
		{
			initArray();
		}
		
		public function get row():int
		{
			return _row;
		}

		public function get column():int
		{
			return _column;
		}

	
		
		public function toString():String
		{
			var s:String="";
			for(var i:int=0;i<_row;i++)
			{
				s+=array[i].toString()+"\n";
			}
			
			
			return s;
			
		}
		
		
		
		/**
		 *转换为一维数组 (从左到右 从上到下的顺序)
		 * @return 
		 * 
		 */		
		public function ToODArray():Array
		{
			var arr:Array=new Array();
			
			for(var y:int=0;y<row;y++)
			{
				for(var x:int=0;x<column;x++)
				{
					arr.push(get(x,y));
				}
			}
			
			
			return arr;
		}
	}
}