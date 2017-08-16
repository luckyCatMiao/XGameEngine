package XGameEngine.BaseObject.BaseComponent.Render.Filtters
{
	import XGameEngine.BaseObject.BaseComponent.Render.RenderComponent;
	import XGameEngine.Constant.Error.AbstractMethodError;
	import XGameEngine.Manager.TweenManager;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	
	import flash.filters.BitmapFilter;

	/**
	 *原始filtter的包装类 
	 * @author Administrator
	 * 
	 */	
	public class AbstractFiltter
	{
		
		protected var _fliter:BitmapFilter;
		public var host:RenderComponent;
		
		
		protected function applyChange():void
		{
			if(host!=null)
			{
				host.parseFilter();
			}
			
		}
		
		public function get fliter():BitmapFilter
		{
			return _fliter;
		}
		
		
		/**
		 *对滤镜的属性值进行tween 
		 * @param fieldName
		 * @param fun
		 * @param fieldChange
		 * @param lastTime
		 * @param delay
		 * @return 
		 * 
		 */		
		public function playTween(fieldName:String, fun:Function, fieldChange:Number,lastTime:int,delay:int=0)
		{
			
			var tween:Tween=TweenManager.getInstance().playTween(_fliter,fieldName, fun, fieldChange,lastTime,delay)
			tween.addEventListener(TweenEvent.MOTION_CHANGE,valueChange);
			
			return tween;
		}
		
		protected function valueChange(event:TweenEvent):void
		{
			applyChange();
			
		}
	}
}