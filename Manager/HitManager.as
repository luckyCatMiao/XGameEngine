package XGameEngine.Manager
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.Manager.LayerManager;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import XGameEngine.Structure.List;

	/**
	 * ...
	 * @author o
	 */
	public class HitManager extends BaseManager
	{
		/**
		 * 碰撞状态
		 */
		static public var COLLISION_ENTER:String = "enter collision";
		static public var COLLISION_ING:String = "within collision";
		static public var COLLISION_EXIT:String = "exit collision";
		
		static private var _instance:HitManager;
		
		
		static public function getInstance():HitManager
		{
				if (_instance == null)
				{
					_instance = new HitManager();
				}
				return _instance;
		}
		
		
		
		private var isWork:Boolean = true;
		/**
		 * 工作频率
		 */
		private var workrate:int;
		private var i:int = 0;
		
		/**
		 * 过滤器
		 */
		private var filtters:List = new List();
		
		//两两之间碰撞的记录 碰撞开始 碰撞中 碰撞结束 然后调用对应方法
		// {name1:{name:"name2",state:"碰撞开始"}}
		//private var hitRecord:Object = new Object();
		
		public function HitManager()
		{
			stage.addEventListener(Event.ENTER_FRAME, loop);
		}
		

		/**
		 * 增加一个过滤器
		 * @param	layerName1
		 * @param	layerName2
		 */
		public function addFilter(layerName1:String, layerName2:String)
		{
			var f:Filter;
			if ((f=FindFilter(layerName1, layerName2)) != null)
			{
				throw new Error("the filter " + layerName1 + "-" + layerName2 + " has existed");
			}
			
			LayerManager.getInstance().checkLayer(layerName1);
			LayerManager.getInstance().checkLayer(layerName2);
			
			var fi:Filter = new Filter(layerName1, layerName2);
			
			filtters.add(fi);
			
		}
	
		public function FindFilter(layerName1:String, layerName2:String):Filter
		{
			 var fun:Function = function(element:*, index:int, arr:Array):Boolean {
			
				 var f:Filter = element as Filter;
				 if (f.layerName1 == layerName1 && f.layerName2 == layerName2)
				 {
					 return true;
				 }
				 else 
				 {
					 return false;
				 }
			};
			
			var result:List=filtters.filter(fun);

			if (filtters.size == 1)
			{
				return filtters.get(0) as Filter;
			}
			else if (filtters.size > 1)
			{
				throw new Error("the filter " + layerName1 + "-" + layerName2 + " has "+filtters.size+" same!");
			}
			else
			{
				return null;
			}
			
		}
		
		/**
		 * 删除过滤器
		 * @param	layer1
		 * @param	layer2
		 */
		public function deleteFilter(layerName1:String, layerName2:String)
		{
			LayerManager.getInstance().checkLayer(layerName1);
			LayerManager.getInstance().checkLayer(layerName2);
			
			var f:Filter;
			if ((f=FindFilter(layerName1, layerName2)) != null)
			{
				filtters.remove(f);
			}
			else
			{
				throw new Error("the filter " + layerName1 + "-" + layerName2 + " don't exist");
			}
		   
		}
		
		
		/**
		 * 从字符串中解析出过滤设定,可以使用工具生成包含过滤器设定的文件
		 * @param	s
		 */
		public function parseFiltterString(s:String)
		{
			
		}
		
	
		
		private function loop(e:Event)
		{
			i++;
			if (i % workrate == 0)
			{
				//CheckHit();
			}
		}
		
		
		//输出过滤设置
		public function debugFilters()
		{
			trace(filtters.toString());
			
		}
		
		
		
		/*
		private function CheckHit():void
		{
			//遍历管理器中的所有对象 找到一个需要检测碰撞的
		    var object:Object = Entry.getGameObjectManager().getAllObject();
			for (var i:String in object)
			{
				var go:GameObject = object[i];
				if (go.needCheckCollison)
				{
					CheckHits(go);
				}
			}
		  
			
		}
		
		
		
		//如果输入了碰撞域 则不以collider计算 以rect提供的四个点进行计算
		public function CheckHits(o:BaseGameObject,rect:Rectangle=null):Boolean
		{
			var hitAny:Boolean = false;
			
			var lName:String = o.getLayerName();
			//获取所有需要检测碰撞的层
			var needCheckLayers:Object = fitterSetting[lName];
			
			for (var i:String in needCheckLayers)
			{
				//获取所有需要检测碰撞的gameobject
				var gameobjects:Object = Entry.getLayerManager().getLayer(i).getObjects();
				for each(var g:GameObject in gameobjects)
				{
					if (g != o)
					{
					if (CheckObjectHit(o, g, rect))
					{hitAny=true};
	
					}
				}
				
			}
			
			return hitAny;
		}
		
		
		
		
		
		private function CheckObjectHit(o1:BaseGameObject, o2:BaseGameObject,rect:Rectangle=null):Boolean
		{
			
			var result:Boolean = false;
	
			var allPoints:Vector.<Point> = rect == null?o1.collider.getCheckPoint():GameTool.rectToPointArray(rect);
			
			//全都转化到全局坐标系
			for each(var p:Point in allPoints)
			{
				var newPoint = o1.localToGlobal(p);
				if (o2.hitTestPoint(newPoint.x,newPoint.y,true))
				{
					result = true;
					//更新碰撞关系
					if (hitRecord[o1.getXName()] == null)
					{	
						//调用对应方法
						hitRecord[o1.getXName()] = { name:o2.getXName, state:COLLISION_ENTER };
						o1.hitEnter(o2);
					}
					else if (hitRecord[o1.getXName()] != null)
					{
						//调用对应方法
						hitRecord[o1.getXName()]["state"] = COLLISION_ING;
						o1.hitIng(o2);

					}
					
					
				}
				
			}
			
			if (result == false)
			{
				
				if (hitRecord[o1.getXName()] != null)
				{
				if (hitRecord[o1.getXName()]["state"] == COLLISION_ENTER || hitRecord[o1.getXName()]["state"] == COLLISION_ING)
				{
				hitRecord[o1.getXName()]["state"] = COLLISION_EXIT;
				//调用对应方法
				o1.hitExit(o2);
				}
				}
				
			}
			
			return result;
		}*/
		

	}
	
}
 class Filter
{
		public var layerName1:String;
		public var layerName2:String;
		
		
		public function Filter(n1:String, n2:String)
		{
			layerName1 = n1;
			layerName2 = n2;
		}
		public function toString():String 
		{
			return "[Filter layerName1=" + layerName1 + " layerName2=" + layerName2 + "]";
		}
}