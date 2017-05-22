package XGameEngine.GameObject.Map
{
	import XGameEngine.Advanced.Debug.DebugManager;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import Script.GameObject.GameMap;
	import Script.GameObject.Player;
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.List.DifferentList;
	import XGameEngine.Structure.Map;
	import XGameEngine.Structure.Math.Rect;
	
	/**
	 * ...
	 *	夹层地图 包含一个主层和若干其他层
	 */
	public class LayerMap extends BaseMap
	{
		/*static public var LAYER_MAIN:String = "main layer";
		static public var LAYER_NORMAL:String = "normal layer";*/
		
		
		private var mainMap:MapLayer;
		private var mainChara:BaseGameObject;
		/**
		 * 主角色的可移动范围,范围内移动主层 否则移动所有其他层
		 */
		private var _moveRect:Rect;
		
		private var otherMaps:DifferentList = new DifferentList();
		
		/**
		 * debug模式中是否绘制出移动范围
		 */
		public var debugRect:Boolean = false;
		
		
		public function LayerMap()
		{
			this.xname ="layerMap "+this.name;
			
			otherMaps.throwErrorWhenSame = true;
			//设置比较方法为MapLayer的名字
			var fun:Function = function(o1:Object, o2:Object):Boolean
			{
				
				return (o1 as MapLayer).name == (o2 as MapLayer).name;
			}
			otherMaps.setEqual(fun);
		}
		
		/**
		 * 添加普通层
		 */
		public function addNormalLayer(name:String,map:BaseMap)
		{
			
			var layer:MapLayer = new MapLayer();
			layer.map = map;
			//把Map的名字也改过来好了
			layer.map.xname ="layer " +name;
			layer.name = name;
			
			addChild(layer.map);
			
			otherMaps.add(layer);
		}
		
		
		/**
		 * 添加主层 主层只能拥有一个
		 */
		public function addMainLayer(name:String,map:BaseMap)
		{
			if (mainMap != null)
			{
				throw new Error("the main layer has existed!");
			}
			var layer:MapLayer = new MapLayer();
			layer.map = map;
			layer.map.xname = "layer " + name;
			layer.name = name;
			
			//主层默认边界可以在内部
			map.canOver = true;
			
			addChild(layer.map);
			mainMap = layer;
		}
		
		/**
		 * 添加物体到主层(默认设置第一个对象为主层里的主角色)
		 * @param	player
		 * @param	string
		 * @param	boolean 如果主层不存在 是否自动创建主层
		 */
		public function addToMainLayer(o:BaseGameObject, string:String="", autoCreate:Boolean=false):void 
		{
			if (autoCreate == false && mainMap == null)
			{
				throw new Error("the main layer doen'nt exist! try to add " + o + " failed!");
			}
			if (autoCreate == true)
			{
				if (mainMap == null)
				{
					var m:MapLayer = createNormalLayer(string);
				
					
					addMainLayer(m.name, m.map);
				}
				mainMap.map.addChild(o);
				if (mainMap.map.numChildren == 1)
				{
					setMainLayerMainCharacter(o);
				}
				
			}
			
		}
		
		/**
		 * 添加物体到普通层
		 * @param	player
		 * @param	string
		 * @param	boolean 如果普通层不存在 是否自动创建普通层
		 */
		public function addToNormalLayer(o:DisplayObject, name:String="", autoCreate:Boolean=false,moveScale:Number=1):void 
		{

			if (autoCreate == false)
			{
				if (findLayer(name) == null)
				{
					throw new Error("the layer " + name+" don't exist!");
				}
				else
				{
					findLayer(name).map.addChild(o);
				}
			}
			else
			{
				var m:MapLayer = createNormalLayer(name);
				m.map.moveScale = moveScale;
				addNormalLayer(m.name, m.map);
				findLayer(name).map.addChild(o);
			}
		}
		
		
		/**
		 * 设置主要层里的主要角色 移动就是根据该角色来计算!
		 */
		public function setMainLayerMainCharacter(o:BaseGameObject):void 
		{
			if (mainMap==null)
			{
				throw new Error("the main layer doen'nt exist!");
			}
			
			if (mainMap.map.getGameObjectComponent().hasChild(o) == false)
			{
				throw new Error("the " + o + " object doesn't in the main layer!");
			}
			else
			{
				mainChara = o;
			}
		}
		
		public function debug():void 
		{
			trace("main layer:" + mainMap);
			for (var i:int = 0; i < otherMaps.size; i++)
			{
				trace("layer:" + (otherMaps.get(i) as MapLayer));
			}
			
		}
		
		public function findLayer(name:String):MapLayer 
		{
			
			return otherMaps.find(name,"name") as MapLayer;
		}
		
		private function createNormalLayer(name:String):MapLayer
		{
					var m:MapLayer = new MapLayer();
					m.name = name;
					m.map = new BaseMap();
					
					return m;
		}
		
		
		/**
		 * 进行移动 xy为主层想要移动的方向
		 * @param	x
		 * @param	y
		 */
		override public function move(x:Number, y:Number)
		{
			if (moveRect != null)
			{
				
				var point:Point = mainChara.localToGlobal(new Point(0,0));
		
				//如果主角色想往右边移动
				if (x>0)
				{	
					//如果在主角色在移动右边界左边
					if (point.x <moveRect.getRightBottomPoint().x)
					{
						//移动主层
						mainMap.map.x += x;
							
					}
					else
					{
						//如果副层还可以移动则移动副层
						if (moveOtherLayer(-x, -y)==true)
						{
							
						}
						else
						{
							//否则继续移动主层 直到碰到舞台边缘
							if (point.x < stage.stageWidth-15)
							{
								mainMap.map.x += x;
							}

						}
						
					}
					
				}
				
				//如果主角色想往左边移动
				if (x<0)
				{	
					//如果在主角色在移动左边界右边
					if (point.x >moveRect.getLeftBottomPoint().x)
					{
						//移动主层
						mainMap.map.x += x;
							
					}
					else
					{
						//如果副层还可以移动则移动副层
						if (moveOtherLayer(-x, -y)==true)
						{
							
						}
						else
						{
							//否则继续移动主层 直到碰到舞台边缘
							if (point.x > 15)
							{
								mainMap.map.x += x;
							}

						}
						
					}
					
				}
				
			}
			else
			{
				//主层不移动
				//普通层反向移动
			moveOtherLayer( -x, -y);
			
			
			}
			
		
		}
		
		
		/**
		 * 这个实在不知道怎么覆盖。。好像要写的很复杂 等以后用到再写吧 而且也用不到
		 * @param	x
		 * @param	y
		 * @return
		 */
		override public function canMove(x:Number, y:Number):Boolean 
		{
			return true;
		}
		
		private function moveOtherLayer(x:Number, y:Number):Boolean 
		{
			//有一层无法继续移动则返回失败
			
			
			var b:Boolean = true;
			
			for each (var l:MapLayer in otherMaps.Raw ) 
			{
				if (l.map.canMove(x, y) == false)
				{
					return false;
				}
				
			}
			
			//如果所有层都可以移动 移动所有层
			if (b)
			{
				for each (var q:MapLayer in otherMaps.Raw ) 
				{
				q.map.move(x, y) 
				
				
				}
			}
			
			return b;
		}
		
		public function moveX(x:Number) 
		{
			move(x, 0);
		}
		
		public function moveY( y:Number) 
		{
			move(0, y);
		}
		
		public function get moveRect():Rect 
		{
			return _moveRect;
		}
		
		public function set moveRect(value:Rect):void 
		{
			if (gameEngine.debug == true && debugRect == true)
			{
				DebugManager.getInstance().drawRect(value.toRectangle(),"moveRect");
			}
			_moveRect = value;
		}
		
		
		
	}
	
}

import XGameEngine.GameObject.Map.BaseMap;
class MapLayer
{
	public var name:String;
	public var map:BaseMap;
	
	public function toString():String 
	{
		return "[ name=" + name + "   childs="+map.numChildren+"]";
	}
}