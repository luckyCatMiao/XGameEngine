package XGameEngine.BaseObject.BaseComponent
{
	import XGameEngine.BaseObject.BaseDisplayObject;
	import XGameEngine.Manager.TweenManager;
	
	import fl.motion.Animator;
	import fl.motion.Animator3D;
	import fl.motion.Motion;
	import fl.motion.MotionBase;
	import fl.motion.MotionEvent;
	import fl.transitions.Tween;

	public class TweenComponent extends BaseComponent
	{
		
		/**
		 * 播放3D插值动画使用的 这里有个很神奇的bug 用这个播放2D动画居然会出bug...
		 * 正常考虑都会觉得是兼容的，不过居然不兼容，只能是分别用两个放了 
		 */		
		private var animator3D:Animator3D;
		private var animator2D:Animator;
		
		
		private var host:BaseDisplayObject;
		private var startListener:Function;
		private var endListener:Function;
		private var updateFunListener:Function;
		public function TweenComponent(o:BaseDisplayObject)
		{
			host=o;
			animator3D=new Animator3D();
			animator3D.addEventListener(MotionEvent.MOTION_START,start3d)
			animator3D.addEventListener(MotionEvent.MOTION_END,end3d);
			animator3D.addEventListener(MotionEvent.MOTION_UPDATE,update3d);	
			
			animator2D=new Animator();
			animator2D.addEventListener(MotionEvent.MOTION_START,start2d)
			animator2D.addEventListener(MotionEvent.MOTION_END,end2d);
			animator2D.addEventListener(MotionEvent.MOTION_UPDATE,update2d);	
			
			
		}
		
		protected function update2d(event:MotionEvent):void
		{
			if(updateFunListener!=null)
			{
				updateFunListener();
			}
			
			
		}
		
		protected function end2d(event:MotionEvent):void
		{
			if(endListener!=null)
			{
				endListener();
			}

		}
		
		protected function start2d(event:MotionEvent):void
		{
			if(startListener!=null)
			{
				startListener();
			}
			
			
		}
		
		protected function update3d(event:MotionEvent):void
		{
			if(updateFunListener!=null)
			{
				updateFunListener();
			}
			
			
		}
		
		protected function end3d(event:MotionEvent):void
		{
			if(endListener!=null)
			{
				endListener();
			}
			
		}
		
		protected function start3d(event:MotionEvent):void
		{
			
			if(startListener!=null)
			{
				startListener();
			}
			
		}		
		
		
		/**
		 *播放一个motion动画 通常使用ide制作后使用脚本导出  tween和motion不能同时播放 属性改变会对冲
		 * @param motion
		 * @return 
		 * 
		 */		
		public function playMotion(motion:MotionBase,startFun:Function=null,endFun:Function=null,updateFun:Function=null)
		{
			
			if(startFun!=null)
			{
				this.startListener=startFun;
			}
			if(endFun!=null)
			{
				this.endListener=endFun;
			}
			if(updateFun!=null)
			{
				this.updateFunListener=updateFun;
			}
			
			//这里使用3d播放 motionBase 2d播放motion
			//真的是很神奇 明明motion继承了motionBase，但是用3D播放motion会出bug
			//不过没有源码我也不知道内部是如何实现的这么SB的
			//然后编辑器那个内置的脚本导出来 就是把包含了3D动画的声明成base 我这边也只能照做
			if(motion is Motion)
			{
				animator2D.motion = motion;
				animator2D.target = host;
				animator2D.play();
			}
			else
			{
				
				animator3D.motion = motion;
				animator3D.target = host;
				animator3D.play();
			}

		}
		
		
		/**
		 * 播放一个简单的tween插值动画 tween和motion不能同时播放 属性改变会对冲
		 * @param fieldName 需要变化的属性名
		 * @param fun 变化方法
		 * @param fieldChange 需要变化的值(在当前值的基础上)
		 * @param lastTime 变化时间 帧数
		 * @param delay 启动延时
		 * 
		 */		
		public function playTween(fieldName:String, fun:Function, fieldChange:Number,lastTime:int,delay:int=0,times:int=1,reverse:Boolean=false):Tween
		{
			
			return TweenManager.getInstance().playTween(host,fieldName, fun, fieldChange,lastTime,delay,times,reverse);
			
		}
	}
}