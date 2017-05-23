package XGameEngine.Manager.Hit
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.Structure.List;
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author o
	 */
	public class Collision 
	{
		
	//注意这里的碰撞点数据全都是相对于o1的坐标系中!
	/**
	 * 发起检测碰撞的物体本身
	 */
	public var self:BaseGameObject;
	public var hitObject:BaseGameObject;
	public var state:String;
	/**
	 * 第一个检测到的碰撞点
	 */
	public var hitPoint:Point;
	
	/**
	 * 所有的碰撞点
	 */
	public var allhitPoint:List;
	/**
	 *碰撞点是属于自身还是另外一个对象 
	 */	
	public var hitPointsSelf:Boolean;
	
	public function containPoint(p:Point):Boolean 
	{
		//因为as3的Object没有eaqul方法..所以不能用多态来写 只能是这边检测了
		
			for each(var q:Point in allhitPoint.Raw)
			{
				if (self.localToGlobal(q).equals(self.localToGlobal(p)))
				{
					return true;
				}
			}
			
			return false;
		
		
	}
	
	
	}
	
}