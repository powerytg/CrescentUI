package frameworks.crescent.components.supportClasses
{
	import mx.events.PropertyChangeEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	public class PagerIndicator extends SkinnableComponent
	{
		/**
		 * @private
		 */
		private var _selected:Boolean = false;

		/**
		 * @public
		 */
		[Bindable]
		public function get selected():Boolean
		{
			return _selected;
		}

		/**
		 * @public
		 */
		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			var evt:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
			evt.property = "selected";
			dispatchEvent(evt);
		}

		 
		/**
		 * Constructor
		 */
		public function PagerIndicator()
		{
			super();
		}
	}
}