package XGameEngine.BaseObject.BaseComponent
{
	import XGameEngine.Advanced.Camera.Camera;
	import XGameEngine.BaseObject.BaseDisplayObject;
	import XGameEngine.GameObject.AutoDestroyObject;
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.GameObjectComponent.Anime.MovieClipAnimeGroup;
	import XGameEngine.Manager.ResourceManager;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Math.Vector2;
	import XGameEngine.Util.GameUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * 对象管理器 管理对象关系
	 * @author o
	 */
	public class GameObjectComponent extends BaseComponent 
	{
		private var host:BaseDisplayObject;
		public function GameObjectComponent(o:BaseDisplayObject)
		{
			host=o;
		}
		
		
		
		/**
		 * 加入对象,设置最低深度
		 * @param	o
		 */
		public function addChildToLowestDepth(o:DisplayObject)
		{
			//0就是最低索引 如果该索引处已经有对象 则所有对象会自动向上调整
			//确实比AS2好用的多
			host.addChildAt(o, 0);
		}
		
		
		/**
		 * 加入对象,设置最高深度
		 * @param	o
		 */
		public function addChildToHighestDepth(o:DisplayObject)
		{
			
			host.addChild(o);
		}
		
		
		
		/**
		 * 加入对象,设置为次高深度(如果只有该物体 则设置为最高深度)
		 * @param	o
		 */
		public function addChildToBeforeHighestDepth(o:DisplayObject)
		{
			if (host.numChildren == 0)
			{
				host.addChild(o);
			}
			else
			{
				host.addChildAt(o, host.numChildren - 1);
			}
			
		}
		
		
		
		/**
		 * 查找指定对象是否在子级中(不进行递归)
		 * @param	o
		 * @return
		 */
			public function hasChild(o:DisplayObject):Boolean 
			{
				for (var i:Number = 0; i < host.numChildren; i++ )
				{
					if (host.getChildAt(i) == o)
					{
						return true;
					}
				}
				
				return false;
			}
			
			
			/**
			 *移除所有子级 
			 * 
			 */			
			public function removeAllChilds():void 
			{
				while (host.numChildren > 0)
				{
					host.removeChildAt(0);
				}
			}
			
			/**
			 *递归销毁所有子级 
			 * 
			 */			
			public function destroyAllChilds():void 
			{
				_destroy(host);
			}
			
			private function _destroy(sprite:Sprite):void
			{
				//将所有子级DisplayObject加入
				var list:List=new List();
				for(var i:int=0;i<sprite.numChildren;i++)
				{
					var o:DisplayObject=sprite.getChildAt(i);
					//有时候会出现o==null?????现在还不清楚怎么回事 只能随便补救一下
				
					if(o!=null)
					{
						list.add(o);
					}
					
				}
				
				for each(var object:DisplayObject in list.Raw)
				{
					//如果是BaseGameObject直接destroy
					if(object is BaseDisplayObject)
					{
						(object as BaseDisplayObject).destroy();
					}
						//这里有一种情况是子级是普通object 但是子级的子级包括BaseGameObject
						//所以不能简单的略过普通object
						//如果普通的子级还包括子级的话
					else if(object is Sprite)
					{
						//递归检测
						_destroy(object as Sprite);
					}
					
				}

			}		
			
			
			
			public function removeSelf():void 
			{
				host.parent.removeChild(host);
			}
			
			/**
			 * 根据全局坐标点添加(添加到本坐标系的视觉相同位置 而不是相同坐标)
			 * @param o
			 * @param point
			 * 
			 */			
			public function addByGlobalPoint(o:DisplayObject, point:Point):void 
			{
				var point2:Point = host.globalToLocal(point);
				o.x = point2.x;
				o.y = point2.y;
				addChildToHighestDepth(o);
			}
			
			
			
			/**
			 *根据另外一个对象的本地坐标点添加(添加到本坐标系的视觉相同位置 而不是相同坐标)
			 * @param o 需要添加的对象
			 * @param other 另一个对象
			 * @param point 坐标点
			 * 
			 */			
			public function addByOtherLocalPoint(o:DisplayObject, other:BaseGameObject,point:Point=null):void 
			{
				
				if(point==null)
				{
					point=Vector2.VEC2_ZERO.toPoint();
				}
				
				point=other.localToGlobal(point);
				
				addByGlobalPoint(o,point);
				
			}
			
			
			
			/**
			 * 根据名字加载
			 * @param	string
			 */
			public function loadDisplayObjectByName(name:String,highest:Boolean=true):DisplayObject 
			{
				var o:DisplayObject = ResourceManager.getInstance().LoadDisPlayObjectByName(name);
				if (highest)
				{
					host.addChild(o);	
				}
				else
				{
					host.getGameObjectComponent().addChildToBeforeHighestDepth(o);
				}
				
				
				return o;
			}
			
			/**
			 * 加载到父级同位置处
			 * @param	o
			 */
			public function addToParentSamePosition(o:DisplayObject)
			{
				host.parent.addChild(o);
				
				o.x = host.x;
				o.y = host.y;
				
				
			}
			
//			public  function quickLoadEffectParent(name:String):void
//			{
//				var effect:AutoDestroyObject = new AutoDestroyObject(host.getResourceManager().LoadAnimationByName(name));
//				addToParentSamePosition(effect);
//				
//			}
			
			

			
			/**
			 *查找子级 不存在则报错 
			 * @param name
			 * @return 
			 * 
			 */			
			public function searchChildByName(name:String,cls:Class=null):*
			{
				var o:DisplayObject=host.getChildByName(name);
				
				if(o==null)
				{
					throw new Error(name+"子级不存在");
				}
				
				
				
				return o;
			}
			
			
			/**
			 *返回所有子级 
			 * @return 
			 * 
			 */			
			public function getAllChilds():List
			{
				var list:List=new List();
				for( var i:int=0;i<host.numChildren;i++)
				{
					list.add(host.getChildAt(i));
				}
				
				
				return list;
			}
	}
	
}