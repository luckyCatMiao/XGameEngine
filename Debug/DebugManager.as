package XGameEngine.Debug
{
	import flash.events.TextEvent;
	import flash.text.TextFieldType
	import flash.display.Stage;
	import flash.text.TextField;
	import XGameEngine.GameEngine;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import XGameEngine.UI.XTextField;
	
	/**
	 * ...
	 * @author o
	 */
	public class DebugManager 
	{
		
		static private var _instance:DebugManager;
		
		private var map:Object = new Object();
		
		static public function getInstance():DebugManager
		{
				if (_instance == null)
				{
					_instance = new DebugManager();
				}
				return _instance;
		}
		
	
		
		/**
		 * called by the GameEngine instance
		 */
		public function loop()
		{
			
		}
		
		
		
		/**
		 * draw the ui base on the values
		 */
		public function ShowValue()
		{
			var data:BitmapData = new BitmapData(100, 100, true, 0x88000000);
			var bitmap:Bitmap = new Bitmap(data);
			
			var s:Stage =GameEngine.getInstance().getStage();
			s.addChild(bitmap);
			
			for (var name:String in map)
			{
				var listener:Function = map[name];
				
				var nameText:XTextField = new XTextField();
				nameText.text = name;
				nameText.textColor = 0xffffffff;
				s.addChild(nameText);
				
				
				
				var valueText:XTextField = new XTextField();
				valueText.text = "0";
				valueText.x = 50;
				valueText.textColor = 0xffffffff;
				valueText.type = TextFieldType.INPUT;
				valueText.getExtraValue()["fun"] = listener;
				valueText.getExtraValue()["name"] = name;
				s.addChild(valueText);
				s.addEventListener(TextEvent.TEXT_INPUT, input);
				
				
				
			}
			
			
		}
		
		public function input(e:TextEvent)
		{
			var t:XTextField = e.target as XTextField;
			var value = t.text;
			var name = t.getExtraValue()["name"];
			t.getExtraValue()["fun"](name,value);
			
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
		public function AddDebugValue(name:String,listener:Function)
		{
			map[name] = listener;
			
			ShowValue();
			
		}
		
		
		
	}
	
}