package XGameEngine.Plugins.Json
{
	public class JsonObject
	{
		private var jsonData:Object;
		public function JsonObject(data:*)
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
		
		public function getJsonOject(name:String):JsonObject
		{
			// TODO Auto Generated method stub
			return new JsonObject(jsonData[name]);
		}
		
		public function getJsonArray(name:String):JsonArray
		{
			// TODO Auto Generated method stub
			return new JsonArray(jsonData[name]);
		}
		
		public function getValue(name:String):*
		{
			return jsonData[name];
		}
	}
}