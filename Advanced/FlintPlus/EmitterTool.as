package XGameEngine.Advanced.FlintPlus
{
	import org.flintparticles.twoD.emitters.Emitter2D;

	public class EmitterTool
	{
		/**
		 *检查emitter是否准备好，否则报错 
		 * @param e
		 * 
		 */		
		public static function checkEmitter(e:Emitter2D):void
		{
			if(e.counter==null)
			{
				throw new Error("发射器的counter不能为Null!");
			}
			
		}
	}
}