package XGameEngine.Structure.Math
{
	/**
	 *线段 由两个点组成 有方向
	 * @author Administrator
	 * 
	 */	
	public class Line
	{
		public var start:Vector2;
		public var end:Vector2;
		public function Line(start:Vector2,end:Vector2)
		{
			this.start=start;
			this.end=end;
		}
	}
}