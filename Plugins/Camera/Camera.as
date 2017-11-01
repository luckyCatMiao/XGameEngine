package XGameEngine.Plugins.Camera
{
	import XGameEngine.BaseObject.BaseDisplayObject;
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.Manager.TweenManager;
	import XGameEngine.Structure.Math.Rect;
	
	import fl.motion.easing.Circular;
	import fl.motion.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class Camera extends BaseDisplayObject
	{
		
		
		private var showObj:DisplayObject;
		
		private var b:Bitmap;
		private var lockChild:DisplayObject;
		private var lockStartX:Number;
		private var lockStartY:Number;
		private var lockX:Boolean;
		private var lockY:Boolean;
		
		
		/**
		 *是否可以越过对象的边界(和layerMap的canOver是一个意思) 
		 */		
		public var canOver:Boolean=false;
		/**
		 *实际用作边界检测的对象 例如可能要画出整个gamePlane 但是比如子弹之类的会飞出边界
		 * 此时不能拿整个gamePlane做边界检测 
		 */		
		public var overCheckObj:DisplayObject;
		public var renderHeight:Number;
		public var renderX:Number;
		public var renderY:Number;
		public var renderWidth:Number;
		public var renderScaleX:Number=1;
		public var renderScaleY:Number=1;
		/**
		 *播放范围 即显示的部分被扩展到多大 例如投影仪投影一个东西的部分到整个屏幕
		 * (虽然在外部直接改变camera的width也可以 但问题是在缩放条件下width每一帧都会自己改变)
		 * 所以必须设置一个这个值 来自动固定播放范围
		 */		
		public var playRect:Rect;
	
		
		
		/**
		 *     
		 * @param o 需要显示的对象 
		 * @param showObjRect 显示的对象范围 
		 * @param cameraRect 摄像机的rect，即对显示的对象的缩放 如把一个角落放大
		 * 
		 */		
		public function Camera(o:DisplayObject,showObjRect:Rect,playRect:Rect=null)
		{
		
			
			if(playRect==null)
			{
				this.playRect=Rect.getStageRect();
			}
			
			this.showObj=o;
			this.showObjRect=showObjRect;
			
			
		
			b=new Bitmap();
			addChild(b);
			
			overCheckObj=o;
			
			//马上画出 这样构造器一返回 width属性和height就不为0
			loop();

			
		}
		
		public function get showObjRect():Rect
		{
			
			return new Rect(renderX,renderY,renderWidth,renderHeight)
		}
		
		
		public function set scale(value:Number)
		{
			renderScaleX=value;
			renderScaleY=value;
		}
		
		public function get scale():Number
		{
			return renderScaleX;
		}
		
		public function set showObjRect(showObjRect:Rect)
		{
			this.renderX=showObjRect.x;
			this.renderY=showObjRect.y;
			this.renderWidth=showObjRect.width;
			this.renderHeight=showObjRect.height;
			
		}
		
		override protected function loop():void
		{
			
		
			
			var r:Rect=showObjRect.clone();
			
			//如果有锁定对象
			if(lockChild!=null)
			{
				if(lockX)
				{
					r.x+=lockChild.x-lockStartX;
				}
				if(lockY)
				{
					r.y+=lockChild.y-lockStartY;
					
				}
				
			}
			


			
			//进行缩放 (scaleX和scaleY为2则代表镜头方法两倍 即实际的rect朝中间收缩两倍)

			r.shrinkX(1/renderScaleX);
			r.shrinkY(1/renderScaleY);
			
		
			
			
			//如果范围溢出且设置为不能溢出 则重置范围
			if(canOver==false)
			{
				var rect2:Rectangle=overCheckObj.getRect(showObj);

				if(r.x<rect2.x)
				{
					r.x=rect2.x;
				}
				if(r.y<rect2.y)
				{
					r.y=rect2.y;
				}
				if(r.x+r.width>rect2.x+rect2.width)
				{
					r.x=rect2.x+rect2.width-r.width;
				}
				if(r.y+r.height>rect2.y+rect2.height)
				{
					r.y=rect2.y+rect2.height-r.height;
				}
				
				
			}
			
		
			
			var data:BitmapData=new BitmapData(r.width,r.height);
			data.lock();
			var m:Matrix=new Matrix();
			m.translate(-r.x,-r.y);
			data.draw(showObj,m);
			
			b.bitmapData=data;
			
			b.width=playRect.width;
			b.height=playRect.height;
			b.x=playRect.x;
			b.y=playRect.y;

			data.unlock()
		}
		
		/**
		 *移动 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public function move(x:Number,y:Number)
		{
			renderX+=x;
			renderY+=y;
		}
		
		/**
		 *缩放镜头 
		 * @param scaleX
		 * @param scaleY
		 * @return 
		 * 
		 */		
		public function zoom(scaleX:Number=1,scaleY:Number=1)
		{
			renderScaleX=scaleX;
			renderScaleY=scaleY;
		}
		
		
		
		/**
		 *锁定镜头到对象的一个子级 镜头会随着子级的本地坐标变化而变化 
		 * @param child
		 * @return 
		 * 
		 */		
		public function lockTo(child:DisplayObject,lockX:Boolean=true,lockY:Boolean=true)
		{
			

			this.lockX=lockX;
			this.lockY=lockY;
				
				
			this.lockChild=child;
				
			this.lockStartX=lockChild.x;
			this.lockStartY=lockChild.y;
			
			
		}
		
		
		
		/**
		 *在两个对象之间切换镜头 从obj1移动到obj2(即镜头移动两个对象的坐标差值)
		 * @param obj1
		 * @param obj2
		 * @param delay
		 * @return 
		 * 
		 */		
		public function moveBetween(obj1:DisplayObject,obj2:DisplayObject,lastTime:int,moveFun:Function=null)
		{
			if(moveFun==null)
			{
				moveFun=Circular.easeOut;
			}
			
			//算出坐标差
			var xDistance:Number=obj2.x-obj1.x;
			var yDistance:Number=obj2.y-obj1.y;
			
		
			
			TweenManager.getInstance().playTween(this,"renderX",moveFun,xDistance,lastTime);
			TweenManager.getInstance().playTween(this,"renderY",moveFun,yDistance,lastTime);
			
		}
		
		/**
		 *把一个物体移动到镜头中央 
		 * @param obj 必须是当前摄像机显示对象的子级(可以不是直接子级)，否则会出现奇怪的问题
		 * @param lastTime
		 * @param moveFun
		 * @return 
		 * 
		 */		
		public function moveToCenter(obj:DisplayObject,lastTime:int,moveFun:Function=null)
		{
			if(moveFun==null)
			{
				moveFun=Circular.easeOut;
			}
			
			var objRect:Rect=Rect.RectangleToRect(obj.getRect(showObj));
			//计算出要把物体放到中央的目标区域
			var targetRect:Rect=showObjRect.moveToSameCenter(objRect);
			
			//算出坐标差
			var xDistance:Number=targetRect.x-renderX;
			var yDistance:Number=targetRect.y-renderY;
			
			
			
			TweenManager.getInstance().playTween(this,"renderX",moveFun,xDistance,lastTime);
			TweenManager.getInstance().playTween(this,"renderY",moveFun,yDistance,lastTime);
			
			
		}
		
	}
}