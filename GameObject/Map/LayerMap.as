package XGameEngine.GameObject.Map
{
	import flash.display.DisplayObject;
	import Script.GameObject.GameMap;
	import Script.GameObject.Player;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Map;
	
	/**
	 * ...
	 *	夹层地图 包含一个主层和若干其他层
	 */
	public class LayerMap extends BaseMap
	{
		/*static public var LAYER_MAIN:String = "main layer";
		static public var LAYER_NORMAL:String = "normal layer";*/
		
		
		private var mainMap:MapLayer;
		private var otherMaps:List = new List();
		
		
		
		/**
		 * 添加普通层
		 */
		public function addNormalLayer(name:String,map:BaseMap)
		{
			
			for each(var l:MapLayer in otherMaps.Raw)
			{
				if (l.name == name)
				{
					throw new Error("the map which named "+name+" has existed");
				}
			}
			
			var layer:MapLayer = new MapLayer();
			layer.map = map;
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
			layer.name = name;
			map.canOver = true;
			
			addChild(layer.map);
			mainMap = layer;
		}
		
		/**
		 * 添加物体到主层
		 * @param	player
		 * @param	string
		 * @param	boolean 如果主层不存在 是否自动创建主层
		 */
		public function addToMainLayer(o:DisplayObject, string:String="", autoCreate:Boolean=false):void 
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
				
			}
			
		}
		
		/**
		 * 添加物体到普通层
		 * @param	player
		 * @param	string
		 * @param	boolean 如果普通层不存在 是否自动创建普通层
		 */
		public function addToNormalLayer(o:DisplayObject, name:String="", autoCreate:Boolean=false):void 
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
					
				addNormalLayer(m.name, m.map);
				findLayer(name).map.addChild(o);
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
		
		private function findLayer(name:String):MapLayer 
		{
			for each(var l:MapLayer in otherMaps.Raw)
			{
				if (l.name == name)
				{
					return l;
				}
			}
			
			return null;
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
			//主层不移动
			
			//普通层反向移动
			for each (var l:MapLayer in otherMaps.Raw ) 
			{
				l.map.move( -x, -y);
				
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