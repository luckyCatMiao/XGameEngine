package XGameEngine.Collections.Graph.SpecialGraph.NavigationGraph
{
	import XGameEngine.BaseObject.BaseComponent.Render.LineStyle;
	import XGameEngine.BaseObject.BaseDisplayObject;
	import XGameEngine.Collections.List;
	import XGameEngine.Math.Vector2;
	import XGameEngine.UI.Draw.Color;
	
	import flash.events.Event;
	import XGameEngine.Collections.Graph.Graph;
	import XGameEngine.Collections.Graph.GraphNode;

	/**
	 *debug出图 可以慢慢画出来 
	 * @author Administrator
	 * 
	 */	
	public class NavitionGraphDebug
	{
		private var graph:Graph;
		private var debugPlane:BaseDisplayObject;
		private var speed:int;
		private var list:List;
		
		/**
		 * 
		 * @param graph
		 * @param debugPlane
		 * @param speed 每秒画几个点
		 * 
		 */		
		public function NavitionGraphDebug(graph:Graph,debugPlane:BaseDisplayObject,speed:int)
		{
			this.graph=graph;
			this.debugPlane=debugPlane;
			this.speed=speed;
			//所有待画的点
			this.list=new List();
			list.addAll(graph.raw);
			
		}
		
		/**
		 *开始debug 
		 * 
		 */		
		public function start():void
		{
			
			debugPlane.addEventListener(Event.ENTER_FRAME,loop);
			
			
		}
		
		protected function loop(event:Event):void
		{
			//每次只画几个点
			for(var i:int=0;i<speed;i++)
			{
				if(list.size==0)
				{
					debugPlane.removeEventListener(Event.ENTER_FRAME,loop);
					
				}
				else
				{
					var gnode:GraphNode=list.get(0) as GraphNode;
					list.remove(gnode);
				
					
					var value:PositionValue=gnode.value as PositionValue;
					var v:Vector2=value.realPostion;
					
					debugPlane.getRenderComponent().drawCircle(v.x,v.y,4,Color.BLACK);
					for each(var linkNode:GraphNode in gnode.linkedNodes.Raw)
					{
						var linkNodePosiont:Vector2=(linkNode.value as PositionValue).realPostion
						debugPlane.getRenderComponent().drawLine(v,linkNodePosiont,new LineStyle());
					}
				}
				
			}
			
		
			
		}
	}
}