package frameworks.crescent.components
{
	import spark.components.Button;
	
	public class OrangeCircularButton extends Button
	{
		/**
		 * Constructor
		 */
		public function OrangeCircularButton()
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