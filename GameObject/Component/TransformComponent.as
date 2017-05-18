package XGameEngine.GameObject.Component
{
	import XGameEngine.Util.MathTool;
	import XGameEngine.GameObject.BaseGameObject;
	
	/**
	 * ...
	 * @author o
	 */
	public class TransformComponent extends BaseComponent
	{
		
		private var oldWidth:Number;
		private var oldHeight:Number;
		private var oldScaleX:Number;
		private var oldScaleY:Number;
		
		public function TransformComponent(o:BaseGameObject)
		{
			super(o);
			oldWidth = host.width;
			oldHeight = host.height;
			oldScaleX = host.scaleX;
			oldScaleY = host.scaleY;
			
		}
		
		
		/**
		 * 设置X轴方向(不影响当前的缩放参数)
		 * @param	o
		 */
		public function setXAxis(d:Boolean)
		{
			var value:Number=MathTool.getPVMSG(oldScaleX);
			if (d)
			{
				//设置为正方向(即原始方向)
				host.scaleX=MathTool.setNPNumber(host.scaleX,value)
				
			}
			else
			{
				//设置为逆方向
				host.scaleX=MathTool.setNPNumber(host.scaleX,-value)
			}
		}
		
		
	}
	
}