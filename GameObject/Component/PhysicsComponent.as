package XGameEngine.GameObject.Component
{
	import XGameEngine.GameObject.*;
	import XGameEngine.Structure.*;
	import XGameEngine.Structure.Math.*;
	/**
	 * ...
	 * @author o
	 */
	public class PhysicsComponent extends BaseComponent 
	{
		
		private var xSpeed:Number=0;
		private var ySpeed:Number = 0;
		
		private var xSpeed2:Number=0;
		private var ySpeed2:Number=0;
		
		
		private var xASpeed:Number=0;
		private var yASpeed:Number=0;
		
		private var forces:List = new List();
		private var speeds:List = new List();
		
		public function PhysicsComponent(o:BaseGameObject)
		{
			super(o);
		}
		
		public function AddSpeed(name:String,v:Vector2)
		{
			var bean:NVBean = new NVBean();
			bean.name = name;
			bean.v2 = v;
			speeds.add(bean);
		}
		public function AddForce(name:String,v:Vector2)
		{
			var bean:NVBean = new NVBean();
			bean.name = name;
			bean.v2 = v;
			forces.add(bean);
		}
		
		public function Reset(v:Vector2)
		{
			ResetForce();
			ResetSpeed();
		}
		
		public function ResetForce()
		{
			forces.clear();
		}
		public function ResetSpeed()
		{
			speeds.clear();
		}
		
		public function calulate()
		{
			xASpeed = 0;
			yASpeed = 0;
			for each(var n:NVBean in forces.Raw)
			{
				xASpeed += n.v2.x;
				yASpeed += n.v2.y;
			}
			
			xSpeed2 = 0;
			ySpeed2 = 0;
			for each(var q:NVBean in speeds.Raw)
			{
				xSpeed2 += q.v2.x;
				ySpeed2 += q.v2.y;
			}
			
			xSpeed += xASpeed;
			ySpeed += yASpeed;
			
			//速度可能太大了 这里缩小一下 不然填的时候只能填小数了，有点麻烦
			host.x += (xSpeed+xSpeed2)/10;
			host.y -= (ySpeed+ySpeed2)/10;
			
		}
		
		public function stop()
		{
			enable = false;
		}
		
	}
	
}

class NVBean
{
	public var name:String;
	public var v2:XGameEngine.Structure.Math.Vector2;
	
	public function toString():String 
	{
		return "[NVBean name=" + name + " v2=" + v2 + "]";
	}
}