package XGameEngine.Manager
{
	import Script.UI.GameUI.Tip;
	
	import XGameEngine.BaseObject.BaseDisplayObject;
	
	import fl.motion.MotionBase;
	import fl.transitions.Tween;
	
	import flash.display.DisplayObject;

	public class TweenManager extends BaseManager
	{
		static private var _instance:TweenManager;
		
		
		static public function getInstance():TweenManager
		{
			if (_instance == null)
			{
				_instance = new TweenManager();
			}
			return _instance;
		}
		
		
	
		/**
		 *为一组对象根据延时先后播放同一组动画，可以用在类似的动画形成一组动画的情况，
		 * 比如list每个选项都从上到下淡入出现,
		 * @param objs
		 * @param fieldName
		 * @param fun
		 * @param fieldChange
		 * @param lastTime
		 * @param delay
		 * 
		 */		
		public function playGroupTween(objs:Array,fieldName:String, fun:Function, fieldChange:Number,lastTime:int,delay:Number=0):void
		{
			for(var i:int=0;i<objs.length;i++)
			{
				var o:DisplayObject=objs[i] as DisplayObject;
				
				
				playTween(o,fieldName,fun,fieldChange,lastTime,delay*i);
				
			}
			
			
		}
		
		/**
		 * 播放一个简单的tween插值动画
		 * @param obj 动画对象
		 * @param fieldName 需要变化的属性名
		 * @param fun 变化方法
		 * @param fieldChange 需要变化的值(在当前值的基础上)
		 * @param lastTime 变化时间 帧数
		 * @param delay 播放延时
		 * 
		 */		
		
		public function playTween(obj:DisplayObject, fieldName:String, fun:Function, fieldChange:Number, lastTime:int,delay:Number=0):Tween
		{
			
			
			var nowValue:Number=obj[fieldName] as Number;
			var targetValue:Number=nowValue+fieldChange;
			
			var tween:Tween=new Tween(obj,fieldName,fun,nowValue,targetValue,lastTime,false);
			tween.stop();
			
			getFunComponent().addDelayRecall(startPlayTween,delay,[tween]);
			
			return tween;
			
		}
		
		private function startPlayTween(arr:Array):void
		{
			
			(arr[0] as Tween).resume();
			
		}
		
		public function loop():void
		{
			
			getFunComponent().loop();
			
		}
		
//	
//		/**
//		 *对Motion的xyz值进行修正  因为自带的那个脚本生成出来的代码是一段固定值的变化 比如x从100变化到200
//		 * 实用性比较差，所以这里修正为增量值,改为从当前x增加100
//		 * 暂时只修正坐标值 其他值比如缩放的旋转只要做的时候注意一下就好
//		 * @param __motion_tipStartMotion
//		 * @param param1
//		 * @return 
//		 * (发现实际上播放的时候会根据初始值来.. 只不过要注意先设置初始值 然后再播放 不能在构造函数中播放 因为此时xy都为0)
//		 */		
//		public function correctMotion(motion:MotionBase, param1:Tip):fl.motion.MotionBase
//		{
//			// TODO Auto Generated method stub
//			return motion;
//		}
	}
}