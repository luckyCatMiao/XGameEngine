package XGameEngine.Advanced.Debug
{
	import XGameEngine.UI.Draw.Color;
	import flash.events.TextEvent;
	import flash.text.TextFieldType
	import flash.display.Stage;
	import flash.text.TextField;
	import XGameEngine.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import XGameEngine.Advanced.Interface.LoopAble;
	import XGameEngine.Structure.*;
	import XGameEngine.UI.*;
	
	/**
	 * ...
	 * a class provide a set of features to help you debug easy
	 */
	public class DebugManager implements LoopAble
	{
		
		static private var _instance:DebugManager;
		
		static public function getInstance():DebugManager
		{
			if (GameEngine.getInstance().debug == false)
			{
				throw new Error("Please open the debug mode!set the bool value in GameEngine class");
			}
			
				if (_instance == null)
				{
					_instance = new DebugManager();
				}
				return _instance;
			
		}
		
	
		
		private var map:Map = new Map();
		
		/**
		 * called by the GameEngine instance
		 */
		public function loop()
		{
		}
		
		
		
		/**
		 * draw the ui base on the values
		 */
		private function ShowValue()
		{
			
			var s:Stage = GameEngine.getInstance().getStage();
			
			if (s.getChildByName("bbb") != null)
			{
				s.removeChild(s.getChildByName("bbb"));
			}
			
			var data:BitmapData = new BitmapData(100, map.size*20, true, 0x88000000);
			var bitmap:Bitmap = new Bitmap(data);
			bitmap.name = "bbb";
			
			
			s.addChild(bitmap);
			
			var _y:int = 0;
			for each(var name:String in map.Keys)
			{
				var bean:DataBean = map.get(name) as DataBean;
				var listener:Function = bean.listener;
				
				var nameText:XTextField = new XTextField();
				nameText.text = name;
				nameText.textColor = Color.WHITE;
				nameText.size = 15;
				nameText.y = _y;
				s.addChild(nameText);
				
				
				
				var valueText:XTextField = new XTextField();
				valueText.text = bean.defValue+"";
				valueText.x = 80;
				valueText.y = _y;
				valueText.size = 15;
				valueText.textColor = Color.WHITE;
				valueText.type = TextFieldType.INPUT;
				valueText.getExtraValue().put("fun", listener);
				valueText.getExtraValue().put("name", name);
				s.addChild(valueText);
				s.addEventListener(Event.CHANGE, input);
				
				_y += 15;
				
			}
			
			
		}
		
		private function input(e:Event)
		{
			//get the textfield
			var t:XTextField = e.target as XTextField;
			//get the value
			var value = t.text;
			//get the originnal field name
			var name = t.getExtraValue().get("name");
			//get the function
			var fun:Function = t.getExtraValue().get("fun") as Function;
			//call the function 
			fun(name, value);
			
		}
		
		
		/**
		 * add a value that able to show in a plane,which value can be dynamic 
		 * within the game,the plane is just used in the game test,for a quick
		 * value change instead of every time change a value then recompile it
		 * @param	name  the field name,it's don't need as same as the field name
		 *,it just a symbol
		 * @param	listener the function will be recall every time value changed.
		 * it's need a same structure like this(except the name)
		 * public function OnRecall(name:String,value:String)
		 */
		public function AddDebugValue(name:String, listener:Function, defaultValue:int = 0)
		{
			var bean:DataBean = new DataBean();
			bean.defValue = defaultValue;
			bean.listener = listener;
			map.put(name, bean);
			ShowValue();
			
		}
		
		
		
	}

	
}

class DataBean
{
	public var listener:Function;
	public var defValue:Object;
	
}