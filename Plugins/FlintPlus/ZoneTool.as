package XGameEngine.Plugins.FlintPlus
{
	import XGameEngine.GameObject.BaseDisplayObject;
	import XGameEngine.GameEngine;
	
	import flash.display.Shape;
	import flash.geom.Point;
	
	import org.flintparticles.twoD.zones.Zone2D;

	public class ZoneTool
	{
		public function ZoneTool()
		{
		}
		
		/**
		 *大致debug出一个zone的范围 
		 * @param z
		 * 
		 */		
		public static function debugZone(z:Zone2D):void
		{
			var s:BaseDisplayObject=new BaseDisplayObject();
			for(var i:int=0;i<250;i++)
			{
				var p:Point=z.getLocation();
			
				s.getRenderComponent().drawCircle(p.x,p.y,2);

			}
			
			GameEngine.getInstance().debugPlane.addChild(s);
		}
	}
}