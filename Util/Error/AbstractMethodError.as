package XGameEngine.Util.Error
{
	public class AbstractMethodError extends Error
	{
		public function AbstractMethodError(message:*="", id:*=0)
		{
			super("抽象方法", id);
		}
	}
}