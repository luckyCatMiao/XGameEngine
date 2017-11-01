package XGameEngine.Plugins.Debug
{
import XGameEngine.*;
import XGameEngine.GameObject.BaseGameObject;
import XGameEngine.Manager.*;
import XGameEngine.Structure.*;
import XGameEngine.UI.Draw.*;
import XGameEngine.UI.Special.XTextField;
import XGameEngine.Util.CollectionUtil;

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.text.*;

/**
	 * ...
	 * a class provide a set of features to help you debug easy
	 */
	public class DebugManager extends BaseManager
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
		
		
		
		/**
		 * 因为矢量图画了之后就不能再获取到 所这边还是每个debug都用一个shape单独来画 然后用名字关联
		 * @return
		 */
		
		private var debugShapes:List = new List();
		/**
		 * 放所有矢量图的面板,和调整数据的面板分开
		 */
		private var debugShapePlane:BaseGameObject = new BaseGameObject("debug Shape");
		
		
		private var map:Map = new Map();
		
		private var debugValuePlane:BaseGameObject = new BaseGameObject("debug Plane");
		private var fps:Object;
		
		public function DebugManager()
		{
			
			//注册一个默认更改debug状态热键 debug五个键一起按下可以改变debug状态
			var keys:Array = [KeyCode.D,KeyCode.E,KeyCode.B,KeyCode.U,KeyCode.G];
			Input.registerComboKey(CollectionUtil.arrayToVectorInt(keys), "debug", 200);
		
			
			
			stage.addChild(debugShapePlane);
			stage.addChild(debugValuePlane);
			


		}
		

		
		
		/**
		 *切换debug状态 
		 * 
		 */		
		public function toggleDebug():void
		{
			GameEngine.getInstance().debug = GameEngine.getInstance().debug == true?false:true;
			if (GameEngine.getInstance().debug == false)
			{
				//移除显示debug数据的板
				debugValuePlane.getGameObjectComponent().removeSelf();
				//移除显示矢量图数据的版
				debugShapePlane.getGameObjectComponent().removeSelf();
				
			}
			else
			{
				stage.addChild(debugValuePlane);
				stage.addChild(debugShapePlane);
			}
			
		}		
		
		
		/**
		 * draw the ui base on the values
		 */
		private function ShowValue()
		{
			if (GameEngine.getInstance().debug == false)
			{
				return ;
			}
			
			var s:Stage = GameEngine.getInstance().stage;
			
			
			debugValuePlane.getGameObjectComponent().removeAllChilds();
			
			
			
			
			
			var data:BitmapData = new BitmapData(100, map.size*20, true, 0x88000000);
			var bitmap:Bitmap = new Bitmap(data);
			
			
			debugValuePlane.addChild(bitmap);
			
			var _y:int = 0;
			for each(var name:String in map.keys)
			{
				var bean:DataBean = map.get(name) as DataBean;
				var listener:Function = bean.listener;
				
				var nameText:XTextField = new XTextField();
				nameText.text = name;
				nameText.textColor = Color.WHITE;
				nameText.size = 15;
				nameText.y = _y;
				debugValuePlane.addChild(nameText);
				
				
				
				var valueText:XTextField = new XTextField();
				valueText.text = bean.defValue+"";
				valueText.x = 80;
				valueText.y = _y;
				valueText.size = 15;
				valueText.textColor = Color.WHITE;
				valueText.type = TextFieldType.INPUT;
				valueText.getExtraValue().put("fun", listener);
				valueText.getExtraValue().put("name", name);
				debugValuePlane.addChild(valueText);
				debugValuePlane.addEventListener(Event.CHANGE, input);
				
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
		 * 添加一个debug值
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
		
		public function drawRect(r:Rectangle, name:String)
		{
			if (GameEngine.getInstance().debug == false)
			{
				return;
			}
			
			var s:Stage = GameEngine.getInstance().stage;
			
			
			//查找该名称的shape是否已经存在
			//不存在的话 创建shape
			var shape:DebugShape;
			
			if ((shape=CheckDebugShape(name)) == null)
			{
				shape = new DebugShape(name);
				debugShapes.add(shape);
				debugShapePlane.addChild(shape.shape);
				
			}
			else
			{		
				shape.shape.graphics.clear();
				//已经存在 擦除
			}
			
		
			var debugShape:Shape = shape.shape;
			//绘制方形
			
			debugShape.graphics.beginFill(Color.BLUE, 0.25);
			debugShape.graphics.drawRect(r.x, r.y, r.width, r.height);
			debugShape.graphics.endFill();

			
			
		}
		
		private function CheckDebugShape(name:String):DebugShape 
		{
			
			
			
			return debugShapes.find(name,"name") as DebugShape;
		}
		
		
		public function createFps():void
		{
			if(this.fps!=null)
			{
				throw new Error("fps已经存在");
			}
			else
			{
				var fps:Fps = new Fps();
				GameEngine.getInstance().debugPlane.addChild(fps);
			}
		}
	}

	
}

import flash.display.Shape;

class DataBean
{
	public var listener:Function;
	public var defValue:Object;
	
}
 class DebugShape
{
	public var name:String;
	public var shape:Shape;
	
	
	public function DebugShape(n:String)
	{
		this.name = n;
		shape = new Shape();
	}
	
	public function toString():String 
	{
		return "[DebugShape name=" + name + " shape=" + shape + "]";
	}
	
}