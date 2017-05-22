package XGameEngine.GameObject.Component
{
	import XGameEngine.Util.GameUtil;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import XGameEngine.GameObject.AutoDestroyObject;
	import XGameEngine.GameObject.BaseGameObject;
	
	/**
	 * ...
	 * @author o
	 */
	public class GameObjectComponent extends BaseComponent 
	{
		public function GameObjectComponent(o:BaseGameObject)
		{
			super(o);
		}
		
		
		
		/**
		 * 设置最低深度
		 * @param	o
		 */
		public function addChildToLowestDepth(o:DisplayObject)
		{
			//0就是最低索引 如果该索引处已经有对象 则所有对象会自动向上调整
			//确实比AS2好用的多
			host.addChildAt(o, 0);
		}
		
		
		/**
		 * 加入对象,设置最高深度
		 * @param	o
		 */
		public function addChildToHighestDepth(o:DisplayObject)
		{
			
			host.addChild(o);
		}
		
		
		
		/**
		 * 加入对象,设置为次高深度(如果只有该物体 则设置为最高深度)
		 * @param	o
		 */
		public function addChildToBeforeHighestDepth(o:DisplayObject)
		{
			if (host.numChildren == 0)
			{
				host.addChild(o);
			}
			else
			{
				host.addChildAt(o, host.numChildren - 1);
			}
			
		}
		
		
		
		/**
		 * 查找指定对象是否在子级中(不进行递归)
		 * @param	o
		 * @return
		 */
			public function hasChild(o:DisplayObject):Boolean 
			{
				for (var i:Number = 0; i < host.numChildren; i++ )
				{
					if (host.getChildAt(i) == o)
					{
						return true;
					}
				}
				
				return false;
			}
			
			public function removeAll():void 
			{
				while (host.numChildren > 0)
				{
					host.removeChildAt(0);
				}
			}
			
			public function removeSelf():void 
			{
				host.parent.removeChild(host);
			}
			
			public function addByGlobalPoint(o:BaseGameObject, point:Point):void 
			{
				var point2:Point = host.globalToLocal(point);
				o.x = point2.x;
				o.y = point2.y;
				addChildToHighestDepth(o);
			}
			
			
			/**
			 * 根据名字加载
			 * @param	string
			 */
			public function loadDisplayObjectByName(name:String,highest:Boolean=true):DisplayObject 
			{
				var o:DisplayObject = GameUtil.LoadDisPlayObjectByName(name);
				if (highest)
				{
					host.addChild(o);	
				}
				else
				{
					host.getGameObjectComponent().addChildToBeforeHighestDepth(o);
				}
				
				
				return o;
			}
			
			/**
			 * 加载到父级同位置处
			 * @param	o
			 */
			public function addToParentSamePosition(o:BaseGameObject):BaseGameObject 
			{
				host.parent.addChild(o);
				
				o.x = host.x;
				o.y = host.y;
				
				return o;
			}
	}
	
}