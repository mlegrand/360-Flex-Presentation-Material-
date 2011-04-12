package
{
	import mx.containers.Canvas;
	
	public class PhysicsCanvas extends Canvas
	{
		public function PhysicsCanvas()
		{
			super();
			
			addEventListener(Event.ENTER_FRAME, updateFrame, false, 0, true);			
			
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.minVertex.Set(-2000.0, -2000.0);
			worldAABB.maxVertex.Set(2000.0, 2000.0);
			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, 0.0);
			
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			
			// Construct a world object
			m_world = new b2World(worldAABB, gravity, doSleep);

			
		}
	}
}