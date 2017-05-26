package XGameEngine.Manager
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.Component.Collider.Collider;
	import XGameEngine.Manager.Hit.Collision;
	import XGameEngine.Manager.LayerManager;
	import XGameEngine.Structure.List;
	
	import fl.transitions.Fade;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

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
		 * 过滤器(注意因为效率问题...添加过滤器实际上是两个层开始进行检测 刚开始是真的想默认全检测
		 *  然后过滤的 但是发现有点卡 不知道为什么unity就不会卡..)
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
			 var fun:Function = function(element:*):Boolean {
			
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

			if (result.size == 1)
			{
				return filtters.get(0) as Filter;
			}
			else if (result.size > 1)
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
			
			//不要改函数的顺序..因为我也不知道怎么样是对的 不过下面这个可以运行 改了就不一定了..
			//虽然框架是我写的 但一些细节 真的是不太清楚..
			
				i++;
			
				//解锁碰撞状态
				unlockHitStateChange();	
			
			
			
				//清除结束状态的碰撞记录
				deleteInvalidHitRecord();
				
				if (i % workrate == 0)
				{
					CheckHitOnce();
				}	
				
				//这个检测始终在每帧运行一次
				calculateWhileTest();

				
				if (i % workrate == 0)
				{
				applyHitState();
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
				
				if((record=findRecord(w.o1,w.o2))!=null){record.lock=false};
				i=0;
				//只要两个物体还在接触中就一直计算碰撞 因此回调方法中应该包含将两个物体分开的方法 、
				//否则就会达到计算上限100次
				//注意该计算只会回调接触中的回调函数
				while (w.valid==true&&TryCheckTwobjectHit(w.o1, w.o2)==true)
				{
					//解锁该记录的状态
					var record:HitRecord;
					if((record=findRecord(w.o1,w.o2))!=null){record.lock=false};
					
						//每次碰撞都回调一次碰撞函数 查找到对应记录 应用
						applyOneHitRecord(record);
						
						if (w.fun != null)
						{
							w.fun();
						}
					
					
					i++;
					if (i > 100)
					{
						w.valid = false;
						trace(w.o1 + "-" + w.o2 + " has checked over 100 times!Please check!")
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
			
			//过滤出所有有碰撞器的
			var fun:Function = function(element:*):Boolean {
			
				 var o:BaseGameObject = element as BaseGameObject;
				if (o.getCollideComponent().hasCollider())
				{
					return true;
				}
				else
				{
					return false;
				}
			};
			
			object = object.filter(fun);
			
			for (var out:int = 0;out < object.size;out++)
			{
				for (var ins:int = (out+1); ins < object.size; ins++)
				{
					TryCheckTwobjectHit(object.get(out) as BaseGameObject, object.get(ins) as BaseGameObject);
				}
			}
			
			
		}
		
		
		
		
		
		/**
		 * 试图检测两个物体的碰撞 如果两个物体不满足进行碰撞检测的要求 则直接返回false
		 * @param o1
		 * @param o2
		 * @param record 是否要在碰撞管理器中生成碰撞记录
		 * @return 
		 * 
		 */
		private function TryCheckTwobjectHit(o1:BaseGameObject,o2:BaseGameObject,record:Boolean=true):Boolean
		{
			if (o1 == o2)
			{
				return false;
			}
			
					//判断过滤设定
					if (FindFilter(o1.layerName, o2.layerName)!=null)
					{
						//如果没有过滤
						//如果双方的碰撞器都存在
						if (o1.getCollideComponent().hasCollider() && o2.getCollideComponent().hasCollider())
						{
							
							//因为碰撞算法的特殊性 所以有可能o1,o2 和o2,o1的检测结果不同
							//所以这里一定要让能返回点的放在第一个!如果两者中有一个对象不能返回点(即只作为形状使用),则一定要放在第二个位置
							if (o1.getCollideComponent().collider.getCheckPoint().size > 0 && o2.getCollideComponent().collider.getCheckPoint().size > 0)
							{
								//两者都有点 位置随意
								return CheckTwoObjectHit(o1, o2, record);
								
							}
							else
							{
								//两者都没点 则直接返回false 即两个多边形碰撞器是检测不出碰撞的(因为都不返回点)
								if (o1.getCollideComponent().collider.getCheckPoint().size == 0 && o2.getCollideComponent().collider.getCheckPoint().size == 0)
								{
									return false;
								}
								else
								{
									//一方有点 则有点的设置为o1
									if (o2.getCollideComponent().collider.getCheckPoint().size > 0)
									{
										return CheckTwoObjectHit(o2, o1,record);
									}
									else
									{
										return CheckTwoObjectHit(o1, o2, record);
									}
									
								}
								
							}
						}
						
					}
					
					return false;
					
		}
		
		/**
		 * 根据记录的碰撞状态 调用方法 
		 * @param	o1
		 * @param	o2
		 */
		private function applyHitState()
		{
			for each(var hit:HitRecord in hitList.Raw)
			{
				
				applyOneHitRecord(hit);
				
			}
					
		}
		
		private function applyOneHitRecord(hit:HitRecord):void
		{
			
			//分别调用双方的碰撞方法
			//如果索引的两个对象有有一个已经为null了 则直接返回
			//这里不能使用null 因为只是o1自己destroy自己 其他地方的引用还在
			//所以这边把hit的valid也设置为false
			//下一帧再次计算的时候就会把该记录删除 同时在hitmanager里对o1o2的引用也消失了
			if (hit.o1.valid==false||hit.o2.valid==false)
			{
				hit.valid = false;
				return;
			}
			hit.o1.getCollideComponent().applyCollision(CreateCollision(hit,true));
			hit.o2.getCollideComponent().applyCollision(CreateCollision(hit,false));
			
		}		
		
		/**
		 * 创建一个碰撞数据包
		 * @param	o1
		 * @param	o2
		 * @param	hasCollider
		 */
		
		private function CreateCollision(hit:HitRecord,isSelf:Boolean):Collision
		{ 
			var c:Collision = new Collision();
			
			if(isSelf)
			{
				c.hitObject = hit.o2;
				c.self = hit.o1;
				//因为碰撞算法的特殊性碰撞点是属于先测试的那方的局部坐标点
				c.hitPointsSelf=true;
			}
			else
			{
				c.hitObject = hit.o1;
				c.self = hit.o2;
				c.hitPointsSelf=false;
			}
			c.state = hit.state;
			c.hitPoint = hit.hitPoint;
			c.allhitPoint = hit.allPoints;
			return c;
		}
		/**
		 * 更新两个物体的碰撞关系
		 * @param	o1
		 * @param	o2
		 */
		private function updateHitState(o1:BaseGameObject, o2:BaseGameObject,hasCollider:Boolean,hitPoint:Point=null,allPoint:List=null)
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
					hit.allPoints = allPoint;
					hit.state = COLLISION_ENTER;
					hit.hitPoint = hitPoint;
					hit.lock = true;
					hitList.add(hit);
				}
				//如果该碰撞关系已经存在 设置为碰撞中
				else
				{
					if (h.state == COLLISION_ENTER||h.state==COLLISION_ING)
					{
					if (h.lock == false)
					{
						h.state = COLLISION_ING;
						h.hitPoint = hitPoint;
						h.allPoints = allPoint;
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
		private function deleteInvalidHitRecord()
		{
			//删除已经为碰撞结束状态的记录或者设置为无效的记录(比如碰撞开始后就销毁自己 就会卡在这个状态)
			var fun:Function = function(element:*):Boolean {
			
				 var hit:HitRecord = element as HitRecord;
				 if (hit.state == COLLISION_EXIT && hit.lock == false||hit.valid==false)
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
			var fun:Function = function(element:*):Boolean {
			
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
		 * @param	record 是否需要记录碰撞数据
		 * @return
		 */
		private function CheckTwoObjectHit(o1:BaseGameObject, o2:BaseGameObject,record:Boolean):Boolean
		{
			//这里到时候优化下 如果碰撞器数量多卡的话
			//加入多种碰撞算法
			
			var result:Boolean = false;
	
			
			//获取o1的所有检测点依次检测o2的包围形状
			var points:List = o1.getCollideComponent().collider.getCheckPoint();
			
			var hitPoints:List = new List();
			//全都转化到全局坐标系
			
			for each(var p:Point in points.Raw)
			{
				//发现一个问题 就是如果xscale反向 就是很常见的人物左右走
				//这个时候点是根据玩家的朝向来的 比如右是指玩家面朝的右 而不是在全局坐标系中看上去的右
				//然后发现以前游戏的解决办法是只考虑了位置的坐标变换 没有考虑旋转 缩放
				//现在先采用这种方法 以后再考虑更好的解决办法
				
				//想了想3D游戏之后想通了 前后左右都是根据玩家自身坐标系来算的,虽然2D也这么做有点奇怪,不过就是这个道理
				//所以玩家的右边应该是玩家的正方向 但是玩家反向走之后 这个右边就应该是屏幕看上去的左边
				//虽然这样在2D看上去真的刚开始很难接受。。要在2D里面思考玩家的朝向
				//想了想发现还是这样最好..顶多是在回调的时候也把缩放放进去呗...
				
				//newPoint = new Point(p.x + o1.x, p.y + o1.y );
				
				//trace(newPoint);
				var newPoint = o1.localToGlobal(p);
				//trace(newPoint+"  "+o1+"  "+o2);
				if (o2.getCollideComponent().collider.hitTestPoint(newPoint.x,newPoint.y,true))
				{
					result = true;
					hitPoints.add(p);
					
					
					
				}
				
			}
			
			if (result == true)
			{
				if(record)
				{
					updateHitState(o1, o2, true,p,hitPoints);
				}
				
				return true;
			}
			
			
			if (result == false)
			{
				if(record)
				{
				updateHitState(o1, o2, false,null,null);
				}
				
			}
			
			return result;
	
		}
		

	}
	
}
import flash.geom.Point;
import XGameEngine.GameObject.BaseGameObject;
import XGameEngine.Structure.List;

/**
 * 保存暂时的碰撞记录
 */
class HitRecord
{
	public var o1:BaseGameObject;
	public var o2:BaseGameObject;
	public var state:String;
	public var hitPoint:Point;
	public var allPoints:List;
	public var valid:Boolean=true;
	
	
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