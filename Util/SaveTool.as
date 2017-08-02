package XGameEngine.Util
{
	import fl.transitions.Fade;
	
	import flash.net.SharedObject;

	public class SaveTool
	{
		
		/**
		 * 存储数据  貌似只能存原始数据类型
		 * @param key 键
		 * @param value 值
		 * @param ArchiveName 存档名
		 * @return 
		 * 
		 */		
		static public function saveValue(key:Object,value:Object,ArchiveName="default"):void
		{
			var archive:SharedObject = SharedObject.getLocal(ArchiveName);
			archive.data[key] = value
			archive.flush();
		}
		
		
		/**
		*读取数据 
		 * @param key 键
		 * @param emptyValue 如果为null时的默认值
		 * @param ArchiveName 存档名
		 * @return 
		 * 
		 */			
		static public  function getValue(key:Object,defaultValue:Object=null,ArchiveName="default"):Object
		{
			
			var archive:SharedObject = SharedObject.getLocal(ArchiveName);
			if (archive.data[key] == null) {
				
				return defaultValue;
			}
			else
			{
				
				return archive.data[key];
			}
			
			
			
			
		}
		
		
		
		/**
		 *测试指定名字的存档是否存在 
		 * @param ArchiveName
		 * @return 
		 * 
		 */		
		static public  function hasArchive(ArchiveName="default"):Boolean
		{
			var archive:SharedObject = SharedObject.getLocal(ArchiveName);
			if(archive.size==0)
			{
				return false;
			}
			else
			{
				return true;
			}
			
		}
		
		
		/**
		 *清空指定名字的存档
		 * @param ArchiveName
		 * @return 
		 * 
		 */		
		static public  function clearArchive(ArchiveName="default")
		{
			var archive:SharedObject = SharedObject.getLocal(ArchiveName);
			archive.clear();
			archive.flush();
			
		}
		
	}
}