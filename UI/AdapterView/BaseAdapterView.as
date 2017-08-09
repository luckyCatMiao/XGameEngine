package XGameEngine.UI.AdapterView
{
	import XGameEngine.UI.AdapterView.Adapter.BaseAdapter;
	import XGameEngine.UI.Base.BaseUI;

	public class BaseAdapterView extends BaseUI
	{
		protected var adapter:BaseAdapter;
		public function BaseAdapterView()
		{
		}
		
		
		
		public function setAdapter(adapter:BaseAdapter):void
		{
			this.adapter=adapter;
			this.adapter.adapterView=this;
			
			
			renderModel();
		}
		
		/**
		 *渲染数据模型 
		 * 
		 */		
		public function renderModel():void
		{
			
			throw new Error("抽象方法");
		}		
		
		public function getAdapter():BaseAdapter
		{
			
			return adapter;
			
		}
	}
}