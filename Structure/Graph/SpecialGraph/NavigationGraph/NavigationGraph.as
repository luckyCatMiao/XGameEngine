package XGameEngine.Structure.Graph.SpecialGraph.NavigationGraph
{
	import XGameEngine.Structure.Graph.Graph;
	import XGameEngine.Structure.Graph.GraphNode;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Math.Vector2;
	import XGameEngine.Util.MathTool;
	
	import avmplus.getQualifiedClassName;

	/**
	 *特殊的图 导航图 图节点为坐标 
	 * @author Administrator
	 * 
	 */	
	public class NavigationGraph extends Graph
	{
		public function NavigationGraph()
		{
			
		}
		
		/**
		 *添加一个节点 
		 * @param value
		 * @return 
		 * 
		 */		
		public function addPositionNode(value:PositionValue,id:int=-1)
		{
			super.addNode(value,id);
		}
		
		
		/**
		 * 连接两个节点(节点必须已经添加到图中)
		 * @param value1
		 * @param value2
		 * @param twoDirection
		 * @return
		 */
		public function linkPositionNode(value1:PositionValue,value2:PositionValue,twoDirection:Boolean=true)
		{
			
			super.linkNodeByValue(value1,value2,twoDirection);
			
		}
		
		public function toXML():XML
		{
			var arr:Array=raw;
			
			//转化为xml
			var xml:XML=new XML("<root></root>");
			xml.nodes=new XML();
			
			for(var i:int=0;i<arr.length;i++)
			{
				var n:GraphNode=arr[i];
				var p:PositionValue=n.value as PositionValue;
				xml.nodes.appendChild(new XML("<node></node>"));
				xml.nodes.node[i].arrIndex=p.indexX+","+p.indexY;
				var ps:Vector2=p.realPostion;
				xml.nodes.node[i].realXY=MathTool.keepFloat(ps.x,1)+","+MathTool.keepFloat(ps.y,1);
				xml.nodes.node[i].id=n.id;
				
			
				
			}
			
			
			xml.links=new XML();
			for(var out:int=0;out<arr.length;out++)
			{
				var node1:GraphNode=arr[out];
				var id1:int=node1.id;
				
				xml.links.appendChild(new XML("<link></link>"));
				xml.links.link[out].id=id1;
				xml.links.link[out].appendChild(new XML("<toID></toID>"));
				
				
				
				var linkNodes:List=node1.linkedNodes;
				var ids:String="";
				for(var ins:int=0;ins<linkNodes.size;ins++)
				{
					var node2:GraphNode=linkNodes.get(ins) as GraphNode;
					var id2:int=node2.id;
					ids+=id2+","

				}
				
				ids=ids.substring(0,ids.length-1);
				xml.links.link[out].toID=ids;
				
				
			}
			
			
			
			return xml;
		}
		
		/**
		 *使用xml生成图 
		 * @param param0
		 * @return 
		 * 
		 */		
		public static function createByXML(xml:XML):NavigationGraph
		{
			
			var graph:NavigationGraph=new NavigationGraph();
			var xmlList:XMLList=xml.nodes.node;
		
			for(var i:int=0;i<xmlList.length();i++)
			{
				
				var arrIndex:String=xml.nodes.node[i].arrIndex;
				var arr1:Array=arrIndex.split(",")
	
				var arrX:int=arr1[0];
				var arrY:int=arr1[1];
				
				var realPostion:String=xml.nodes.node[i].realXY;
				var arr2:Array=realPostion.split(",")
				
				var realPostionX:int=arr2[0];
				var realPostionY:int=arr2[1];
				var id:int=xml.nodes.node[i].id;
				
				var value:PositionValue=new PositionValue(new Vector2(realPostionX,realPostionY),arrX,arrY);
				
				
				graph.addPositionNode(value,id);
				
				
			}
			
			
			xmlList=xml.links.link;
			
			
			for(var a:int=0;a<xmlList.length();a++)
			{
				var id1:int=xml.links.link[a].id;
				
				var toIDs:String=xml.links.link[a].toID;
				var arr:Array=toIDs.split(",");
				
				for(var ins:int=0;ins<arr.length;ins++)
				{
					var id2:int=arr[ins];
					
					graph.linkNodeByID(id1,id2,false);
				}

			}
			
			return graph;
		}
		
	
		/**
		 *扫描所有的节点 返回和目标点距离小于 maxDistance的第一个点
		 * @param target
		 * @param maxDistance
		 * @return 
		 * 
		 */	
		public function getNextNode(target:Vector2, maxDistance:int):PositionValue
		{
			for each(var node:GraphNode in raw)
			{
				var nodePo:Vector2=(node.value as PositionValue).realPostion;
				if(target.getDistance(nodePo)<maxDistance)
				{
					return node.value as PositionValue;
				}
			}
			
			return null;
		}
	}
}