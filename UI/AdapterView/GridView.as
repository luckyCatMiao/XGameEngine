package XGameEngine.UI.AdapterView
{
	import XGameEngine.Structure.Map;
	import XGameEngine.Structure.Math.Rect;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 *从左往右显示 自动换行的列表 
	 * @author Administrator
	 * 
	 */	
	public class GridView extends BaseAdapterView
	{
		
		/**
		 *横间隔 
		 */		
		public var Hspace:Number=0;
		/**
		 * 竖间隔 
		 */		
		public var Vspace:Number=0;
		
		/**
		 *监听器 
		 */		
		private var listener:Function;
		
		/**
		 *保存view和索引的绑定关系
		 * 
		 */		
		private var map:Map;
		/**
		 *每一行可以显示几个 
		 */		
		public var Hcount:int=1;
		
		
		/**
		 *每个控件的宽度 如果没有主动设置的话
		 * 默认设置为第一个加载的控件的宽度
		 */		
		public var viewWidth:Number=0;
		
		/**
		 *每个控件的高度 如果没有主动设置的话
		 * 默认设置为第一个加载的控件的高度
		 */		
		public var viewHeight:Number=0;
		
		
		public function GridView()
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
				
				
				if(viewWidth==0)
				{
						viewWidth=rect.width;
						viewHeight=rect.height;
				}
				
				//转换成行数和列数
				var row:int=i/Hcount;
				var column:int=i%Hcount;
				
				
				
				o.x=viewWidth*column+Hspace*column;
				o.y=viewHeight*row+Vspace*row;
				
				
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