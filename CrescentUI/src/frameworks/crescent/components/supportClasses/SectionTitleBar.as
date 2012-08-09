package frameworks.crescent.components.supportClasses
{
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 * The AccordionTitleBar has exactly the same states as its host component, 
	 * AccordionSection
	 */
	public class SectionTitleBar extends SkinnableComponent
	{
		
		/**
		 * Title
		 */
		[Bindable]
		public var title:String;
		
		/**
		 * Constructor
		 */
		public function SectionTitleBar()
		{
			super();
		}
		
		/**
		 * @protected
		 * 
		 * The title bar will have a fixed height
		 */
		override protected function measure():void{
			super.measure();
			measuredHeight = 45;
		}

	}
}