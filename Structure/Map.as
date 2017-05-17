package XGameEngine.Structure
{
	
	/**
	 * ...
	 * @author o
	 */
	public class Map 
	{
		private var map:Object = new Object();
		
		public function put(key:Object, value:Object)
		{
			map[key] = value;
		}
		
		
		public function get(key:Object):Object
		{
			
			var value:Object = map[key];
			checkNull(key,value);
			
			return value;
		}
		
		
		public function checkNull(key:Object,value:Object)
		{
			if (key == null)
			{
				throw new Error("the key " + key + " is null!");
			}
			
			
		}
		
		public function get size():int
		{
			return Keys.length;
		}
		
		
		/**
		 * because the as3 don't support customize foreach which supported in java,c# that just implements the iterable interface
		 * ,in order to don't destroy the native foreach only support by array,object in as3,we need to return the raw data
		 * @return
		 */
		public function get rawData():Object
		{
			
			
			return map;
		}
		
		
		public function get Keys():Array
		{
			var arr = [];
			for (var name:String in map)
			{
			arr.push(name);	
			}
			
			
			return arr;
		}
		
	}
	
}