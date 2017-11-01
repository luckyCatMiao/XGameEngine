package XGameEngine.Manager.Movie.Command
{
	import Script.GameObject.NPC.BaseNpc;
	
	import XGameEngine.Manager.Movie.BaseMovie;
	import XGameEngine.GameObject.BaseDisplayObject;
	import XGameEngine.Math.Vector2;
	
	import flash.display.DisplayObject;

	/**
	 *移动指令 
	 * @author Administrator
	 * 
	 */	
	public class Move extends BaseCommond
	{
		protected var targetX:Number;
		protected var targetY:Number;
		protected var speed:Number;
		protected var x:Number;
		protected var y:Number;
		public function Move(m:BaseMovie,actor:BaseDisplayObject,x:Number,y:Number,speed:Number=5)
		{
			
			super(m,actor);
			
			this.x=x;
			this.y=y;
			this.speed=speed;
		}
		
		override public function update():void
		{
			if(actor.x<targetX)
			{
				actor.x+=speed;
			}
			if(actor.x>targetX)
			{
				actor.x-=speed;
			}
			if(actor.y<targetY)
			{
				actor.y+=speed;
			}
			if(actor.y>targetY)
			{
				actor.y-=speed;
			}
			
		
			checkDistance();
			
			
		}
		
		private function checkDistance():void
		{
			var p:Vector2=actor.localPosition;
			var p2:Vector2=new Vector2(targetX,targetY);
			if(p.getDistance(p2)<speed+1)
			{
				nextCommond();
			}
			
		}
		
		override public function enter():void
		{
			this.targetX=actor.x+x;
			this.targetY=actor.y+y;
			
		}
		
		override public function exit():void
		{
			
		}
		
		
	}
}