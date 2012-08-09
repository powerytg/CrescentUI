package frameworks.crescent.components
{
	import spark.components.Button;
	
	public class Button extends spark.components.Button
	{
		/**
		 * Constructor
		 */
		public function Button()
		{
			super();
		}
		
		/**
		 * @prvate
		 */
		override protected function measure():void{
			super.measure();
			measuredWidth = measuredWidth + 20;
			measuredHeight = 40;
		}
	}
}