package XGameEngine.Util
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Shader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class LoadTool
	{
		
		
		
		/**
		 *加载一个文本文件 
		 * @param path 路径
		 * @param fun 回调方法
		 * 
		 */		
		static public function loadText(path:String,fun:Function):void
		{
		
			var loader:URLLoader=new URLLoader();
			
			var callBack:Function=function(e:Event):void {
				
				fun(e.target.data as String);
			}
			loader.addEventListener(Event.COMPLETE,callBack);
		
			loader.load(new URLRequest(path));
			

		}
	
	
		/**
		 * 
		 * @param path
		 * @param fun
		 * 
		 */		
		static public function loadByteArray(path:String,fun:Function):void
		{
			var loader:URLLoader=new URLLoader();
			loader.dataFormat=URLLoaderDataFormat.BINARY;
			
			
			var callBack:Function=function(e:Event):void {
				
				fun(e.target.data as ByteArray);
			}
			loader.addEventListener(Event.COMPLETE,callBack);
			
			loader.load(new URLRequest(path));
		}
		
		/**
		 * 
		 * @param path
		 * @param fun
		 * 
		 */		
		static public function loadShader(path:String,fun:Function):void
		{
			var callBack:Function=function(b:ByteArray):void {
				
				fun(new Shader(b));
			}
				
			loadByteArray(path,callBack);
		}
		
	}
}