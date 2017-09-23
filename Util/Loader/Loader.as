package XGameEngine.Util.Loader
{
	import XGameEngine.Manager.ResourceManager;
	import XGameEngine.Structure.List;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 *  a loader can load image and text,it's can a sequence of task
	 * @author Administrator
	 * 
	 */
	public class Loader
	{
		/**
		 *is this task has started? 
		 */		
		private var isStart:Boolean=false;
		/**
		 *the list contain raw task 
		 */		
		private var list:List=new List();
		/**
		 *achieve callback 
		 */		
		private var achieveListener:Function;
		/**
		 *progress callback 
		 */		
		private var progressListener:Function;
		/**
		 *unachieve task 
		 */		
		private var unAchieveTask:int=0;
		
		public function Loader()
		{
		}
		
		/**
		 * add a text task
		 * @param path
		 * @param name
		 * @return 
		 * 
		 */		
		public function addTextTask(path:String,name:String=null):Loader
		{
			var task:Task=new Task();
			task.path=path;
			task.name=name;
			task.type="text";
			
			list.add(task);
			unAchieveTask++;
			
			return this;
		}
		
		
		/**
		 * add a image task
		 * @param path
		 * @param name
		 * @return 
		 * 
		 */		
		public function addImageTask(path:String,name:String=null):Loader
		{
			var task:Task=new Task();
			task.path=path;
			task.name=name;
			task.type="image";
			
			list.add(task);
			unAchieveTask++;
			
			return this;
			
		}
		
		/**
		 *start load 
		 * @param achieveListener
		 * @param progressListener
		 * 
		 */		
		public function start(achieveListener:Function,progressListener:Function=null):void
		{
			if(isStart)
			{
				throw new Error("one loader can only start once,when other resources need to be load,use a new loader")
			}
		
			
			this.achieveListener=achieveListener;
			this.progressListener=progressListener;
			
			isStart=true;
			for each (var t:Task in list.Raw) 
			{
				if(t.type=="image")
				{
					var loader:flash.display.Loader=new flash.display.Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE,taskAchieve);
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,taskProgress);
					loader.load(new URLRequest(t.path));	
					t.loader=loader;
					
				}
				else if(t.type=="text")
				{
					var loader2:URLLoader=new URLLoader();
					loader2.addEventListener(Event.COMPLETE,taskAchieve);
					loader2.addEventListener(ProgressEvent.PROGRESS,taskProgress);
					loader2.load(new URLRequest(t.path));
					t.loader=loader2;
				}
				
			}
			
			
		}
		
		protected function taskProgress(event:ProgressEvent):void
		{
			
			var allByteLoaded:int=0;
			var totalByte:int=0;
			
			for each (var t:Task in list.Raw) 
			{
				
				if(t.loader is flash.display.Loader)
				{	
					allByteLoaded+=(t.loader as flash.display.Loader).contentLoaderInfo.bytesLoaded;
					totalByte+=(t.loader as flash.display.Loader).contentLoaderInfo.bytesTotal;
				}
				else if(t.loader is URLLoader)
				{
					
					allByteLoaded+=(t.loader as URLLoader).bytesLoaded;
					totalByte+=(t.loader as URLLoader).bytesTotal;
				}
				
				
			}
			

			if(progressListener!=null)
			{
				if(totalByte!=0)
				{
					progressListener(allByteLoaded*100.0/totalByte);
				}
				else
				{
					progressListener(0);
				}
			}
		}
		
	
		/**
		 *one task achieve 
		 * @param event
		 * 
		 */		
		protected function taskAchieve(event:Event):void
		{
			unAchieveTask--;
			
			var manager:ResourceManager=ResourceManager.getInstance();
			//add to resourceManager cache
			for each (var t:Task in list.Raw) 
			{
				if(t.loader==event.target)
				{
					var name:String=t.name;
					var data:*;
					if(t.loader is flash.display.Loader)
					{
						//loader used to load image and swf
						//(but here wo only used to load image,because all swf resource are loaded in engine)
						data=(t.loader as flash.display.Loader).content;
						manager.addImageData(name,data);
						
					}
					else if(t.loader is URLLoader)
					{
						
						//urlLoader used to load text data
						data=(t.loader as URLLoader).data;
						manager.addTextData(name,data);
					}
						
					
				}
			}
			
			
			if(unAchieveTask==0)
			{
				if(achieveListener!=null)
				{
					achieveListener();
				}
			}
			
			
			
		}
	}
}


/**
 *a task 
 * @author Administrator
 * 
 */
class Task
{
	public var path:String;
	public var type:String;
	public var name:String;
	public var loader:*;
	
}