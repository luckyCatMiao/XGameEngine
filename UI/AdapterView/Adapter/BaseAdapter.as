package XGameEngine.UI.AdapterView.Adapter
{
	import XGameEngine.UI.AdapterView.BaseAdapterView;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class BaseAdapter
	{
		
		public var adapterView:BaseAdapterView;
		public function BaseAdapter()
		{
		}
		
		
		/**
		 *提示宿主更新数据 
		 * @return 
		 * 
		 */		
		public function notifyDataSetChanged() {
			
			adapterView.renderModel();
		}
		
		
		public function getCount():int {
			throw new Error("抽象方法");
		}
		
		
	
		public function getView(position:int):DisplayObject
		{
			
			throw new Error("抽象方法");
			
		
		}
	}
}