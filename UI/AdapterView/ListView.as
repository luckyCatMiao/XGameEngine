package XGameEngine.UI.AdapterView
{
	import XGameEngine.Structure.Map;
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.UI.Config.UIConfig;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Orientation3D;
	
	

	/**
	 * 单排显示的列表 可以横着或者竖着
	 * @author Administrator
	 * 
	 */	
	public class ListView extends BaseAdapterView
	{
		
		/**
		 *view之间的间隔 
		 */		
		public var space:Number=0;
		
		/**
		 *横竖 默认是竖着 
		 */		
		public var orientationType:String=UIConfig.ORIENTATION_VERTICAL;
		
		/**
		 *监听器 
		 */		
		private var listener:Function;
		
		/**
		 *保存view和索引的绑定关系
		 * 
		 */		
		private var map:Map;
		
		
		public function ListView()
		{
	
		}
		
	
		
		override public function renderModel():void
		{
			//先清空所有子级
			getGameObjectComponent().removeAllChilds();
			//重置绑定关系
			map=new Map();
			
			//根据adapter加载
			for(var i:int=0;i<adapter.getCount();i++)
			{
				var o:DisplayObject=adapter.getView(i);
				var rect:Rect=Rect.RectangleToRect(this.getRect(this));
				if(orientationType==UIConfig.ORIENTATION_VERTICAL)
				{
					o.y=rect.getBottomY()+space;
				}
				else if(orientationType==UIConfig.ORIENTATION_HORIZONTAL)
				{
					o.x=rect.getRightX()+space;
				}

				addChild(o);
				//绑定view和索引
				map.put(o.name,i);
				
				o.addEventListener(MouseEvent.CLICK,clickItem,false,0,true);
			}
			
			
		}
		
		protected function clickItem(event:Event):void
		{
			if(listener!=null)
			{
				listener(event.currentTarget,map.get(event.currentTarget.name) as int)
			}
			
		}		
		
		
		public function setOnItemClickListener(fun:Function)
		{
			this.listener=fun;
			
		}
		
		
		
	}
}