package frameworks.crescent.components
{
	import spark.components.SkinnableContainer;

	/**
	 * This is a container that works like Flex3's Accordion, but with significant difference:
	 * 
	 * (1) This involves less complex logic
	 * (2) It basically is a VGroup
	 * (3) More than one sections could be expanded at a time
	 * 
	 */
	public class Accordion extends SkinnableContainer
	{
		/**
		 * Constructor
		 */
		public function Accordion()
		{
			super();
		}		
	}
}