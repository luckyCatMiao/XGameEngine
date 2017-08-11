
package XGameEngine.Manager
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	

	
	final public class Input
	{
		
		//represent the key state
		static private var KEYSTATE_DOWN:uint = 0;
		static private var KEYSTATE_UP:uint = 1;
		static private var KEYSTATE_DOWNING:uint = 2;
		static private var KEYSTATE_UPING:uint = 3;
		
		//按键object
		static private var KEYINFO_STATE:String = "keystate";
		static private var KEYINFO_ISLOCKED:String = "locked";
		
		
		static private var keyState:Object = new Object();
		
		//combo组 保存连续按下的组合键
		static private var comboKeys:Object = new Object();
		
		//combo组2 保存同时按下的组合键
		static private var comboKeysDowning:Object = new Object();
		
		
		static private var sta:Stage;
		
		//初始化
		public static function Init(sta:Stage):void
		{
			sta.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
			sta.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			sta.addEventListener(Event.ENTER_FRAME, loop);
			
			sta.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			sta.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			Input.sta = sta;
		}
		
		
		//与键盘按键同一方式设置
		private static function mouseDown(e:MouseEvent)
		{
			setKeyDown(KeyCode.MOUSE_LEFT);
		}
		
		
		private static function mouseUp(e:MouseEvent)
		{
			setKeyUp(KeyCode.MOUSE_LEFT);
		}
		
		
		static private function loop(e:Event)
		{
			
		   for(var key:String in keyState)
		   {
			 if(keyState[key][KEYINFO_STATE] == KEYSTATE_UP&&keyState[key][KEYINFO_ISLOCKED]==false)
			 {
				 keyState[key][KEYINFO_STATE] = KEYSTATE_UPING;
			 }
			 if (keyState[key][KEYINFO_STATE] == KEYSTATE_DOWN&&keyState[key][KEYINFO_ISLOCKED]==false)
			 {
				keyState[key][KEYINFO_STATE] = KEYSTATE_DOWNING;
			 }
			 
			 keyState[key][KEYINFO_ISLOCKED] = false;
		   }
		   
		   
		   for each(var c:comboKey in comboKeys)
		   {
			   //如果已经触发
			   if (c.isTrigger)
			   {
				  if (c.isLock == false && c.isTrigger==true)
				  {
					  c.isTrigger = false;
				  }
				  else if (c.isLock)
				  {
					  c.isLock = false;
				  }
			   }
			   
			   c.reduceTime(1 / sta.frameRate);
		   }
		   	
		   
		}
		
		
		//进行按键状态锁定 每帧只能改变一次按键状态,防止变化过快捕捉不到
		private static function keyDown(e:KeyboardEvent):void
		{
			//使用中文输入法会有bug 直接忽略
			try
			{
				setKeyDown(e.keyCode);	
			} 
			catch(error:Error) 
			{
				
			}
			

		}
		private static function setKeyDown(keyCode:int):void
		{
			if (keyState[keyCode] == null)
			{
				keyState[keyCode] = { keystate:KEYSTATE_DOWN, locked:true };
				
				checkComboKeys(keyCode);
			}
			
			
			if (keyState[keyCode][KEYINFO_STATE] == KEYSTATE_UP || keyState[keyCode][KEYINFO_STATE] == KEYSTATE_UPING)
			{
				if (!keyState[keyCode][KEYINFO_ISLOCKED])
				{
				keyState[keyCode][KEYINFO_STATE] = KEYSTATE_DOWN;
				keyState[keyCode][KEYINFO_ISLOCKED] = true;
				
				checkComboKeys(keyCode);
				}
			}
		}
		
		private static function keyUp(e:KeyboardEvent):void
		{
			try
			{
				setKeyUp(e.keyCode);
				
			} 
			catch(error:Error) 
			{
				
			}
			
			
		}
		private static function setKeyUp(keyCode:int):void
		{
			
		   if (keyState[keyCode][KEYINFO_STATE] == KEYSTATE_DOWN ||keyState[keyCode][KEYINFO_STATE] == KEYSTATE_DOWNING)
			{
				if (!keyState[keyCode][KEYINFO_ISLOCKED])
				{
				keyState[keyCode][KEYINFO_STATE] = KEYSTATE_UP;
				keyState[keyCode][KEYINFO_ISLOCKED] = true;
				}
			}
		}
		
		
		
		
		
		
//------------------------------------------------------------------------------------------------------------------------------------------		
		static public function isKeyDowning(keyCode:int):Boolean
		{
			//这里把down和downing都返回true了 不然貌似单单检测downing会有不爽的延时 虽然只有两帧还是感觉的出来
			if (keyState[keyCode]!=null&&(keyState[keyCode][KEYINFO_STATE] == KEYSTATE_DOWNING||keyState[keyCode][KEYINFO_STATE] == KEYSTATE_DOWN))
			{
				return true;
			}
			return false;
		}
		
		static public function isKeyUping(keyCode:int):Boolean
		{
			if (keyState[keyCode]==null||keyState[keyCode][KEYINFO_STATE] == KEYSTATE_UPING||keyState[keyCode][KEYINFO_STATE] == KEYSTATE_UP)
			{
				return true;
			}
			return false;
		}
		
		static public function isKeyDown(keyCode:int):Boolean
		{
			if (keyState[keyCode]!=null&&keyState[keyCode][KEYINFO_STATE] == KEYSTATE_DOWN)
			{
				return true;
			}
			return false;
		}
		
		
		static public function isKeyUp(keyCode:int):Boolean
		{
			if (keyState[keyCode]!=null&&keyState[keyCode][KEYINFO_STATE] == KEYSTATE_UP)
			{
				return true;
			}
			return false;
		}
		
		
		
		
		/**
		 *注册组合键,当按键在规定时间内都(按下过)后触发 
	     *触发状态保持一帧
		 *时间默认值为-1,即无限时 
		 * @param keyCodes
		 * @param comboName
		 * @param time
		 * 
		 */		
		static public function registerComboKey(keyCodes:Vector.<int>,comboName:String,time:Number=-1):void
		{
		  if (comboKeys[comboName] != null)
		  {
			  throw new Error("类型1组合键注册失败!" + comboName+"已经存在");
		  }
		  
		  comboKeys[comboName] = new comboKey(keyCodes, comboName, time);
			
		}
		

		
		
		/**
		 * 检测组合键是否触发
		 * @param	comboName
		 * @return
		 */
		static public function isComboKey(comboName:String):Boolean
		{
			
			
			if ((comboKeys[comboName])!=null&&(comboKey)(comboKeys[comboName]).isTrigger)
			{
			return true;
			}
			else
			{
			return false;
			}
		}
		
		
		//对按下的某个键执行组合键检测
		static private function checkComboKeys(keyCode:int):void
		{
			for each(var c:comboKey in comboKeys)
			{
				c.checkNowKey(keyCode);
			}
			
		}
		
		//注册组合键,当按键(同时按住)后触发 如果数组中有相同的按键 则报错
		static public function registerComboKeyDowning(keyCodes:Vector.<int>,comboName:String):void
		{
		  if (comboKeysDowning[comboName] != null)
		  {
			  throw new Error("类型2组合键注册失败!" + comboName+"已经存在");
		  }
		  
		  comboKeysDowning[comboName] = {codes:keyCodes, name:comboName};
			
		}
		
		static public function isComboKeyDowning(comboName:String):Boolean
		{
			var result:Boolean = true;
			for each(var i:Object in comboKeysDowning)
			{
				var codes:Vector.<int> = i.codes;
				
				for (var q:int = 0; q < codes.length; q++)
				{
					if (!Input.isKeyDowning(codes[q]))
					{
						result = false;
						break;
					}
				}
				
				
				
			}
			
			
			return result;
		}
		
		
	
		/**
		 *检查是否keys中的任意一个key处在Downing 状态(例如 检测abcd键是否有一个处于按下状态)
		 * @param keys
		 * @return 
		 * 
		 */		
		public static function isOneKeyDowning(keys:Array):Boolean
		{
			
			for each(var key:int in keys)
			{
				if(isKeyDowning(key))
				{
						return true
				}
			}
			
			return false;
		}
		
		
		/**
		 *检查是否keys中的任意一个key处在弹起 状态(例如 检测abcd键是否有一个弹起)
		 * @param keys
		 * @return 
		 * 
		 */		
		public static function isOneKeyUp(keys:Array):Boolean
		{
			
			for each(var key:int in keys)
			{
				if(isKeyUp(key))
				{
					return true
				}
			}
			
			return false;
		}
		
		/**
		 *检查是否keys中的任意一个key处在按下 状态(例如 检测abcd键是否有一个按下)
		 * @param keys
		 * @return 
		 * 
		 */		
		public static function isOneKeyDown(keys:Array):Boolean
		{
			for each(var key:int in keys)
			{
				if(isKeyDown(key))
				{
					return true
				}
			}
			
			return false;
		}
	}
	
}




//类似java内部类 草 搞的这么奇怪
class comboKey
{
	private var keyCodes:Vector.<int>;
	private var comboName:String;
	private var time:Number;
	private var time2:Number;
	
	//指向当前需要按下的按键
	private var nowKeyIndex:int;
	
	public var isTrigger:Boolean = false;
	
	//锁定一帧
	public var isLock:Boolean = false;
	
	public function comboKey(keyCodes:Vector.<int>,comboName:String,time:Number=-1)
	{
		this.keyCodes = keyCodes;
		this.comboName = comboName;
		this.time = time;
		time2 = time;
		
		nowKeyIndex = 0;
	}
	
	public function checkNowKey(keyCode:int):void
	{
		
		//如果相等
		if (keyCodes[nowKeyIndex] == keyCode)
		{
			//如果已经全部触发 进行设置
			if (nowKeyIndex == keyCodes.length-1)
			{
                isLock = true;
				isTrigger = true;
				
				reset();
			}
			else
			{
				nowKeyIndex++;
			}
			
		}
		//不相等则重置
		else
		{
			reset();
		}
		
	}
	
	public function reduceTime(t:Number)
	{
	   if (this.time != -1)
	   {
		   time-= t;
		   if (time <= 0)
		   {
			  reset();
		   }
	   }
		
	}
	
	private function reset()
	{
		nowKeyIndex = 0;
		time = time2;
	}
	
	
	
}
