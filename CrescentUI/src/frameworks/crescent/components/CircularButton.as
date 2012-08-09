package frameworks.crescent.components
{
	import spark.components.Button;
	
	public class CircularButton extends Button
	{
		/**
		 * Constructor
		 */
		public function CircularButton()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function measure():void{
			measuredWidth = 60;
			measuredHeight = 60;
		}
		
	}
}