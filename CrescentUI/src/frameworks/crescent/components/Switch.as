package frameworks.crescent.components
{
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	import mx.states.State;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 * Selected state
	 */
	[SkinState("selected")]
	
	/**
	 * Normal state
	 */
	[SkinState("normal")]
	
	public class Switch extends SkinnableComponent
	{
		/**
		 * @private
		 */
		private var _selected:Boolean;

		/**
		 * @private
		 */
		[Bindable]
		public function get selected():Boolean
		{
			return _selected;
		}

		/**
		 * @private
		 */
		public function set selected(value:Boolean):void
		{
			_selected = value;
			currentState = _selected ? "selected" : "normal";
			invalidateSkinState();
		}
		
		/**
		 * Constructor
		 */
		public function Switch()
		{
			super();
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function onCreationComplete(evt:FlexEvent):void{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);

		}
		
		/**
		 * @public
		 */
		override public function initialize():void{
			super.initialize();
			
			states.push(new State({name: "normal"}));
			states.push(new State({name: "selected"}));
		}
		
		/**
		 * @protected
		 */
		override protected function getCurrentSkinState():String
		{
			return _selected ? "selected" : "normal";
		} 

		/**
		 * @private
		 */
		protected function onClick(evt:MouseEvent):void{
			selected = !selected;
		}
		
	}
}