package XGameEngine.UI.Composed
{
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.UI.Base.BaseUI;
	import XGameEngine.UI.Config.UIConfig;
	
	import flash.display.DisplayObject;

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
		 *直接设置为移动到多少距离 该距离是相对于起始点 
		 * @return 
		 * 
		 */		
		public function ScrollTo(value:Number)
		{
			throw new Error("未实现的方法");
		}
		
		
	
		
	}
}