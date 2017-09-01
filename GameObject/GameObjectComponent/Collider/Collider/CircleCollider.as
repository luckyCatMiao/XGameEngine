package XGameEngine.GameObject.GameObjectComponent.Collider.Collider
{
	import XGameEngine.Structure.List;
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * 点碰撞器 只返回一个点 适用于飞行物等只需要知道是否碰撞而不需要知道碰撞点的物体
	 * 大量出现的物体使用该碰撞器可以节省碰撞资源 
	 */
	public class CircleCollider extends Collider 
	{
		private var radius:Number;
		private var color:uint;
		
		
		public function CircleCollider(radius:Number,color:uint)
		{
			this.radius=radius;
			this.color=color;
			
			
			
			this.shape.graphics.beginFill(color,0.4);
			this.shape.graphics.drawCircle(0, 0, radius);
			this.shape.graphics.endFill();
		
			this.shape.getRenderComponent().drawCircle(0,0,4);
			
			
		}
		
		
		
		
		override public function getCheckPoint():List
		{
			
			var list:List=new List();
			list.add(new Point((x+width)/2,(y+height)/2));
			//返回中心点
			return list;
		}
		
		
		
	}
	
}