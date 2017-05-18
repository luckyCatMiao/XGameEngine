﻿package XGameEngine.Manager
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.Component.Collider.Collider;
	import XGameEngine.Manager.Hit.Collision;
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
		
		
		
		public var isWork:Boolean = true;
		/**
		 * 工作频率
		 */
		public var workrate:int=1;
		private var i:int = 0;
		
		/**
		 * 过滤器
		 */
		private var filtters:List = new List();
		
		/**
		 * 保存碰撞数据
		 */
		private var hitList:List = new List();
		
		/**
		 * while级别的测试
		 */
		private var whileTest:List = new List();
		
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
	
		
		/**
		 * 查找指定的过滤器是否存在 注意这里两个层名对调也是一样的
		 * @param	layerName1
		 * @param	layerName2
		 * @return
		 */
		public function FindFilter(layerName1:String, layerName2:String):Filter
		{
			 var fun:Function = function(element:*, index:int, arr:Array):Boolean {
			
				 var f:Filter = element as Filter;
				 if (f.layerName1 == layerName1 && f.layerName2 == layerName2)
				 {
					 return true;
				 }
				 else if (f.layerName1 == layerName2 && f.layerName2 == layerName1)
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
				//解锁碰撞状态
				unlockHitStateChange();
				
				//清除结束状态的碰撞记录
				deleteExitHitRecord();
			
				CheckHitOnce();
				
				applyHitState();
				
				calculateWhileTest();
			}
			
			
			
			
			
			
		}
		
		
		//输出过滤设置
		public function debugFilters()
		{
			trace(filtters.toString());
			
		}
		
		
		/**
		 * 检测while级的测试,可以使用自定义的回调函数
		 */
		private function calculateWhileTest():void
		{
			var i:int = 0;
			//因为这里有卡死的危险..所以规定上限每帧每两个物体只能计算100次(超过一百次后该碰撞检测被废弃,因为可能代码有逻辑问题)
			for each(var w:WhileTest in whileTest.Raw)
			{
				//只要两个物体还在接触中就一直计算碰撞 因此回调方法中应该包含将两个物体分开的方法 、
				//否则就会达到计算上限100次
				//注意该计算只会回调接触中的回调函数
				while (TryCheckTwobjectHit(w.o1, w.o2)==true&&w.valid==true)
				{
					//每次碰撞都回调一次碰撞函数
					applyHitState(true);
					
					if (w.fun != null)
					{
						w.fun();
					}
					i++;
					if (i > 100)
					{
						w.valid = false;
						trace(w.o1 + "-" + w.o1 + " has checked over 100 times!Please check!")
						continue;
					}
				}
			}
			
		}
		
		
		/**
		 * 检测碰撞
		 */
		private function CheckHitOnce():void
		{
			//遍历对象管理器中 依次进行碰撞检测
			
			var object:List = GameObjectManager.getInstance().objects;
			for (var out:int = 0;out < object.size;out++)
			{
				for (var ins:int = (out+1); ins < object.size; ins++)
				{
					TryCheckTwobjectHit(object.get(out) as BaseGameObject, object.get(ins) as BaseGameObject);
				}
			}
			
			
		}
		
		
		
		/**
		 * 如果输入了碰撞域 则不以collider计算 以rect提供的四个点进行计算
		 * @param	o
		 * @param	rect
		 */
		private function TryCheckTwobjectHit(o1:BaseGameObject,o2:BaseGameObject,rect:Rectangle=null):Boolean
		{
			
					//判断过滤设定
					if (!FindFilter(o1.layerName, o2.layerName))
					{
						//如果没有过滤
						//如果双方的碰撞器都存在
						if (o1.getCollideComponent().hasCollider() && o2.getCollideComponent().hasCollider())
						{
							return CheckTwoObjectHit(o1, o2,rect);
						}
						
					}
					
					return false;
					
		}
		
		/**
		 * 根据记录的碰撞状态 调用方法 (如果是whileTest,则会强制改变为碰撞中状态)
		 * @param	o1
		 * @param	o2
		 */
		private function applyHitState(whileTest:Boolean=false)
		{
			for each(var hit:HitRecord in hitList.Raw)
			{
				if (whileTest)
				{
					hit.state = COLLISION_ING;
				}
				//分别调用双方的碰撞方法
				hit.o1.getCollideComponent().applyCollision(CreateCollision(hit));
				hit.o2.getCollideComponent().applyCollision(CreateCollision(hit));
				
			}
					
		}
		
		
		/**
		 * 创建一个碰撞数据包
		 * @param	o1
		 * @param	o2
		 * @param	hasCollider
		 */
		
		private function CreateCollision(hit:HitRecord):Collision
		{ 
			var c:Collision = new Collision();
			c.hitObject = hit.o2;
			c.state = hit.state;
			c.hitPoint = hit.hitPoint;
			return c;
		}
		/**
		 * 更新两个物体的碰撞关系
		 * @param	o1
		 * @param	o2
		 */
		private function updateHitState(o1:BaseGameObject, o2:BaseGameObject,hasCollider:Boolean,hitPoint:Point=null)
		{
			var h:HitRecord;
			//如果产生了碰撞
			if (hasCollider == true)
			{	
				//如果没有该碰撞关系 设置为进入碰撞
				if ((h=findRecord(o1, o2)) == null)
				{
					//碰撞点只保存最开始的碰撞点!!之后都不改变 
					var hit:HitRecord = new HitRecord();
					hit.o1 = o1;
					hit.o2 = o2;
					hit.state = COLLISION_ENTER;
					hit.hitPoint = hitPoint;
					hit.lock = true;
					hitList.add(hit);
				}
				//如果该碰撞关系已经存在 设置为碰撞中
				else
				{
					if (h.state == COLLISION_ENTER)
					{
					if (h.lock == false)
					{
						h.state = COLLISION_ING;
						h.lock = true;
					}
					}
					
				}
			}
			else
			{
				//如果没有产生碰撞
				//如果该碰撞存在且是碰撞中状态或者进入碰撞(碰撞时间极短的情况下可能发生)设置为退出碰撞状态
				
				if ((h=findRecord(o1, o2)) != null)
				{
					if (h.state == COLLISION_ENTER||h.state==COLLISION_ING)
					{
					if (h.lock == false)
					{
						h.state = COLLISION_EXIT;
						h.lock = true;
					}
					}
				}
				
				
				
			}
				
			
			
		}
		private function deleteExitHitRecord()
		{
			//删除已经为碰撞结束状态的记录
			var fun:Function = function(element:*, index:int, arr:Array):Boolean {
			
				 var hit:HitRecord = element as HitRecord;
				 if (hit.state == COLLISION_EXIT && hit.lock == false)
				 {
					 return false;
				 }
				 else
				{
					return true;
				}
			};
				
			
			this.hitList = hitList.filter(fun);
			
		}
		
			
		private function findRecord(o1:BaseGameObject, o2:BaseGameObject):HitRecord
		{
			var fun:Function = function(element:*, index:int, arr:Array):Boolean {
			
				 var hit:HitRecord = element as HitRecord;
				 if (hit.o1==o1&&hit.o2==o2)
				 {
					 return true;
				 }
				 else if (hit.o1==o2&&hit.o2==o1)
				 {
					 return true;
				 }
				 else 
				 {
					 return false;
				 }
			};
			
			var result:List=hitList.filter(fun);

			if (result.size == 1)
			{
				return result.get(0) as HitRecord;
			}
			else if (result.size > 1)
			{
				throw new Error("the record " + o1 + "-" + o2 + " has "+result.size+" same!");
			}
			else
			{
				return null;
			}
			
		}
		
		
		private function unlockHitStateChange()
		{
			for each(var h:HitRecord in hitList.Raw)
			{
				h.lock = false;
			}
		}
		
		
		
		/**
		 * 添加一个while级别的测试 (只能检测到碰撞中 不能检测开始和结束)
		 * @param	o1
		 * @param	o2
		 * @param	recall
		 */
		public function addWhileTest(o1:BaseGameObject, o2:BaseGameObject,recall:Function=null)
		{

			if (o1 == o2)
			{
				throw new Error("the o1 can't == o2");
			}
			checkNull(o1,"o1");
			checkNull(o2,"o2");
			
			var t:WhileTest = new WhileTest();
			t.o1 = o1;
			t.o2 = o2;
			t.fun = recall;
			
			
			
			
			whileTest.add(t);
			
		}
		
		/**
		 * 检测两个物体的碰撞
		 * @param	o1
		 * @param	o2
		 * @param	rect
		 * @param	directInvoke 直接直接触发碰撞回调,正常情况下碰撞回调只在一个计算周期回调一次,如果需要更精确的碰撞可以设置为true
		 * 这样只要每次调用该方法都会回调碰撞函数
		 * @return
		 */
		private function CheckTwoObjectHit(o1:BaseGameObject, o2:BaseGameObject,rect:Rectangle=null):Boolean
		{
			//这里到时候优化下 如果碰撞器数量多卡的话
			//加入多种碰撞算法
			
			var result:Boolean = false;
	
			
			//获取o1的所有检测点依次检测o2的包围形状
			var points:List = o1.getCollideComponent().collider.getCheckPoint();
			
			//全都转化到全局坐标系
			for each(var p:Point in points.Raw)
			{
				var newPoint = o1.localToGlobal(p);
				if (o2.getCollideComponent().collider.hitTestPoint(newPoint.x,newPoint.y,true))
				{
					result = true;
					updateHitState(o1, o2, true,p);
					return true;
					
				}
				
			}
			
			if (result == false)
			{
				
				updateHitState(o1, o2, false);
				
			}
			
			return result;
	
		}
		

	}
	
}
import flash.geom.Point;
import XGameEngine.GameObject.BaseGameObject;

/**
 * 保存暂时的碰撞记录
 */
class HitRecord
{
	public var o1:BaseGameObject;
	public var o2:BaseGameObject;
	public var state:String;
	public var hitPoint:Point;
	
	//是否锁定 每次修改后进行一次锁定 这样一帧中只能更新一次状态
	public var lock:Boolean = false;
	
	public function toString():String 
	{
		return "[HitRecord o1=" + o1 + " o2=" + o2 + " state=" + state + "]";
	}
	
}
class WhileTest
{
	public var o1:BaseGameObject;
	public var o2:BaseGameObject;
	public var fun:Function;
	public var valid:Boolean = true;
	
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