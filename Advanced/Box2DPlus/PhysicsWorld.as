package XGameEngine.Advanced.Box2DPlus
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import XGameEngine.Advanced.Box2DPlus.Rigidbody.Rigidbody;
	import XGameEngine.Advanced.Box2DPlus.Util.CastTool;
	import XGameEngine.Advanced.Interface.LoopAble;
	import XGameEngine.GameEngine;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Map;
	import XGameEngine.Structure.Math.Vector2;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;

	public class PhysicsWorld implements LoopAble
	{
		
		private var forces:Map=new Map();
		private var world:b2World;
		private var engine:GameEngine;
		private var list:List=new List();
		
		/**
		 *物理模拟一秒钟更新几次 可以和stage.framerate不同 
		 */		
		public var workRate:int;
		
		private var _debugPlane:Sprite;
		
		
		/**
		 * 
		 * @param engine 引擎对象
		 * @param framerate 工作频率 默认和舞台帧率相同
		 * 
		 */		
		public function PhysicsWorld(engine:GameEngine,framerate:int=-1)
		{
			this.engine=engine;
			world=new b2World(new b2Vec2,true);
			
			engine.addLoopAble(this);
			
			if(framerate==-1)
			{
				framerate=engine.getStage().frameRate;
			}
			
			this.workRate=framerate;
			
			
			
			
		}
		
		/**
		 *debug Plane 
		 */
		public function get debugPlane():Sprite
		{
			return _debugPlane;
		}

		/**
		 * @private
		 */
		public function set debugPlane(value:Sprite):void
		{
			if(_debugPlane==null)
			{
				_debugPlane = value;
				
				var debug:b2DebugDraw = new b2DebugDraw();
				debug.SetSprite(value);
				debug.SetDrawScale(1);
				debug.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
				
				debug.SetFillAlpha(0.5);
				debug.SetLineThickness(1);
				
				world.SetDebugDraw(debug);
			}
			
		}

		public function loop()
		{
		
			//world这里的实际参数是秒 但是我觉得做游戏帧更加直观 比如每帧运动十个像素 而不是每秒运行多少
			//所以这里就直接默认为一秒 然后再乘上缩放值 即如果实际workRate大于frameRate 运算速度就会有变快的感觉
			world.Step(1*(workRate/engine.getStage().frameRate),10,10);
			
			for each(var r:Rigidbody in list.Raw)
			{
				r.loop();
			}
			
			if(debugPlane!=null)
			{
				
				world.DrawDebugData();
	
			}
			
		}
		
		
		/**
		 * 施加一个力 作用于模拟里的所有对象 添加的多个力最后会合成
		 * @param	name 力的名字
		 * @param	v 力
		 */
		public function AddForce(name:String,v:Vector2)
		{
			forces.put(name,v);
			
			resetForceToWorld();
		}
		
		private function resetForceToWorld():void
		{
			
			var v2:Vector2=SumUpVector2();
			var b:b2Vec2=CastTool.castVector2ToB2Vec2(v2);
			world.SetGravity(b);
			
		}
		
		
		/**
		 *将一组向量全加起来返回结果向量
		 * @param l
		 * @return 
		 * 
		 */		
		private function SumUpVector2():Vector2
		{
			var xASpeed:int = 0;
			var yASpeed:int = 0;
			for each(var v:Vector2 in forces.rawData)
			{
				xASpeed += v.x;
				yASpeed += v.y;
			}
			
			
		
			return new Vector2(xASpeed, yASpeed);
		}
		
		
		/**
		 *移除一个力 
		 * @param name 名字
		 * @param v 力
		 * @return 
		 * 
		 */		
		public function RemoveForce(name:String)
		{
			
			forces.put(name,null);
		}
		
		/**
		 * 清空所有的力
		 */
		public function clearForces()
		{
			forces=new Map();
		}
		
		
		/**
		 *添加一个2D刚体 
		 * @return 
		 * 
		 */		
		public function addRigidbody(r:Rigidbody):void
		{
			
			//添加到list中
			this.list.add(r);
			
			//因为最后数据会同步到b2body里 所以添加一个空的也没关系
			//其实这个b2BodyDef就是类似一个bean类 或者说builder模式
			//最后的属性其实在b2body里面还可以改
			var body:b2Body = world.CreateBody(new b2BodyDef());
			//设置实际的包装对象
			r.setPackedBody(body);	
			
			
		}
	}
}