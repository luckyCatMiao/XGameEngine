package XGameEngine.GameObject
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author o
	 */
	public class Animation extends MovieClip 
	{
		public function playAnime(labelName:String)
		{
			try
			{
				this.gotoAndStop(labelName);
			}
			catch(e:ArgumentError)
			{
				throw new Error("the target label "+labelName+" doesn't exist in the movieclip")
			}
		}
	}
	
}