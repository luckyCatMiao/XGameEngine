package XGameEngine.BaseObject.BaseComponent
{
	import XGameEngine.BaseObject.BaseDisplayObject;
	
	import fl.motion.Animator;
	import fl.motion.Animator3D;
	import fl.motion.Motion;
	import fl.motion.MotionBase;

	public class TweenComponent extends BaseComponent
	{
		
		/**
		 * 播放3D插值动画使用的 这里有个很神奇的bug 用这个播放2D动画居然会出bug...
		 * 正常考虑都会觉得是兼容的，不过居然不兼容，只能是分别用两个放了 
		 */		
		private var animator3D:Animator3D;
		private var animator2D:Animator;
		
		
		private var host:BaseDisplayObject;
		public function TweenComponent(o:BaseDisplayObject)
		{
			host=o;
			animator3D=new Animator3D();
			animator2D=new Animator();
			
		}
		
		
		
		public function playMotion(motion:MotionBase)
		{
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
	}
}