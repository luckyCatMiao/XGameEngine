package XGameEngine.BaseObject.BaseComponent.Render
{
	import XGameEngine.BaseObject.BaseComponent.BaseComponent;
	import XGameEngine.BaseObject.BaseComponent.Render.Filtters.AbstractFiltter;
	import XGameEngine.BaseObject.BaseDisplayObject;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Math.Vector2;
	import XGameEngine.UI.Draw.Color;
	
	import flash.display.BlendMode;
	import flash.filters.BitmapFilter;

	/**
	 *图层混合 像素操控 绘图api等等 
	 * @author Administrator
	 * 
	 */	
	public class RenderComponent extends BaseComponent
	{
		
		/**
		 *正常的混合模式 
		 */		
		static public var BLEND_MODE_NORMAL:String=BlendMode.NORMAL;
		/**
		 *(bottom*top)/255  总体变暗
		 */		
		static public var BLEND_MODE_MULTIPLY:String=BlendMode.MULTIPLY;
		/**
		 * (255-((255-top)*(255-bottom))/255) 总体变亮
		 */		
		static public var BLEND_MODE_SCREEN:String=BlendMode.SCREEN;
		/**
		 * 大于127使用screen 小于127使用multiply(但使用原图像的像素来确定 因此与底层没有关系) 增强对比度
		 */		
		static public var BLEND_MODE_HARDLIGHT:String=BlendMode.HARDLIGHT;
		/**
		 * 和HARDLIGHT相同 但使用底层像素 增强对比度
		 */		
		static public var BLEND_MODE_OVERLAY:String=BlendMode.OVERLAY;
		/**
		 * bottom+top
		 */		
		static public var BLEND_MODE_ADD:String=BlendMode.ADD;
		/**
		 * bottom-top
		 */		
		static public var BLEND_MODE_SUBTRACT:String=BlendMode.SUBTRACT;
		/**
		 * Math.max(bottom,top)
		 */		
		static public var BLEND_MODE_LIGHTEN:String=BlendMode.LIGHTEN;
		/**
		 * Math.min(bottom,top)
		 */		
		static public var BLEND_MODE_DARKEN:String=BlendMode.DARKEN;
		/**
		 * Math.abs(bottom-top)
		 */		
		static public var BLEND_MODE_DIFFERENCE:String=BlendMode.DIFFERENCE;
		/**
		 * top=255-bottom
		 */		
		static public var BLEND_MODE_INVERT:String=BlendMode.INVERT;
		
		
		
		private var host:BaseDisplayObject;
		
		private var filters:List=new List();
		public function RenderComponent(o:BaseDisplayObject)
		{
			host=o;
		}
		
		
		/**
		 *设置混合模式 
		 * @param type
		 * @return 
		 * 
		 */		
		public function setBlendMode(type:String)
		{
			
			host.blendMode=type;
		}
		
		/**
		 *添加一个滤镜 滤镜组会自动更新 
		 * @param filter
		 * @return 
		 * 
		 */		
		public function addFilter(filter:AbstractFiltter)
		{
			filter.host=this;
			filters.add(filter);
			parseFilter();
		}
		
		
		/**
		 *删除一个滤镜  滤镜组会自动更新 
		 * @param filter
		 * @return 
		 * 
		 */		
		public function removeFilter(filter:AbstractFiltter)
		{
			
			filters.remove(filter);
			parseFilter();
		}
		
		
		/**
		 *清除所有滤镜 
		 * @return 
		 * 
		 */		
		public function clearFilter()
		{
			filters.clear();
			parseFilter();
			
		}
		
		
		/**
		 *更新滤镜组 当更新某个滤镜的某个属性值时 渲染并不会立即更新
		 * 而需要调用该方法重新应用滤镜组，猜测内部这样做的目的是因为效率(只有在需要的时候才重新更新) 
		 * @return 
		 * 
		 */		
		public function parseFilter()
		{
			host.filters=getFiltterArray();
			
		}
		
		private function getFiltterArray():Array
		{
			var arr:Array=new Array();
			for each(var f:AbstractFiltter in filters.Raw)
			{
				
				arr.push(f.fliter);
			}
			
		
			return arr;
		}	
		
		
		
		/**
		 *画线 
		 * @param startPoint
		 * @param endPoint
		 * @param lineStyle
		 * @return 
		 * 
		 */		
		public function drawLine(startPoint:Vector2,endPoint:Vector2,lineStyle:LineStyle=null)
		{
			if(lineStyle==null)
			{
				lineStyle=new LineStyle();
			}
			host.graphics.lineStyle(lineStyle.thick,lineStyle.color,lineStyle.alpha);
			host.graphics.moveTo(startPoint.x,startPoint.y);
			host.graphics.lineTo(endPoint.x,endPoint.y);		
		}
		
		/**
		 *画圆 
		 * @param x
		 * @param y
		 * @param radius
		 * @param color
		 * @return 
		 * 
		 */		
		public function drawCircle(x:Number,y:Number,radius:Number=1,color:uint=0xffff0000)
		{
			host.graphics.beginFill(color,1);
			host.graphics.drawCircle(x,y,radius)
			host.graphics.endFill();
		}
		
		
		/**
		 *画正方形 
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param color
		 * @return 
		 * 
		 */		
		public function drawRect(x:Number,y:Number,width:Number,height:Number,color:uint)
		{
			host.graphics.beginFill(color,1);
			host.graphics.drawRect(x,y,width,height)
			host.graphics.endFill();
		}
		
		
	}
}