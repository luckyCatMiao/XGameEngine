package XGameEngine.GameObject.Component.Collider.Collider
{
	import XGameEngine.UI.Draw.Color;
	import flash.display.Shape;
	import flash.display.Sprite;
	import XGameEngine.GameEngine;
	import XGameEngine.Structure.List;
	
	/**
	 * ...
	 * 不规则碰撞器 使用与地图等不规则形状 一般在编辑器中创建形状 但是也可以调用函数添加多个形状组合
	 */
	public class MeshCollider extends Collider
	{
		
		private var c:Sprite; 
		
		/**
		 * 可以使用编辑器中创建的不规则形状初始化该碰撞器
		 * @param	a
		 */
		public function MeshCollider(a:Sprite=null)
		{
			if (a != null)
			{
				//使用传入的sprite初始化
				//a必须只有一个子级而且必须是shape
				getCommonlyComponent().throwWhileNotTrue(a.numChildren == 1 && (a.getChildAt(0) is Shape), "mesh collider init error");
				
				c = a;
				addChild(a);
			
				
			}
			
			else 
			{
				//使用默认sprite初始化
				c = new Sprite();
				addChild(c);
			}
			
			
		}
		
		
		/**
		 * 这里不返回点 该碰撞器只作为被测试对象在碰撞管理器中被调用 不过这样做的后果是两个多边形碰撞器无法互相检测到
		 * 即该碰撞器只能检测和方形碰撞器的碰撞
		 * 不过两个多边形碰撞需要检测的时候我还没遇到过 真遇到了再添加一个特殊的算法吧
		 * @return
		 */
		override public function getCheckPoint():List
		{
			var list:List = new List();
			
			
			return list;
		}
	
	
		override public function debugShape() 
		{
			//这里通过调整c的透明度实现debug切换
			
			//如果需要debug 
			if (GameEngine.getInstance().debug&&debug==true)
			{
					c.alpha=0.5;
			}
				//不需要debug
			else if (GameEngine.getInstance().debug==false||debug==false)
			{
					c.alpha=0;
			}
		}
		
		/**
		 * 添加一块 方形的碰撞区域
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	object
		 */
		public function AddRectArea(x:Number, y:Number, width:Number, height:Number):void 
		{
			
			this.c.graphics.beginFill(Color.RED,1);
			this.c.graphics.drawRect(x, y, width, height);
			this.c.graphics.endFill();
		}
		
		
		
		
	}
	
}