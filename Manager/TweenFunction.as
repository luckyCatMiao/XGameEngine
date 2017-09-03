package XGameEngine.Manager
{
	import fl.motion.easing.Back;
	import fl.motion.easing.Linear;
	import fl.motion.easing.Quadratic;

	/**
	 *tween数值的变化方法 
	 * @author Administrator
	 * 
	 */	
	public class TweenFunction
	{
		/**
		 *线性变化 
		 * @return 
		 * 
		 */		
		public static function get linear():Function
		{
			return Linear.easeIn;
		}
		
		
		/**
		 *具有弹性 即会超出目标点再返回
		 * @return 
		 * 
		 */		
		public static function get springIn():Function
		{
			return Back.easeIn;
		}
		
		/**
		 *具有弹性 即会超出目标点再返回
		 * @return 
		 * 
		 */		
		public static function get springOut():Function
		{
			return Back.easeOut;
		}
		
		/**
		 *具有弹性 即会超出目标点再返回
		 * @return 
		 * 
		 */		
		public static function get springInOut():Function
		{
			return Back.easeInOut;
		}
		
		/**
		 *正常的缓动 
		 * @return 
		 * 
		 */		
		public static function get hdIn():Function
		{
			return Quadratic.easeIn;
		}
		
		/**
		 *正常的缓动 
		 * @return 
		 * 
		 */	
		public static function get hdOut():Function
		{
			return Quadratic.easeOut;
		}
		
		/**
		 *正常的缓动 
		 * @return 
		 * 
		 */	
		public static function get hdInOut():Function
		{
			return Quadratic.easeInOut;
		}
	}
}