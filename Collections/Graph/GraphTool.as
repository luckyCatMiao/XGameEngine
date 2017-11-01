package XGameEngine.Collections.Graph
{
	import XGameEngine.GameObject.BaseComponent.Render.LineStyle;
	import XGameEngine.GameObject.BaseDisplayObject;
	import XGameEngine.GameEngine;
	import XGameEngine.Manager.Hit.HitManager;
	import XGameEngine.Collections.Graph.SpecialGraph.NavigationGraph.FloodToNavitionGraph;
	import XGameEngine.Collections.Graph.SpecialGraph.NavigationGraph.NavigationGraph;
	import XGameEngine.Collections.Graph.SpecialGraph.NavigationGraph.PositionValue;
	import XGameEngine.Collections.List;
	import XGameEngine.Math.Line;
	import XGameEngine.Math.Vector2;
	import XGameEngine.Collections.TwoDArray;
	import XGameEngine.UI.Draw.Color;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class GraphTool
	{
		static public var Floodtype_:String
		
		
		/**
		 *使用洪水算法为一个DisplayObject生成图
		 * @param map 需要进行生成的对象
		 * @param cantPass 不能通过的区域
		 * @param pointDensity 点密度 隔几个像素一个路点
		 * @param eightDirection 是否连接斜方向
		 * @param debug 是否需要debug
		 * @return 
		 * 
		 */		
		public static function floodDisplayObject(map:Sprite,cantPass:DisplayObject=null,pointDensity:Number=50,eightDirection:Boolean=false,progressListener:Function=null,achieveListener:Function=null)
		{
			
			new FloodToNavitionGraph(map,cantPass,pointDensity,eightDirection,progressListener,achieveListener).start();
		
		}
		
		
	}
}