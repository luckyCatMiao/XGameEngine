package XGameEngine.Util
{
	
	/**
	 * ...
	 * @author o
	 */
	public class  CollectionUtil
	{
		
		
		static public function arrayToVectorInt(a:Array):Vector.<int>
		{
			var v:Vector.<int>=new Vector.<int>;
			var i:Number = 0;
			for each(var element:int in a)
			{
				v[i++] = element;

			}

			return v;
		}
	}
	
}