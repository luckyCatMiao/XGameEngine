package XGameEngine.Advanced.Movie
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.GameObjectComponent.StateMachine.AbstractState;
	
	/**
	 *一个特殊状态 影片播放时进入 
	 * @author Administrator
	 * 
	 */	
	public class MovieState extends AbstractState
	{
		public function MovieState(entity:BaseGameObject)
		{
			super(entity);
		}
		
		override public function getName():String
		{
			// TODO Auto Generated method stub
			return "movie";
		}
		
		
		
	}
	
	
}