package frameworks.crescent.components
{
	import spark.components.Button;
	
	public class RedCircularButton extends Button
	{
		/**
		 * Constructor
		 */
		public function RedCircularButton()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function measure():void{
			measuredWidth = 40;
			measuredHeight = 40;
		}
		
	}
}