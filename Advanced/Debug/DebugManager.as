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
			
			var data:BitmapData = new BitmapData(100, 100, true, 0x88000000);
			var bitmap:Bitmap = new Bitmap(data);
			
			var s:Stage =GameEngine.getInstance().getStage();
			s.addChild(bitmap);
			
			for each(var name:String in map.Keys)
			{
				var listener:Function = map.get(name) as Function;
				
				var nameText:XTextField = new XTextField();
				nameText.text = name;
				nameText.textColor = Color.WHITE;
				s.addChild(nameText);
				
				
				
				var valueText:XTextField = new XTextField();
				valueText.text = "0";
				valueText.x = 50;
				valueText.textColor = Color.WHITE;
				valueText.type = TextFieldType.INPUT;
				valueText.getExtraValue().put("fun", listener);
				valueText.getExtraValue().put("name", name);
				s.addChild(valueText);
				s.addEventListener(TextEvent.TEXT_INPUT, input);
				
				
				
			}
			
			
		}
		
		private function input(e:TextEvent)
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
		public function AddDebugValue(name:String,listener:Function)
		{
			map.put(name, listener);
			ShowValue();
			
		}
		
		
		
	}

	
}