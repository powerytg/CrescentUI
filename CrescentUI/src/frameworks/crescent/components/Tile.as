package frameworks.crescent.components
{
	import flash.events.MouseEvent;
	
	import mx.states.State;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	/**
	 * Normal state
	 */
	[SkinState("up")]
	
	/**
	 * Selected state
	 */
	[SkinState("down")]
	
	/**
	 * A Tile is a skinned container that comes with two states: up and down.
	 * Optionally, the Tile component could act as a button, which enters the down state if being clicked on,
	 * and then returns to the up state when the finger releases. 
	 */
	public class Tile extends SkinnableContainer
	{
		/**
		 * @public
		 */
		[SkinPart]
		public var backgroundGroup:Group;
		
		/**
		 * @public
		 */
		public var actAsButton:Boolean = false;
				
		/**
		 * @public
		 */
		protected var _selected:Boolean = false;
		
		/**
		 * @public
		 */
		public function get selected():Boolean{
			return _selected;
		}
		
		/**
		 * @public
		 */
		public function set selected(value:Boolean):void{
			if(_selected == value)
				return;
			
			_selected = value;
			
			currentState = _selected ? "down" : "up";
			invalidateSkinState();
		}
		
		/**
		 * @public
		 */
		[Bindable]
		public var faceColor:Number = 0x9c9c9c;
		
		/**
		 * @public
		 * 
		 * If glowColor is -1, then the glow matches the faceColor
		 */
		public var glowColor:Number = -1;
		
		/**
		 * Constructor
		 */
		public function Tile()
		{
			super();
		}
		
		/**
		 * @public
		 */
		override public function initialize():void
		{
			super.initialize();
			
			states.push(new State({name:"up"}));
			states.push(new State({name:"down"}));
			
			// Default state
			currentState = _selected ? "down" : "up";
			
			// Mouse events
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		/**
		 * @protected
		 */
		override protected function getCurrentSkinState():String
		{
			return _selected ? "down" : "up";
		} 
		
		/**
		 * @private
		 */
		protected function onMouseDown(evt:MouseEvent):void{
			if(actAsButton){
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				selected = true;			
			}
		}
		
		/**
		 * @protected
		 */
		protected function onMouseUp(evt:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			selected = false;
		}
	}
}