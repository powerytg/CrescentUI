package frameworks.crescent.components
{
	import spark.components.SkinnableContainer;
	
	public class SocketGroup extends SkinnableContainer
	{
		/**
		 * Constructor
		 */
		public function SocketGroup()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function measure():void{
			super.measure();
			measuredHeight = 52;
		}
	}
}