package XGameEngine.Manager
{
	import XGameEngine.Constant.LayerNameV;
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Map;
	
	import flash.display.Stage;

	/**
	 * ...
	 * @author o
	 */
	public class LayerManager extends BaseManager
	{
		
		
	
		
		
		
			
		static private var _instance:LayerManager;
		
		
		static public function getInstance():LayerManager
		{
				if (_instance == null)
				{
					_instance = new LayerManager();
				}
				return _instance;
		}
		
		private var layers:Map = new Map();
		
		public function LayerManager()
		{
			
			//注册一个默认层
			registerLayer(LayerNameV.DEFAULT);
		}
		
		
		public function getLayer(layerName:String):Layer
		{
			return layers.get(layerName) as Layer;
		}
		
		
		/**
		 * 添加层
		 * @param name
		 * @return 
		 * 
		 */		
		public function registerLayer(name:String)
		{
			if (layers.get(name)==null)
			{
			var layer:Layer = new Layer(name);
			layers.put(name, layer);
			}
			else
			{
			throw new Error("the layer named" + name+"has existed!");
			}
		}
		
		
		//添加gameobject到某一层中
		public function addToLayer(o:BaseGameObject, layerName:String)
		{
		  
				checkLayer(layerName);
		 
				//如果原来属于某个层 从原来的层删除
				removeFromLayer(o);
				
				(layers.get(layerName) as Layer).addObject(o);

		  
		}
		
		public function checkLayer(name:String)
		{
			if (layers.get(name) == null)
			{
				throw new Error("the layer named" + name+"don't existed!");
			}
			
		}
		
		//从当前层中移除
		public function removeFromLayer(o:BaseGameObject)
		{
			for each(var l:Layer in layers.rawData)
			{
				l.removeObject(o);
			}
		}
		
		
		public function debug()
		{
			var line:String="";
			for (var i:String in layers.rawData)
			{
				line+= i + ":";
				var layer:Layer = layers.get(i) as Layer;
				line+= layer.debug()+"\n";
				
			}
			
			trace(line);
		}
		
		
		
		
	}
	
}
//表示一层
//一个gameobject只能在一层中 不能多次出现
class Layer 
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.Structure.List;

	
	private var _name:String;
	private var list:List = new List();
	
		
	public function Layer(name:String)
	{
		this._name = name;
	}
	
	public function get name():String 
	{
		return _name;
	}
	
	
	//添加
	public function addObject(o:BaseGameObject)
	{
		list.add(o);
	}
	//移除
	public function removeObject(o:BaseGameObject)
	{
		list.remove(o);
	}
	
	public function debug():String
	{
		var line:String="";
		for (var i:String in list.Raw)
		{
		  line+= list.get(int(i)).toString() + "  ";	
		}
		
		return line;
	}
	
}