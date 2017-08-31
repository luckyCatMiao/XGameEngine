package XGameEngine.Structure.Graph.SpecialGraph.NavigationGraph
{
	import XGameEngine.Manager.HitManager;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Math.Line;
	import XGameEngine.Structure.Math.Vector2;
	import XGameEngine.Structure.TwoDArray;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 *因为该算法是一个比较慢的过程 但是as3好像方法执行过久就会卡死..
	 * 不像java while(true)都还可以运行
	 * 所以这里只能是单开一个类 然后分步执行 
	 * @author Administrator
	 * 
	 */	
	public class FloodToNavitionGraph
	{
		private var map:Sprite;
		private var cantPass:DisplayObject;
		private var eightDirection:Boolean;
		private var pointDensity:Number;
		private var achieveListener:Function;
		private var progressListener:Function;
		private var xPointAmount:int;
		private var yPointAmount:int;
		private var arr:TwoDArray;
		private var graph:NavigationGraph;
		private var x:int=0;
		public function FloodToNavitionGraph(map:Sprite,cantPass:DisplayObject=null,pointDensity:Number=50,eightDirection:Boolean=false,progressListener:Function=null,achieveListener:Function=null)
		{
			this.map=map;
			this.cantPass=cantPass;
			this.pointDensity=pointDensity;
			this.eightDirection=eightDirection;
			this.progressListener=progressListener;
			this.achieveListener=achieveListener;
			
		}
		
		private static function _flood_checkLink(node1:PositionValue,node2:PositionValue,g:NavigationGraph,cantPass:DisplayObject):void
		{
			if(node1!=null&&node2!=null)
			{
				//检测连通性
				var line:Line=new Line(node1.realPostion,node2.realPostion);
				var list:List=new List();
				list.add(cantPass);
				var result:List=HitManager.getInstance().rayCast2(line,list,true);
				if(result.size==0)
				{
					g.linkPositionNode(node1,node2,false);
				}
				
			}
			
			
		}
		
		public function start():void
		{
		
			graph=new NavigationGraph();
			
			
			//计算横竖的点数
			xPointAmount=map.width/pointDensity+1;
			yPointAmount=map.height/pointDensity+1;
			
			//根据行列数生成二维数组
			arr=new TwoDArray(xPointAmount,yPointAmount);
			
			//点要摆在中间 所以要计算开始的xy坐标y
			var startX:Number=(map.width-(xPointAmount-1)*pointDensity)/2;
			var startY:Number=(map.height-(yPointAmount-1)*pointDensity)/2;
			
			var x:int;
			var y:int;
			//生成点
			for(x=0;x<xPointAmount;x++)
			{
				for(y=0;y<yPointAmount;y++)
				{
					var v:Vector2=new Vector2(startX+x*pointDensity,startY+y*pointDensity);
					
					//检测是否碰撞
					if(cantPass!=null&&!cantPass.hitTestPoint(v.x,v.y,true))
					{
						
						var node:PositionValue=new PositionValue(v,x,y);
						graph.addPositionNode(node);
						arr.add(x,y,node);
						
						
					}
					
				}
			}
			
			
			//下面这一段很费时间 所以分开来写
			map.addEventListener(Event.ENTER_FRAME,testLink);
			
			
			
			
			
			
			
		}
		
		protected function testLink(event:Event):void
		{
			
			
			//每帧只生成一行
			
			//进行连通测试
		
				for(var y=0;y<yPointAmount;y++)
				{
					//获取该点坐标
					var node0:PositionValue=(arr.get(x,y,false) as PositionValue);
					
					//测试相邻的点
					var node1:PositionValue=(arr.get(x-1,y,false) as PositionValue);
					_flood_checkLink(node0,node1,graph,cantPass);
					
					var node2:PositionValue=(arr.get(x+1,y,false) as PositionValue);			
					_flood_checkLink(node0,node2,graph,cantPass);
					
					var node3:PositionValue=(arr.get(x,y-1,false) as PositionValue);
					_flood_checkLink(node0,node3,graph,cantPass);
					
					var node4:PositionValue=(arr.get(x,y+1,false) as PositionValue);
					_flood_checkLink(node0,node4,graph,cantPass);
					
					
					//如果是八方向 获取四个斜方向的相邻的点
					if(eightDirection)
					{
						var node5:PositionValue=(arr.get(x-1,y-1,false) as PositionValue);
						_flood_checkLink(node0,node5,graph,cantPass);
						
						var node6:PositionValue=(arr.get(x+1,y+1,false) as PositionValue);
						_flood_checkLink(node0,node6,graph,cantPass);
						
						var node7:PositionValue=(arr.get(x+1,y-1,false)  as PositionValue);
						_flood_checkLink(node0,node7,graph,cantPass);
						
						var node8:PositionValue=(arr.get(x-1,y+1,false)  as PositionValue);
						_flood_checkLink(node0,node8,graph,cantPass);
					}
					
				}
			
				
				
				x++;
				//是否全部生成完成
				
					
				if(x==xPointAmount)
				{
					if(achieveListener!=null)
					{
						achieveListener(graph);
					}
					map.removeEventListener(Event.ENTER_FRAME,testLink);
				}
				
				if(progressListener!=null)
				{
					//返回生成率
					progressListener((x-1)/(xPointAmount-1));
				}
		}
	}
}