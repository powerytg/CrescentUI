package frameworks.crescent.activity
{
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import frameworks.crescent.activity.events.ActivityContainerEvent;
	import frameworks.crescent.components.RedCircularButton;
	
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.SkinnableContainer;
	import spark.core.IDisplayText;
	
	/**
	 * Selected by the deck
	 */
	[Event(name="activitied", type="frameworks.crescent.activity.events.ActivityContainerEvent")]
	
	/**
	 * De-selected by the deck
	 */
	[Event(name="deactivitied", type="frameworks.crescent.activity.events.ActivityContainerEvent")]
	
	/**
	 * After being resized
	 */
	[Event(name="resizeComplete", type="frameworks.crescent.activity.events.ActivityContainerEvent")]
	
	/**
	 * An CrescentUI Activity is based off a skinnable container, with additional capability of being embedded into an
	 * ActivityDeck.
	 * 
	 * Usually only one Activity is "active" at a time, while the rest of them fall into the inactive mode. Under this state, 
	 * child elements are hidden and deattached from the Activity's display list, leaving a fake proxy bitmap on top.
	 */
	public class Activity extends SkinnableContainer
	{
		/**
		 * @public
		 */
		public var uri:String;
		
		/**
		 * @public
		 */
		[SkinPart]
		public var titleLabel:IDisplayText;
		
		/**
		 * @public
		 */
		[SkinPart]
		public var titleGroup:Group;
		
		/**
		 * @public
		 */
		[SkinPart]
		public var closeButton:RedCircularButton;
		
		/**
		 * Action group
		 */
		[SkinPart]
		public var actionGroup:HGroup;
		
		/**
		 * @public
		 */
		[SkinPart]
		public var backgroundGroup:Group;
		
		/**
		 * Actions. These UI components will be added into the actionGroup
		 */
		public var actions:Array = [];
		
		/**
		 * Title
		 */
		private var _title:String = "activity";
		
		[Bindable]
		public function get title():String
		{
			return _title;
		}
		
		/**
		 * @private
		 */
		public function set title(value:String):void
		{
			if(_title != value){
				_title = value;
				
				if(titleLabel)
					titleLabel.text = _title;
				
				if(titleGroup)
					titleGroup.invalidateDisplayList();
					
			}
		}
		
		/**
		 * @private
		 */
		private var _backgroundIsTransparent:Boolean = true;

		/**
		 * @public
		 */
		public function get backgroundIsTransparent():Boolean
		{
			return _backgroundIsTransparent;
		}

		/**
		 * @public
		 */
		public function set backgroundIsTransparent(value:Boolean):void
		{
			_backgroundIsTransparent = value;
			if(backgroundGroup)
				backgroundGroup.visible = !_backgroundIsTransparent;
		}

		
		/**
		 * Description
		 */
		private var _description:String = "This is a user customized activity page. Click on a container to add a part.";
		
		/**
		 * @public
		 */
		[Bindable]
		public function get description():String
		{
			return _description;
		}
		
		/**
		 * @private
		 */
		public function set description(value:String):void
		{
			if(_description != value){
				_description = value;
				invalidateDisplayList();
			}
		}
		
		
		/**
		 * Whether the user can kill this activity, or does it have to be pinned onto screen
		 */
		private var _canClose:Boolean = true;
		
		[Bindable]
		public function get canClose():Boolean
		{
			return _canClose;
		}
		
		/**
		 * @private
		 */
		public function set canClose(value:Boolean):void
		{
			if(_canClose != value){
				_canClose = value;
				invalidateDisplayList();
			}
		}

		/**
		 * Whether to allow users changing the layout of the Activity
		 */
		private var _canEdit:Boolean = true;

		[Bindable]
		public function get canEdit():Boolean
		{
			return _canEdit;
		}

		/**
		 * @private
		 */
		public function set canEdit(value:Boolean):void
		{
			if(_canEdit != value){
				_canEdit = value;
				invalidateDisplayList();
			}
		}

		/**
		 * @public
		 */
		[Embed(source="frameworks/crescent/skins/images/DefaultActivityIcon.png")]
		public var defaultIcon:Class;
		
		/**
		 * @public
		 */
		[Bindable]
		public var icon:Class = defaultIcon;
		
		/**
		 * @public
		 * 
		 * The local message bus.
		 * 
		 */
		public var localMessageBus:EventDispatcher = new EventDispatcher();
		
		/**
		 * Constructor
		 */
		public function Activity()
		{
			super();
//			this.creationPolicy = "none";
			
			// Listen for "active" and "de-active" events
			addEventListener(ActivityContainerEvent.ACTIVITIED, onActivited, false, 0, true);
			addEventListener(ActivityContainerEvent.DEACTIVITIED, onDeactivited, false, 0, true);
		}
		
		/**
		 * @private
		 */
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
			
			switch(partName){
				case "closeButton":
					closeButton.addEventListener(MouseEvent.CLICK, close, false, 0, true);
					break;
				case "backgroundGroup":
					backgroundGroup.visible = !_backgroundIsTransparent;
					break;
			}
			
		}
		
		/**
		 * @protected
		 */
		protected function createActionItems():void{
			actionGroup.removeAllElements();
			
			for each(var e:IVisualElement in actions){
				actionGroup.addElement(e);
			}
		}
		
		/**
		 * @private
		 */
		override protected function commitProperties():void{
			super.commitProperties();
			createActionItems();
		}
		
		/**
		 * @private
		 */
		protected function close(evt:MouseEvent = null):void{
			var event:ActivityContainerEvent = new ActivityContainerEvent(ActivityContainerEvent.CLOSE_ACTIVITY, true);
			event.activity = this;
			dispatchEvent(event);
		}
		
		/**
		 * @private
		 */
		protected function onActivited(evt:ActivityContainerEvent):void{
			// Bubble up to local bus
			localMessageBus.dispatchEvent(new ActivityContainerEvent(ActivityContainerEvent.ACTIVITIED));
		}
		
		/**
		 * @private
		 */
		protected function onDeactivited(evt:ActivityContainerEvent):void{
			localMessageBus.dispatchEvent(new ActivityContainerEvent(ActivityContainerEvent.DEACTIVITIED));
		}
		
		/**
		 * @public
		 */
		public function destroy():void{
			trace("Activity [" + this.title + "] destroyed");
			
			if(closeButton)
				closeButton.removeEventListener(MouseEvent.CLICK, close);
			
			removeEventListener(ActivityContainerEvent.ACTIVITIED, onActivited);
			removeEventListener(ActivityContainerEvent.DEACTIVITIED, onDeactivited);
			
			actions = [];

			// Notify the UI parts inside this activity
			localMessageBus.dispatchEvent(new ActivityContainerEvent(ActivityContainerEvent.DESTROY));
			localMessageBus = null;
		}
		
	}
}