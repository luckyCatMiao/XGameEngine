package XGameEngine.Math.Function
{
	import XGameEngine.GameObject.BaseDisplayObject;
	import XGameEngine.Math.Line;
	import XGameEngine.Math.Number2;
	import XGameEngine.Math.Vector2;
	
	import flash.display.Shader;
	import flash.display.Shape;

	/**
	 *一次函数 
	 * @author Administrator
	 * 
	 */	
	public class LinearFunction extends AbstracrtFunction
	{
		
		/**
		 *斜率 
		 */		
		public var k:Number=0;
		/**
		 *偏移量 
		 */		
		public var b:Number=0;
		
		
		public function LinearFunction(k:Number,b:Number,r:Number2=null)
		{
			super(r);
			this.k=k;
			this.b=b;
		}
		
		override public function get debugString():String
		{
			
			return "y="+k+"x"+"+"+b;
		}
		
		override public function getX(y:Number):Number
		{
			
			
			var x:Number=(y-b)/k
			//计算结果是否在定义域中 
			checkRange(x,DYRange)
			
			
			return x;
		}
		
		
		
		override public function getY(x:Number):Number
		{
			
			//计算输入值是否在定义域中 
			checkRange(x,DYRange)
			
			return k*x+b;
		}
		
		override public function get ZRange():Number2
		{
			
			if(k>=0)
			{
				return new Number2(getY(DYRange.v1),getY(DYRange.v2));
			}
			else
			{
				return new Number2(getY(DYRange.v2),getY(DYRange.v1));
			}
			
			
		}
		
		
		override public function get debugShape():BaseDisplayObject
		{
			
			var o:BaseDisplayObject=new BaseDisplayObject();
			
			var start:Number;
			var end:Number;
			//如果定义域包含无穷大 则从-200画到+200
			if(Math.abs(DYRange.v1)==Infinity||Math.abs(DYRange.v2)==Infinity)
			{
				start=-200;
				end=200;
			}
			//如果不包含 则画出整个定义域
			else
			{
				start=DYRange.v1;
				end=DYRange.v2;
			}
			
			//画出坐标轴
			drawAxis(o);
			
			//画点
			for(var i:Number=start;i<end;i++)
			{
				
				o.getRenderComponent().drawCircle(i,getY(i));
				
			}
			
			
			return o;
		}
		
	
		
		
		

		/**
		 *通过线段来转化为一次函数 
		 * @param line
		 * @return 
		 * 
		 */		
		public static function createByLine(line:Line):LinearFunction
		{
			
			var leftPoint:Vector2
			var rightPoint:Vector2
			
			//线段可能是从右向左的 所以要判断一下
			if(line.end.x>line.start.x)
			{
				leftPoint=line.start;
				rightPoint=line.end;
			}
			else
			{
				leftPoint=line.end;
				rightPoint=line.start;
			}
			
			//计算定义域
			var dyy:Number2=new Number2(leftPoint.x,rightPoint.x);
		
			//计算斜率
			var k:Number=(rightPoint.y-leftPoint.y)/(rightPoint.x-leftPoint.x);
			
			//计算b(带入起点计算 b=y-kx)
			var b:Number=line.start.y-k*line.start.x;
			
			
			
			
			var f:LinearFunction=new LinearFunction(k,b,dyy);
		
			return f;
		}
		
		public function toString():String
		{
			// TODO Auto Generated method stub
			return debugString;
		}
		
		
		/**
		 *转化为对应朝向的标准化向量(只有180度的范围 因为函数旋转180度会重合)
		 * @return 
		 * 
		 */		
		public function toNormalizeVector2():Vector2
		{
	
			return Vector2.getRotationVector2(Math.atan(k)*180/Math.PI);
		}
	}
}