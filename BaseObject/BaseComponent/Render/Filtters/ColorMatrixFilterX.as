package XGameEngine.BaseObject.BaseComponent.Render.Filtters
{
	import XGameEngine.Constant.Error.ParamaterError;
	import XGameEngine.Collections.TwoDArray;
	import XGameEngine.UI.Draw.Color;
	
	import flash.filters.ColorMatrixFilter;

	public class ColorMatrixFilterX extends AbstractFiltter
	{

		/**
		 *创建一个普通的滤镜 
		 * @return 
		 * 
		 */		
		static public function createNormalFilter():ColorMatrixFilterX
		{
			var matrix:Array=[
				[1,0,0,0,0],
				[0,1,0,0,0],
				[0,0,1,0,0],
				[0,0,0,1,0]
			]
			var arr:TwoDArray=TwoDArray.createByTwoDArray(matrix);
			var f:ColorMatrixFilterX=new ColorMatrixFilterX(arr);
			
			return f;
		}
		
		/**
		 *创建一个灰度滤镜 
		 * @return 
		 * 
		 */		
		static public function createGrayFilter():ColorMatrixFilterX
		{
			var matrix:Array=[
				[0.3,0.59,0.11,0,0],
				[0.3,0.59,0.11,0,0],
				[0.3,0.59,0.11,0,0],
				[0,0,0,1,0]
			]
			var arr:TwoDArray=TwoDArray.createByTwoDArray(matrix);
			var f:ColorMatrixFilterX=new ColorMatrixFilterX(arr);
			
			return f;
		}
		
		
		/**
		 *创建一个染色滤镜 
		 * @param rgb
		 * @return 
		 * 
		 */		
		static public function createTintFilter(color:Color):ColorMatrixFilterX
		{
			
			
			var r:int=color.r;
			var g:int=color.g;
			var b:int=color.b;
			
			var matrix:Array=[
				[r/255,0.59,0.11,0,0],
				[g/255,0.59,0.11,0,0],
				[b/255,0.59,0.11,0,0],
				[0,0,0,1,0]
			]
			var arr:TwoDArray=TwoDArray.createByTwoDArray(matrix);
			var f:ColorMatrixFilterX=new ColorMatrixFilterX(arr);
			
			return f;
		}
		
		
		
		
		/**
		 * 
		 * @param arr 5*5的矩阵
		 * 
		 */		
		public function ColorMatrixFilterX(arr:TwoDArray)
		{
			if(arr.column!=5||arr.row!=4)
			{
				throw new ParamaterError();
			}
			
			
			
			this._fliter=new ColorMatrixFilter(arr.ToODArray());
			
	
		}
	}
}