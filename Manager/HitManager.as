package XGameEngine.Manager
{
import XGameEngine.GameObject.BaseGameObject;
import XGameEngine.GameObject.GameObjectComponent.Collider.Collider.CircleCollider;
import XGameEngine.Manager.Hit.Collision;
import XGameEngine.Structure.List;
import XGameEngine.Structure.Map;
import XGameEngine.Structure.Math.Function.LinearFunction;
import XGameEngine.Structure.Math.Line;
import XGameEngine.Structure.Math.Vector2;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.geom.Point;

/**
	 * 碰撞管理器
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
		/**
		 *是否开启空间分割  可能会带来不精确 但是在检测大量物体碰撞时能大幅度提高性能
		 * (少量物体的时候没什么效果 不建议开启)
		 */		
		public var useSpaceDivision:Boolean=false;
		public var useSpaceDivision9Part:Boolean=true;
		
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
				
				deleteInvalidWhileTest();
				
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
		
		private function deleteInvalidWhileTest():void
		{
			//删除已经为碰撞结束状态的记录或者设置为无效的记录(比如碰撞开始后就销毁自己 就会卡在这个状态)
			var fun:Function = function(element:*):Boolean {
				
				var t:WhileTest = element as WhileTest;
				if (t.valid==false)
				{
					return false;
				}
				else
				{
					return true;
				}
			};
			
			
			this.whileTest = whileTest.filter(fun);
			
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
			
			var objects:List =filterAllhasCollider();
		
			//根据过滤设置 进行碰撞测试
			//先一次扫描将物体根据层分类
			var map:Map=new Map();
			for (var i:int = 0;i < objects.size;i++)
			{
				var o:BaseGameObject=objects.get(i) as BaseGameObject;
				if(map.get(o.layerName)==null)
				{
					var l:List=new List();
					map.put(o.layerName,l);
				}
				var list:List=map.get(o.layerName) as List;
				list.add(o);
			}
			
			//接下来再根据过滤设置进行两两list之间的测试 这样将大大避免不必要的测试 
			
			for each(var f:Filter in filtters.Raw)
			{
				//因为我想让空间分割和层级分割并行运行 如果简单的对所有物体使用空间分割
				//所以只能是递进调用  但是空间分割后再使用层级分割明显不好 因为空间数太多 这样分效率不高
				//所以采用层级分割后再进行空间分割  而且空间分割作用最大的时候是在多对多物体碰撞检测的时候
				//一对多并没有多少效率提升甚至可能下降  所以空间分割的触发条件为两个层都有超过10个以上物体的时候
				//简而言之就是可能对每个layer1 layaer调用分割 但是因为多对多的碰撞基本上只存在某两个层中
				//(或者10个以上物体的层内碰撞)
				//还有一个原因是多边形碰撞体基本上很大 没办法分 但是多边形碰撞基本上不会出现10个 所以这里也区分开来了
				//所以空间分割基本上只会出现一两次吧 没办法 为了使层级分割也有作用 只能折中一下了
				//(如果在物体大小差异过大的情况下 空间分割精确度可能会很差)
				
				
				var layer1:String=f.layerName1;
				var layer2:String=f.layerName2;
				//查找list进行测试
				
				var list1:List=map.get(layer1) as List;
				var list2:List=map.get(layer2) as List;
				
				if(list1!=null&&list2!=null)
				{
				if(list1.size>10&&list2.size>10&&useSpaceDivision==true)
				{
					//先循环一遍 算出合适的分割盒长宽
					var maxWidth:Number=0;
					var maxHeight:Number=0;
					for each(var o1:BaseGameObject in list1.Raw)
					{
						if(o1.getCollideComponent().collider.width>maxWidth)
						{
							maxWidth=o1.getCollideComponent().collider.width;
						}
						if(o1.getCollideComponent().collider.height>maxHeight)
						{
							maxHeight=o1.getCollideComponent().collider.height;
						}
					}
					
					for each(var o2:BaseGameObject in list2.Raw)
					{
						if(o2.getCollideComponent().collider.width>maxWidth)
						{
							maxWidth=o2.getCollideComponent().collider.width;
						}
						if(o2.getCollideComponent().collider.height>maxHeight)
						{
							maxHeight=o2.getCollideComponent().collider.height;
						}
					}
					
					//分割盒的高度为最大的碰撞器的长宽*2
					maxWidth*=2;
					maxHeight*=2;
					
					var divdieSpace1:DivdieSpace=new DivdieSpace(maxWidth,maxHeight,list1);
					var divdieSpace2:DivdieSpace=new DivdieSpace(maxWidth,maxHeight,list2);
					
					for each(var qqq:BaseGameObject in list1.Raw)
					{
						//获取该对象需要检测的其他对象
						var needCheckList:List=divdieSpace2.getNeedCheckSpace(qqq);
						//只检测需要检测的对象
						for (var bbb:int =0; bbb < needCheckList.size; bbb++)
						{
							TryCheckTwobjectHit(qqq, needCheckList.get(bbb) as BaseGameObject);
						}
					}
					
					
				}
				else
				{
					//这里有可能list为空 因为虽然注册了过滤器 但是该层里是空的 所以有list为空也不需要报错
					
						//进行依次检测
						for (var out:int = 0;out < list1.size;out++)
						{
							for (var ins:int =0; ins < list2.size; ins++)
							{
								TryCheckTwobjectHit(list1.get(out) as BaseGameObject, list2.get(ins) as BaseGameObject);
							}
						}
						
				    }
				}
				
				
			}
			
			
			
			
			
			//这种测试有多余的测试 物体多了之后就很卡 
//			for (var out:int = 0;out < objects.size;out++)
//			{
//				for (var ins:int = (out+1); ins < objects.size; ins++)
//				{
//					TryCheckTwobjectHit(objects.get(out) as BaseGameObject, objects.get(ins) as BaseGameObject);
//				}
//			}
			
			
		}
		
		/**
		 *过滤出对象管理中所有有collider的对象 
		 * @return 
		 * 
		 */		
		private function filterAllhasCollider():List
		{
			var objects:List= GameObjectManager.getInstance().objects;
			
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
			
			objects = objects.filter(fun);
			return objects;
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
			
					//判断过滤设定(不用判断了 前面已经判断过)
//					if (FindFilter(o1.layerName, o2.layerName)!=null)
//					{
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
						
					//}
					
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
		 * @param	isSelf 
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
		 * 提供一个DisplayObject进行快速碰撞测试  只能返回返回碰撞对象组
		 * 使用的是包围区相交测试而不是点测试 因此不能用来测试有一方为多边形碰撞器的情况
		 * 常用于攻击区的碰撞检测
		 * @param rect
		 * @param layerName 只检测和指定层的碰撞
		 * @return 
		 * 
		 */		
		public function oldTypeTest(object:DisplayObject,layerName:String=null):List
		{
			//如果输入了layer名 则测试该名字是否存在
			if(layerName!=null)
			{
				var layer=LayerManager.getInstance().getLayer(layerName);
				getCommonlyComponent().checkNull(layer);
			}
			
			var hits:List=new List();
			
			var list:List=filterAllhasCollider();
			
			for each(var o:BaseGameObject in list.Raw)
			{
				
				if(layerName!=null)
				{
					if(o.layerName==layerName)
					{
						
						if(o.getCollideComponent().collider.hitTestObject(object)&&o!=object)
						{
							hits.add(o);
						}
					}
				}
				else
				{
					if(o.getCollideComponent().collider.hitTestObject(object)&&o!=object)
					{
						hits.add(o);
					}
				}
				
				
			}
			
			
			return hits;
		}
	
		
		
		
		/**
		 * 检测两个物体的碰撞  注意这里o1提供点 o2提供形状
		 * 为了节省起见没有双向互检测!所以o1,o2位置放反可能会有问题
		 * rect碰撞器和mesh碰撞器的话  rect放o1,mesh放o2
		 * 两个mesh检测不了
		 * 两个rect的话随意
		 * 如果双方都有点的 还有两种情况 第一种是 双方都是rect 正常取点判断
		 * 第二种如果双方有一个是circle 则直接使用hitTestObject (适用于于子弹等大量出现的物体)
		 * 因为实际应用中发现全用rect来判断实在太卡了 所以用circle来优化子弹 金币类的碰撞
		 * 此类碰撞只能返回碰撞对象 而不能返回碰撞点
		 * @param	o1
		 * @param	o2
		 * @param	record 是否需要记录碰撞数据
		 * @return
		 */
		private function CheckTwoObjectHit(o1:BaseGameObject, o2:BaseGameObject,record:Boolean):Boolean
		{
			//这里到时候优化下 如果碰撞器数量多卡的话
			//加入多种碰撞算法
			
			
			//两者是否碰撞
			var result:Boolean = false;
	
			//所有的碰撞点
			var hitPoints:List = new List();
			
			//第一个碰撞点
			var firstHitPoint:Point;
			
			
			//获取o1的所有检测点依次检测o2的包围形状
			var points:List = o1.getCollideComponent().collider.getCheckPoint();
			
			
			
			if(o1.getCollideComponent().collider is CircleCollider||o2.getCollideComponent().collider is CircleCollider)
			{
				if(o1.getCollideComponent().collider.hitTestObject(o2.getCollideComponent().collider))
				{
					//只设置碰撞结果 不返回碰撞点
					result=true;
				}
			}
			else
			{
				
				for(var i:int=0;i<points.size;i++)
				{
					
					var p:Point=points.get(i) as Point;
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
					//全都转化到全局坐标系
					var newPoint = o1.localToGlobal(p);
					//trace(newPoint+"  "+o1+"  "+o2);
					if (o2.getCollideComponent().collider.hitTestPoint(newPoint.x,newPoint.y,true))
					{
						result = true;
						hitPoints.add(p);
						//设置第一个碰撞点
						if(firstHitPoint==null)
						{
							firstHitPoint=p;
						}
						
						
					}
					
				}
			}
			
			
			
			if (result == true)
			{
				if(record)
				{
					updateHitState(o1, o2, true,firstHitPoint,hitPoints);
				}
				
				return true;
			}
			
			
			if (result == false)
			{
				if(record)
				{
					//如果该碰撞关系已经存在 则将更新为exit状态
					updateHitState(o1, o2, false,null,null);
				}
				
			}
			
			return result;
	
		}
		

		/**
		 * 进行射线碰撞检测 返回的碰撞对象按距离升序
		 * @param line 射线向量
		 * @param list 忽略的对象
		 * @param first 是否只返回第一个对象
		 * @return 
		 * 
		 */		
		public function rayCast(line:Line, list:List=null,first:Boolean=false):List
		{
			var list:List=new List();
			var objects:List =filterAllhasCollider();
			if(list!=null)
			{
				objects.removeAll(list.Raw);
			}
			
			//因为要求直线和任意形状函数的交点很困难。。所以我们这里退而求次
			//采取在线段上从起点到终点连续取点再调用as3原生的碰撞检测的方法
			//大部分时候都是精确的 除非有特别小的碰撞区(一般不会有)
			var l:LinearFunction=LinearFunction.createByLine(line);
			//定义域每隔十个像素检测一个点
			var start:Number=l.DYRange.v1;
			var end:Number=l.DYRange.v2;
			
			var point:Vector2;
			
			for(var i:Number=start;i<end;i+=10)
			{
				//当前的检测点
				point=new Vector2(i,l.getY(i));
				//依次与所有对象进行碰撞检测
				for each(var o:BaseGameObject in objects.Raw)
				{
					
					if(o.getCollideComponent().collider.hitTestPoint(point.x,point.y,true))
					{
						if(!list.contains(o))
						{
							list.add(o);
							//如果只需要返回第一个对象 则直接返回
							if(first==true)
							{
								return list;
							}
						}
					}
					
					
					
				}
				
			}
			
			
			
			return list;
		}
		
		/**
		 *检测与list里的对象有没有碰撞(对象最低可以是displayobject而不用是basegameobject) 
		 * @param line 线段
		 * @param list 需要检测的组
		 * @param first 是否检测到第一个就返回
		 * @return 
		 * 
		 */		
		public function rayCast2(line:Line, list:List,first:Boolean=false):List
		{
			var result:List=new List();
			var objects:List =list;
			
			//因为要求直线和任意形状函数的交点很困难。。所以我们这里退而求次
			//采取在线段上从起点到终点连续取点再调用as3原生的碰撞检测的方法
			//大部分时候都是精确的 除非有特别小的碰撞区(一般不会有)
			var l:LinearFunction=LinearFunction.createByLine(line);
			//定义域每隔十个像素检测一个点
			var start:Number=l.DYRange.v1;
			var end:Number=l.DYRange.v2;
			
			var point:Vector2;
			
			for(var i:Number=start;i<end;i+=10)
			{
				//当前的检测点
				point=new Vector2(i,l.getY(i));
				//依次与所有对象进行碰撞检测
				for each(var o:DisplayObject in objects.Raw)
				{
					
					if(o.hitTestPoint(point.x,point.y,true))
					{
						if(!result.contains(o))
						{	
							result.add(o);
							//如果只需要返回第一个对象 则直接返回
							if(first==true)
							{
								return list;
							}
						}
					}
					
					
					
				}
				
			}
			
			
			
			return result;
		}
	}


	
}

import XGameEngine.GameObject.BaseGameObject;
import XGameEngine.Manager.HitManager;
import XGameEngine.Structure.List;
import XGameEngine.Structure.Map;
import XGameEngine.Structure.Math.Number2;
import XGameEngine.Structure.Math.Vector2;

import flash.geom.Point;

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
	
	
	//是否锁定 每次修改后进行一次锁定 这样一帧中只能更新一次碰撞状态
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
class DivdieSpace
{
	private var maxWidth:Number;
	private var maxHeight:Number;
	private var map:Map;
	private var objectToSpace:Map;
	public function DivdieSpace(maxWidth:Number,maxHeight:Number,list:List)
	{
		this.maxWidth=maxWidth;
		this.maxHeight=maxHeight;
		this.map=new Map();
		this.objectToSpace=new Map();
		//进行分割 
		for each(var o:BaseGameObject in list.Raw)
		{
			var key:Number2=calculateSpaceKey(o);
			objectToSpace.put(o,key);
			
			//因为后面需要取到9个空间 所以需要一个映射
			var key2:String=getNumberString(key.v1,key.v2);
			var list:List=map.get(key2) as List;
			if(list==null)
			{
				list=new List();
				map.put(key2,list);
			}
			list.add(o);
			
		}
		
	}
	
	private function getNumberString(v1:Number, v2:Number):String
	{
		
		return v1+","+v2;
	}	


	
	
	public function getNeedCheckSpace(qqq:BaseGameObject):List
	{
		var list:List=new List();
		//获得该对象所在的空间
		var n:Number2=objectToSpace.get(qqq) as Number2;
		
		//添加该对象周围(包括自己)的9个空间到List中
		//(为什么是9个而不是1个是因为精确性 有时候一个对象可能正在穿越到其他space 但是还是属于当前space)
		//(如果其他space的物体碰撞了 却不会被检测到 而使用9个虽然效率稍微低了一些 但是保证了精确度)
		
		if(HitManager.getInstance().useSpaceDivision9Part==true)
		{
			list.addAllList(map.get(getNumberString(n.v1-1,n.v2-1))as List);
			list.addAllList(map.get(getNumberString(n.v1-0,n.v2-1))as List);
			list.addAllList(map.get(getNumberString(n.v1+1,n.v2-1))as List);
			list.addAllList(map.get(getNumberString(n.v1-1,n.v2-0))as List);
			list.addAllList(map.get(getNumberString(n.v1-0,n.v2-0))as List);
			list.addAllList(map.get(getNumberString(n.v1+1,n.v2-0))as List);
			list.addAllList(map.get(getNumberString(n.v1-1,n.v2+1))as List);
			list.addAllList(map.get(getNumberString(n.v1-0,n.v2+1))as List);
			list.addAllList(map.get(getNumberString(n.v1+1,n.v2+1))as List);
		}
		//舍弃精确性 只添加一个区域
		else
		{
			list.addAllList(map.get(getNumberString(n.v1-0,n.v2-0))as List);
		}
	
		
		return list;
	}
	
	private function calculateSpaceKey(o:BaseGameObject):Number2
	{
		var position:Vector2=o.globalPosition;
		var x:int=position.x/maxWidth;
		var y:int=position.y/maxHeight;
		
		
		return new Number2(x,y);
	}
}