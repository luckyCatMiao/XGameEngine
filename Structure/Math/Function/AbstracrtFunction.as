package XGameEngine.Structure.Math.Function
{
	import XGameEngine.BaseObject.BaseComponent.Render.LineStyle;
	import XGameEngine.BaseObject.BaseDisplayObject;
	import XGameEngine.Constant.Error.AbstractMethodError;
	import XGameEngine.Structure.Math.Number2;
	import XGameEngine.Structure.Math.Vector2;
	import XGameEngine.UI.Draw.Color;
	
	import flash.display.Shape;

	public class AbstracrtFunction
	{
		/**
		 *定义域 
		 */		
		public var DYRange:Number2;
		/**
		 *值域 (各个函数的计算值域方法不同)
		 */
		private var _ZRange:Number2;
		
		
		public function AbstracrtFunction(r:Number2=null)
		{
			if(r==null)
			{
				//定义域为负无穷到正无穷
				this.DYRange=new Number2(-Infinity,Infinity);
			}
			else
			{
				
				this.DYRange=r;
			}
			DYRange.checkBigger();
		}
		
		
		/**
		 *值域 (各个函数的计算值域方法不同)
		 */
		public function get ZRange():Number2
		{
			throw new AbstractMethodError();
		}

		/**
		 *根据x值返回y值 
		 * @param x
		 * @return 
		 * 
		 */		
		public function getY(x:Number):Number
		{
			throw new AbstractMethodError();
		}
		
		
		/**
		 *根据y值返回x值 
		 * @param y
		 * @return 
		 * 
		 */		
		public function getX(y:Number):Number
		{
			throw new AbstractMethodError();
		}
		
		
		/**
		 *返回简洁的字符串表述 
		 * @return 
		 * 
		 */		
		public function get debugString():String
		{
			throw new AbstractMethodError();
		}
		
		/**
		 *返回图形表示
		 * @return 
		 * 
		 */		
		public function get debugShape():BaseDisplayObject
		{
			throw new AbstractMethodError();
		}
		
		
		/**
		 *检查是否在范围中(或者范围为null) 如果不在 则报错
		 * @param v
		 * @param range
		 * @return 
		 * 
		 */		
		protected function checkRange(v:Number,range:Number2):void
		{
			if(v<range.v1||v>range.v2)
			{
				throw new Error("输入的值不在范围中");
			}
			
		
		}
		
		/**
		 *画出坐标轴 
		 * @param o
		 * 
		 */		
		protected function drawAxis(o:BaseDisplayObject):void
		{
			var l:LineStyle=new LineStyle();
			l.color=Color.BLUE;
			o.getRenderComponent().drawLine(new Vector2(-1000,0),new Vector2(1000,0),l);
			o.getRenderComponent().drawLine(new Vector2(0,-1000),new Vector2(0,1000),l);
		
			
		}		
	}
}