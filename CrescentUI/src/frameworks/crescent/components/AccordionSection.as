package frameworks.crescent.components
{
	import flash.events.MouseEvent;
	
	import frameworks.crescent.components.supportClasses.AccordionTitleBar;
	
	import mx.core.IVisualElement;
	import mx.states.State;
	
	import spark.components.HGroup;
	import spark.components.SkinnableContainer;

	/**
	 * In this state, the whole AccordionSection will shrink into a title bar only
	 */
	[SkinState("shaded")]
	
	/**
	 * In this state, the AccordionSection gets fully expanded
	 */
	[SkinState("expanded")]
	
	/**
	 * An AccordionSection is a titled panel that is 
	 * expandable.
	 */
	public class AccordionSection extends SkinnableContainer
	{
		/**
		 * The title bar
		 */
		[SkinPart("titleBar")]
		public var titleBar:AccordionTitleBar;
		
		/**
		 * An optional group container that could potentially hold some action
		 * buttons
		 */
		[SkinPart(name="actionGroup", required=false)]
		public var actionGroup:HGroup;
		
		/**
		 * @public
		 */
		public var titleBarStyleName:Object;
		
		/**
		 * @private
		 */
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
		 * The actionContent defines a group of optional components
		 * that you'd probably like to include in the title bar
		 */
		public var actionContent:Array;
		
		/**
		 * Constructor
		 */
		public function AccordionSection()
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
		 */
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
			
			if(partName == "titleBar"){
				titleBar.addEventListener(MouseEvent.CLICK, onTitleBarClick, false, 0, true);
				if(titleBarStyleName)
					titleBar.styleName = titleBarStyleName;
			}
			else if(partName == "actionGroup"){
				createActionContent();
			}
		}
		
		/**
		 * @private
		 */
		override protected function partRemoved(partName:String, instance:Object):void{
			super.partRemoved(partName, instance);
			
			if(partName == "titleBar")
				titleBar.removeEventListener(MouseEvent.CLICK, onTitleBarClick);
		}
		
		/**
		 * @protected
		 * 
		 * Create the action children that defined in the actionContent array
		 */
		protected function createActionContent():void{
			actionGroup.removeAllElements();
			
			for each(var element:IVisualElement in actionContent){
				actionGroup.addElement(element);
			}
		}
		
		/**
		 * @private
		 * 
		 * Toggle the expand/shade state
		 */
		private function onTitleBarClick(evt:MouseEvent):void{
			expanded = !_expanded;
			titleBar.expanded = _expanded;
		}

	}
}