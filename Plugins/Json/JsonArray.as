package XGameEngine.Plugins.Json
{
	import XGameEngine.Structure.List;

	public class JsonArray
	{
		private var jsonData:*;
		public function JsonArray(data:*)
		{
			//只有第一次传入字符串的时候才是真正的解析，后面的getJsonOject都是直接返回一个解析过的内层Object对象
			if(data is String)
			{
				this.jsonData=JSON.parse(data);
			}
			else
			{
				this.jsonData=data;
			}
			
			
			
		}
		
		public function toList():List
		{
			var list:List=new List();
			for(var i:int=0;i<jsonData.length;i++)
			{
				list.add(new JsonObject(jsonData[i]))
			}
			
			return list;
		}
	}
}