package XGameEngine.GameObject.Map
{
	import Script.GameObject.GameMap;
	import Script.GameObject.Player;
	
	import XGameEngine.Advanced.Debug.DebugManager;
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.List.DifferentList;
	import XGameEngine.Structure.Map;
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.Structure.Math.Vector2;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
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
		
		
		
		private var _springScale:Number;
		public function LayerMap(_springScale:Number=-1)
		{
			this.xname ="layerMap "+this.name;
			
			otherMaps.throwErrorWhenSame = true;
			//设置比较方法为MapLayer的名字
			var fun:Function = function(o1:Object, o2:Object):Boolean
			{
				
				return (o1 as MapLayer).name == (o2 as MapLayer).name;
			}
			otherMaps.setEqual(fun);
			
			this.springScale = _springScale == -1?1:_springScale;
	
		}
		
		
		
		override protected function loop() 
		{
			moveCam();
		}
		
		private function moveCam():void 
		{
			var point:Point = mainChara.centerGlobalPoint;
			var moveX:Number=0;
			var moveY:Number=0;
			
			//根据相对位置 更新所有夹层的位置 造成镜头缓动效果
			//springScale=1为特殊值 没有缓动 
			//在moveRect范围之外弹簧才开始起作用
			if (point.x > _moveRect.getRightBottomPoint().x)
			{
				moveX = -(point.x - _moveRect.getRightBottomPoint().x) / 5 * springScale * _springScale;	
				if(springScale==1)
				{
					moveX=-(point.x - _moveRect.getRightBottomPoint().x);
				}
			}
			else if (point.x < _moveRect.getLeftBottomPoint().x)
			{
				moveX = -(point.x - _moveRect.getLeftBottomPoint().x) / 5 * springScale * _springScale;
				if(springScale==1)
				{
					moveX=-(point.x - _moveRect.getLeftBottomPoint().x)
				}
			}
			
			
			if (point.y <_moveRect.getRightTopPoint().y)
			{
				
				moveY = -(point.y - _moveRect.getRightTopPoint().y) / 5 * springScale * _springScale;
				if(springScale==1)
				{
					moveY=-(point.y - _moveRect.getRightTopPoint().y);
				}

			}
			else if (point.y >_moveRect.getRightBottomPoint().y)
			{
				moveY = -(point.y - _moveRect.getRightBottomPoint().y) / 5 * springScale * _springScale;
				if(springScale==1)
				{
					moveY=-(point.y - _moveRect.getRightBottomPoint().y);
				}
			}
	
			
			if (canMoveOtherLayer(moveX, 0))
				{
					
				this.mainMap.map.move(moveX, 0);
				moveOtherLayer(moveX, 0);
				}
			
				if (canMoveOtherLayer(0, moveY))
				{
					
				this.mainMap.map.move(0, moveY);
				moveOtherLayer(0, moveY);
				}
				
			
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
		public function addToNormalLayer(o:DisplayObject, name:String="", autoCreate:Boolean=false,moveScale:Number=1,springScale:Number=1,canOver:Boolean=false)
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
				m.map.canOver=canOver;
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
		override public function move(x:Number, y:Number):Vector2
		{
			if (moveRect != null)
			{
				
				var point:Point = mainChara.localToGlobal(new Point(0,0));
		
				//如果主角色想往右边移动
				if (x>0)
				{			
						//移动主层
							if (point.x < stage.stageWidth-15||canOver)
							{
								
								mainMap.map.move(x, 0);
							}
					
				}
				
				//如果主角色想往左边移动
				else if (x<0)
				{	

							if (point.x > 15||canOver)
							{
								mainMap.map.move(x, 0);
							}
					
				}
				
				
				//如果主角色想往下边移动
				if (y>0)
				{	
							if (point.y < stage.stageHeight-15||canOver)
							{
								mainMap.map.move(0, y);
							}
					
				}
				//如果主角色想往上边移动
				else if (y<0)
				{	
					
							//否则继续移动主层 直到碰到舞台边缘
							if (point.y > 15||canOver)
							{
								mainMap.map.move(0, y);
							}
					
				}
				
				//y轴移动还没写 跟上面差不多
				
			}
			else
			{
				//主层不移动
				//普通层反向移动
			moveOtherLayer( -x, -y);
			
			
			}
			
			
			//因为夹层地图是相对移动 所以不返回有意义的值
			return new Vector2(0, 0);
		
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
		
		private function canMoveOtherLayer(x:Number, y:Number):Boolean 
		{
			//有一层无法继续移动则返回失败
			
	
			for each (var l:MapLayer in otherMaps.Raw ) 
			{
				if (l.map.canMove(x, y) == false)
				{
					return false;
				}
				
			}
			return true;

		}
		
		
		private function moveOtherLayer(x:Number, y:Number) 
		{	
			
			//移动所有层
			if (canMoveOtherLayer(x,y))
			{
			
				for each (var q:MapLayer in otherMaps.Raw ) 
				{
					
					q.map.move(x, y) 
				}
			
			}
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
		
		public function get springScale():Number 
		{
			return _springScale;
		}
		
		public function set springScale(value:Number):void 
		{
			//系数为0-1
			if (value >= 0 && value <= 1)
			{
				_springScale = value;
			}
			
			else
			{
				throw new Error("the value need between 0-1");
			}
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