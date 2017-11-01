package XGameEngine.UI.Composed
{
	import XGameEngine.Math.Rect;
	import XGameEngine.UI.Base.BaseUI;
	import XGameEngine.UI.Config.UIConfig;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 *滚动面板  注意这里的滚动只能调用方法来进行 如果需要使用可视组件来进行滚动 需要再次进行组件复合
	 * @author Administrator
	 * 
	 */	
	public class ScorllPlane extends BaseUI
	{
		
		/**
		 *遮罩对象 
		 */		
		private var element_scorllMask:DisplayObject;
		/**
		 *被遮罩的对象 
		 */		
		private var element_scorllObj:DisplayObject;
		
		/**
		 *横竖类型 
		 */		
		private var type:String;
		
		public function ScorllPlane()
		{
			
			this.element_scorllObj=searchChild("scorllObj");
			this.element_scorllMask=searchChild("scorllMask");
			
			
			initMask();
			checkType();
			
			
		}
		
		private function checkType():void
		{
			if(element_scorllObj.width>element_scorllObj.height)
			{
				type=UIConfig.ORIENTATION_HORIZONTAL;
			}
			else
			{
				type=UIConfig.ORIENTATION_VERTICAL;
			}
			
		}
		
		private function initMask():void
		{
			//将Obj对齐到遮罩的位置
			var scorllObjRect:Rect=Rect.RectangleToRect(this.element_scorllObj.getRect(this));
			var scorllMaskRect:Rect=Rect.RectangleToRect(this.element_scorllMask.getRect(this));
			
			
			element_scorllObj.x+=(scorllMaskRect.getLeftX()-scorllObjRect.getLeftX());
			element_scorllObj.y+=(scorllMaskRect.getTopY()-scorllObjRect.getTopY());
			
			
			element_scorllObj.mask=element_scorllMask;
			
			
		}
		
		/**
		 *添加物体到滚动面板里 
		 * @param o
		 * 
		 */		
		public function addToPlane(o:DisplayObject):void
		{
			(this.element_scorllObj as DisplayObjectContainer).addChild(o);
		}
		
		
		
		/**
		 *进行滚动 
		 * @return 
		 * 
		 */		
		public function scroll(value:Number)
		{
			if(canScroll(value))
			{
				if(type==UIConfig.ORIENTATION_HORIZONTAL)
				{
					element_scorllObj.x+=value;
					
				}
				else if(type==UIConfig.ORIENTATION_VERTICAL)
				{
					element_scorllObj.y+=value;	
				}	
			}
			
		}
		
		
		/**
		 *检查滚动后是否越界  只有当mask为长方形时才精确
		 * @return 
		 * 
		 */		
		private function canScroll(value:Number):Boolean
		{
			
			var maskRect:Rect=Rect.RectangleToRect(element_scorllMask.getRect(this));
			var rect:Rect = Rect.RectangleToRect(element_scorllObj.getRect(this));
			
			if(type==UIConfig.ORIENTATION_HORIZONTAL)
			{
				
				rect.move(0	,value);
				//检查移动后的rect是否越界
				if (rect.getLeftX()<=maskRect.getLeftX()&&rect.getRightX()>=maskRect.getRightX())
				{
					return true;
				}
				else
				{
					return false;
				}
				
			}
			else if(type==UIConfig.ORIENTATION_VERTICAL)
			{
				rect.move(value	,0);
				//检查移动后的rect是否越界
				if (rect.getTopY()<=maskRect.getTopY()&&rect.getBottomY()>=maskRect.getBottomY())
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return true;
			}
			

		}
		
		
		
		/**
		 *直接设置为移动到多少百分比(0-100)
		 * @return 
		 * 
		 */		
		public function ScrollPercent(percent:Number)
		{
			//算出两个极限距离之间的差值
			var distance:Number=0;
			
			var maskRect:Rect=Rect.RectangleToRect(element_scorllMask.getRect(this));
			var objRect:Rect=Rect.RectangleToRect(element_scorllObj.getRect(this));
			
			//设置距离为该差值的百分比
			if(type==UIConfig.ORIENTATION_HORIZONTAL)
			{
				distance=objRect.width-maskRect.width;
				
			}
			else if(type==UIConfig.ORIENTATION_VERTICAL)
			{
				
				
				distance=objRect.height-maskRect.height;
			}	
			
			
			scrollTo(distance*percent/100);
	
		}
		
		
		
		
		/**
		 *直接设置移动到多少位置(scroll是增量滚动 这个是一次性设置) 
		 * (大于0的一个值)
		 * @param value
		 * @return 
		 * 
		 */		
		public function scrollTo(value:Number)
		{
			
			
			var maskRect:Rect=Rect.RectangleToRect(element_scorllMask.getRect(this));
			var objRect:Rect=Rect.RectangleToRect(element_scorllObj.getRect(this));
			if(type==UIConfig.ORIENTATION_HORIZONTAL)
			{
				element_scorllObj.x+=(maskRect.getLeftX()-value)-objRect.getLeftX();
				
			}
			else if(type==UIConfig.ORIENTATION_VERTICAL)
			{
				//这里确实是+= 虽然是直接设置位置  但是这边相当于增加 目标位置和当前的位置的差值
				//即相当于设置到目标位置 
				//不直接使用=的原因是因为各个对象的对齐点不同
				//所以该框架支持子对象位置随意摆放 而不用像之前那个一样每个自对象也需要左上角对齐
				element_scorllObj.y+=(maskRect.getTopY()-value)-objRect.getTopY();
			}	
			
			
		}
		
	
		
	}
}