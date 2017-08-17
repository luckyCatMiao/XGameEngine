package XGameEngine.Advanced.Box2DPlus.Rigidbody
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	
	import XGameEngine.Structure.List;
	
	import flash.events.EventDispatcher;

	/**
	 *b2Body以及b2def的混合包装类  
	 * 这里保存的属性将在body初次被设置后全部传递给body
	 * 在之后的每一帧 则直接同步body运算后的数据到本类中
	 * 如果调用set方法 属性将会被直接设置给body
	 * @author Administrator
	 * 
	 */	
	public class Rigidbody
	{
		/**
		 *实际包装的刚体 此类的数据最后都会传递给他 
		 */		
		private var body:b2Body;
		
		
		private var _type:uint;
		/**
		 *坐标 
		 */		
		private var _x:int;
		private var _y:int;
		
		
		/**
		 *保存所有的部件 
		 */		
		private var parts:List=new List();
		public function Rigidbody()
		{
			
			
		}
		
	
	
		/**
		 *刚体类型 
		 */
		public function get type():uint
		{
			return _type;
		}

		/**
		 * @private
		 */
		public function set type(value:uint):void
		{
			_type = value;
			if(body!=null)
			{
				body.SetType(value);
			}
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
			if(body!=null)
			{
				body.SetPosition(new b2Vec2(body.GetPosition().x,value));	
			}
			
		}

		/**
		 *坐标 
		 */
		public function get x():int
		{
			return _x;
		}

		/**
		 * @private
		 */
		public function set x(value:int):void
		{
			_x = value;
			if(body!=null)
			{
				body.SetPosition(new b2Vec2(value,body.GetPosition().y));	
			}
		}

		public function setPackedBody(body:b2Body):void
		{
			//初次创建 将属性全同步给bodu
			this.body=body;
			initBodyValue();
			
		}
		
		private function initBodyValue():void
		{
			body.SetPosition(new b2Vec2(x,y));
			body.SetType(type);
			
		}
		
		public function loop()
		{
		
			SynchronizeData();
			loopParts();
			
		}
		
		/**
		 *循环所有的part的loop 
		 * 
		 */		
		private function loopParts():void
		{
			for each(var bean:RigidPartBean in parts.Raw)
			{
				if(bean.hasAdded)
				{
					bean.part.loop();
				}
			}
			
		}
		
		/**
		 *同步该类的属性与实际包装的b2body,这里因为是每帧调用 
		 * 所以当和实际 world的step频率有区别可能会出现延迟 但一般无法察觉
		 * 
		 */		
		private function SynchronizeData():void
		{
			//同步body的数据
			if(body!=null)
			{
				var b2:b2Vec2=body.GetPosition();
				this._x=b2.x;
				this._y=b2.y;
				this._type=body.GetType();
				

				//添加上没有添加的fixture
				for each(var bean:RigidPartBean in parts.Raw)
				{
					
					if(bean.hasAdded==false)
					{
						bean.hasAdded=true;
						
						var f:b2FixtureDef=new b2FixtureDef();
						//因为除了shape之外所有其他的属性都可以在fixture里面重新设定
						//所以b2FixtureDef没有多大意义 实际上我不是很喜欢这种builder模式的写法。。
						//所以我们这里创建一个空的b2FixtureDef，然后同步一下shape
						//最后把实际的fixture设置回给part 这样part也可以进行同步了
						f.shape=bean.part.shape;
						var a:b2Fixture=body.CreateFixture(f);
						bean.part.setPackedFixture(a);
						
					}
				}
				
			}
			
		
			
		}
		
		
	
		
		
		/**
		 *添加一个刚体组成部分 
		 * 添加到一个缓存区中 在循环时会被自动连接并同步到实际包装的b2body上
		 * @return 
		 * 
		 */		
		public function addRigidPart(part:RigidPart)
		{

			if(part.shape==null)
			{
				throw new Error("part必须要有一个shape!");
			}
			this.parts.add(new RigidPartBean(part));

		}
			
	}
	
	
	
	
}
import XGameEngine.Advanced.Box2DPlus.Rigidbody.RigidPart;

import fl.transitions.Fade;

class RigidPartBean
{
	public var part:RigidPart;
	
	/**
	 *是否被添加到实际的b2body中了 
	 */	
	public var hasAdded:Boolean;
	public function RigidPartBean(part:RigidPart,hasAdded:Boolean=false)
	{
		this.part=part;
		this.hasAdded=hasAdded;
	}
}