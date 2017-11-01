package XGameEngine.Plugins.Box2DPlus.Collision
{
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2DebugDraw;
	
	import XGameEngine.Plugins.Box2DPlus.PhysicsWorld;
	import XGameEngine.Plugins.Box2DPlus.Rigidbody.Rigidbody;
	import XGameEngine.Plugins.Box2DPlus.Util.CastTool;
	import XGameEngine.Structure.Math.Vector2;
	import XGameEngine.Structure.Vector2List;
	
	public class CollisionListener extends b2ContactListener
	{
		private var world:PhysicsWorld;
		public function CollisionListener(w:PhysicsWorld)
		{
			super();
			this.world=w;
		}
		
		override public function BeginContact(contact:b2Contact):void
		{
			var r1:Rigidbody=world.getRigidbodyByB2Body(contact.GetFixtureA().GetBody());
			var r2:Rigidbody=world.getRigidbodyByB2Body(contact.GetFixtureB().GetBody());
			
			var c:Collision=createCollision(contact,r1);
			r2.onCollisionEnter(c);
			
			c=createCollision(contact,r2);
			r1.onCollisionEnter(c);
			
		}
		
		private function createCollision(contact:b2Contact, r:Rigidbody):Collision
		{
			var c:Collision=new Collision();
			c.hitObject=r;
			
			var m:b2WorldManifold=new b2WorldManifold();
			contact.GetWorldManifold(m);
			c.normal=CastTool.castB2Vec2ToVector2(m.m_normal).multiply(PhysicsWorld.valueScale);
			var list:Vector2List=new Vector2List();
			for(var i:int=0;i<m.m_points.length;i++)
			{
				var p:b2Vec2=m.m_points[i] as b2Vec2;
				
				list.addVector2(CastTool.castB2Vec2ToVector2(p).multiply(PhysicsWorld.valueScale));
			}
			
			
			c.points=list;
			
			c.isTouch=contact.IsTouching();
			
			return c;
		}
		
		override public function EndContact(contact:b2Contact):void
		{
			// TODO Auto Generated method stub
			super.EndContact(contact);
		}
		
		override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void
		{
			// TODO Auto Generated method stub
			super.PostSolve(contact, impulse);
		}
		
		override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
			// TODO Auto Generated method stub
			super.PreSolve(contact, oldManifold);
		}
		
		
		
		
		
	}
}