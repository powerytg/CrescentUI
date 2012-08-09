package frameworks.crescent.components.supportClasses
{
	import mx.states.State;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 * Indicates that the AccordionSection has been shaded into as title bar only
	 */
	[SkinState("shaded")]
	
	/**
	 * Indicates that the AccordionSection has been fully expanded
	 */
	[SkinState("expanded")]
	
	/**
	 * The AccordionTitleBar has exactly the same states as its host component, 
	 * AccordionSection
	 */
	public class AccordionTitleBar extends SkinnableComponent
	{
		private var _expanded:Boolean = true;

		/**
		 * @protected
		 */
		public function get expanded():Boolean
		{
			return _expanded;
		}

		/**
		 * @private
		 */
		public function set expanded(value:Boolean):void
		{
			_expanded = value;
			currentState = _expanded ? "expanded" : "shaded";
		}
		
		/**
		 * Title
		 */
		[Bindable]
		public var title:String;
		
		/**
		 * Constructor
		 */
		public function AccordionTitleBar()
		{
			super();
		}
		
		/**
		 * Initial states
		 */
		override public function initialize():void
		{
			super.initialize();
			
			states.push(new State({name:"shaded"}));
			states.push(new State({name:"expanded"}));
			
			// Initial state
			currentState = _expanded ? "expanded" : "shaded";
		}
		
		/**
		 * @protected
		 */
		override protected function stateChanged(oldState:String, newState:String, recursive:Boolean):void
		{
			super.stateChanged(oldState, newState, recursive);
			invalidateSkinState();
		}
		
		/**
		 * @protected
		 */
		override protected function getCurrentSkinState():String
		{
			return currentState;
		}
		
		/**
		 * @protected
		 * 
		 * The title bar will have a fixed height
		 */
		override protected function measure():void{
			super.measure();
			measuredHeight = 55;
		}

	}
}