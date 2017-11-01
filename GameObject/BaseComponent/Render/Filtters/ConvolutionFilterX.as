package XGameEngine.GameObject.BaseComponent.Render.Filtters
{
import XGameEngine.BaseObject.BaseComponent.Render.Filtters.*;
	import XGameEngine.Collections.TwoDArray;
	
	import flash.filters.ConvolutionFilter;

	public class ConvolutionFilterX extends AbstractFiltter
	{
		
		
		
		
		/**
		 *创建一个锐化滤镜 
		 * @return 
		 * 
		 */		
		static public function createSharpenFilter():ConvolutionFilterX
		{
			var arr:Array=
				[
					[0,-1,0],
					[-1,5,-1],
					[0,-1,0]
				]
			var tArr:TwoDArray=TwoDArray.createByTwoDArray(arr);
			
			return new ConvolutionFilterX(tArr,1,0);
		}
		
		
		/**
		 *创建一个模糊滤镜 
		 * @return 
		 * 
		 */		
		static public function createObscureFilter():ConvolutionFilterX
		{
			var arr:Array=
				[
					[1,1,1],
					[1,1,1],
					[1,1,1]
				]
			var tArr:TwoDArray=TwoDArray.createByTwoDArray(arr);
			
			return new ConvolutionFilterX(tArr,9,0);
		}
		
		
		/**
		 *创建一个浮雕滤镜
		 * @return 
		 * 
		 */		
		static public function createSculptureFilter():ConvolutionFilterX
		{
			var arr:Array=
				[
					[-2,-1,0],
					[-1,0,1],
					[0,1,2]
				]
			var tArr:TwoDArray=TwoDArray.createByTwoDArray(arr);
			
			return new ConvolutionFilterX(tArr,1,0);
		}
		
		/**
		 * 
		 * @param arr
		 * @param divisor
		 * @param bias
		 * @param preserveAlpha
		 */		
		public function ConvolutionFilterX(arr:TwoDArray,divisor:Number=1.0, bias:Number=0.0, preserveAlpha:Boolean=true)
		{
			this._fliter=new ConvolutionFilter(arr.column,arr.row,arr.ToODArray(),divisor,bias,preserveAlpha,true,0,0)
		}
	}
}