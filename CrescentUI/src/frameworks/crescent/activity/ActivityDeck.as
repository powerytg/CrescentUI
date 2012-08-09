package frameworks.crescent.activity
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import frameworks.crescent.activity.events.ActivityContainerEvent;
	import frameworks.crescent.activity.events.ActivityDeckEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.mx_internal;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.events.TouchInteractionEvent;
	import mx.states.State;
	
	import spark.components.HGroup;
	import spark.components.Scroller;
	import spark.components.SkinnableContainer;
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.primitives.BitmapImage;
	
	use namespace mx_internal;
	
	/**
	 * When the activity selection has changed
	 */
	[Event(name="activityChanged", type="frameworks.crescent.activity.events.ActivityDeckEvent")]
	
	/**
	 * Normal mode
	 */
	[SkinState("normal")]
	
	/**
	 * Transition mode (user swiping across the activities)
	 */
	[SkinState("transition")]
	
	/**
	 * The ActivityDeck in a horizontal container that lays out activities.
	 * The ActivityDeck has the following major differences (and improvements) with the HCardDeck counterpart in 
	 * Crescent UI 1.0 (used in StrobeHero):
	 * 
	 * 1. An Activity is always open, unlike cards.
	 * 2. Users directly operate on the active Activity without having to bother opening it
	 */
	public class ActivityDeck extends SkinnableContainer
	{
		/**
		 * @private
		 */
		[Embed(source="../skins/images/ActivityLoading.png")]
		private var loadingFace:Class;
		
		/**
		 * The proxy group
		 */
		[SkinPart]
		public var proxyGroup:HGroup;
		
		/**
		 * The proxy scroller
		 */
		[SkinPart]
		public var proxyScroller:Scroller;
		
		/**
		 * Gap between activities
		 */
		public var gap:Number = DEFAULT_GAP;
		
		/**
		 * Default gap
		 */
		public static const DEFAULT_GAP:Number = 40;
		
		/**
		 * Default fullscreen gap
		 */
		public static const DEFAULT_FULL_SCREEN_GAP:Number = 40;
		
		/**
		 * @public
		 */
		[Bindable]
		public var currentActivity:Activity;
		
		/**
		 * @private
		 */
		[Bindable]
		public var activities:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 */
		public var fullScreenMode:Boolean = false;
		
		/**
		 * @private
		 */
		private var mouseDetectionThreshold:Number = 15;
		
		/**
		 * @private
		 */
		private var spaceTransitionThreshold:Number = 60;
		
		/**
		 * @private
		 */
		private var transitionMouseOrigin:Point;
		
		/**
		 * @private
		 */
		private var moving:Boolean = false;
		
		/**
		 * @private
		 */
		private var longDragThreshold:Number = 100;
		
		/**
		 * @private
		 * 
		 * The timer to count the time of finger being pushed down
		 */
		private var mouseDownStartTime:Number;
		
		/**
		 * @public
		 */
		private var _scrollingStyle:String = ActivityDeckScrollingStyle.OPTIMIZED;
		
		/**
		 * @public
		 */
		[Bindable]
		public function get scrollingStyle():String
		{
			return _scrollingStyle;
		}
		
		/**
		 * @private
		 */
		public function set scrollingStyle(value:String):void
		{
			_scrollingStyle = value;
			
			if(contentGroup != null && proxyScroller != null)
				setupListeners();
		}
		
		/**
		 * @private
		 */
		private var _transparentActivityBackground:Boolean = true;
		
		/**
		 * @public
		 */
		public function get transparentActivityBackground():Boolean
		{
			return _transparentActivityBackground;
		}
		
		/**
		 * @private
		 */
		public function set transparentActivityBackground(value:Boolean):void
		{
			_transparentActivityBackground = value;
			for each(var activity:Activity in activities){
				activity.backgroundIsTransparent = _transparentActivityBackground;
			}
		}
		
		/**
		 * @private
		 */
		private var creationAnimate:Animate;
		
		/**
		 * @private
		 * 
		 * Step 1 of the removeActivity() animation
		 */
		private var removeAnimate:Animate;
		
		/**
		 * @private
		 * 
		 * Step 2 of the removeActivity() animation
		 */
		private var discardAnimate:Animate;		
		
		/**
		 * @private
		 */
		private var targetingActivity:Activity;
		
		/**
		 * @private
		 */
		private var targetingActivityIndex:Number;
		
		/**
		 * Constructor
		 */
		public function ActivityDeck()
		{
			super();
			
			addEventListener(FlexEvent.CREATION_COMPLETE, init, false, 0, true);
			addEventListener(ActivityContainerEvent.CLOSE_ACTIVITY, onCloseActivity, false, 0, true);
		}
		
		/**
		 * @public
		 */
		public function get selectedIndex():Number{
			if(!currentActivity)
				return -1;
			else
				return activities.getItemIndex(currentActivity);
		}
		
		/**
		 * @public
		 */
		override public function initialize():void
		{
			super.initialize();
			
			states.push(new State({name:"normal"}));
			states.push(new State({name:"transition"}));
			
			// Default state
			currentState = "normal";
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
		override protected function stateChanged(oldState:String, newState:String, recursive:Boolean):void{
			super.stateChanged(oldState, newState, recursive);
			invalidateSkinState();
		}
		
		/**
		 * @private
		 */
		protected function setupListeners():void{
			switch(_scrollingStyle){
				case ActivityDeckScrollingStyle.FLUID:
					proxyScroller.removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_END, onScrollEnd);
					proxyScroller.removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START, onScrollStart);
					
					proxyScroller.addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_END, onScrollEnd);
					proxyScroller.addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START, onScrollStart);
					
					contentGroup.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
					removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					
					proxyScroller.setStyle("horizontalScrollPolicy", "on");
					break;
				case ActivityDeckScrollingStyle.OPTIMIZED:
					proxyScroller.removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_END, onScrollEnd);
					proxyScroller.removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START, onScrollStart);
					
					contentGroup.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
					
					addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					
					proxyScroller.setStyle("horizontalScrollPolicy", "off");
					break;
				case ActivityDeckScrollingStyle.SWIPE:
					proxyScroller.removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_END, onScrollEnd);
					proxyScroller.removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START, onScrollStart);
					
					removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					contentGroup.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
					
					proxyScroller.setStyle("horizontalScrollPolicy", "off");
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function onMouseDown(evt:MouseEvent):void{
			transitionMouseOrigin = new Point(evt.stageX, evt.stageY);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function onMouseMove(evt:MouseEvent):void{
			if(moving){
				evt.stopPropagation();
				var offset:Number = fullScreenMode ? evt.stageX - transitionMouseOrigin.x + width * 0.05  
					: evt.stageX - transitionMouseOrigin.x;
				var currentProxy:BitmapImage = proxyGroup.getElementAt(selectedIndex) as BitmapImage;
				proxyGroup.horizontalScrollPosition = currentProxy.x - offset;
			}
			else{
				var distX:Number = Math.abs(evt.stageX - transitionMouseOrigin.x);
				var distY:Number = Math.abs(evt.stageY - transitionMouseOrigin.y);
				if(distX > mouseDetectionThreshold && distX > distY)
					beginTransition();				
			}
		}
		
		/**
		 * @private
		 */
		private function onMouseUp(evt:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			var offset:Number = evt.stageX - transitionMouseOrigin.x;
			
			if(moving)
				endTransition(offset);
		}
		
		/**
		 * @private
		 */
		private function beginTransition():void{
			updateProxy(currentActivity);
			moving = true;
			currentState = "transition";
			
			mouseDownStartTime = flash.utils.getTimer();
		}
		
		/**
		 * @private
		 * 
		 * The distance is the accumulated offset in vertical direction
		 */
		private function endTransition(distance:Number):void{
			moving = false;
			var targetIndex:Number;
			var target:Activity = null;
			
			// The finger offset
			var offset:Number = selectedIndex * currentActivity.width - proxyGroup.horizontalScrollPosition;
			
			var mouseDownTime:Number = flash.utils.getTimer() - mouseDownStartTime;
			if(mouseDownTime > longDragThreshold){
				// Long drag. In this case, the screen will move only move until the y offset is larger than spaceTransitionThreshold
				if(Math.abs(distance) < spaceTransitionThreshold)
					targetIndex = selectedIndex;
				else if(offset < 0)
					targetIndex = Math.min(activities.length - 1, selectedIndex + 1);
				else
					targetIndex = Math.max(0, selectedIndex - 1);				
			}
			else{
				// Quick swipe. In this case, the screen will move in the finger's direction
				if(offset < 0)
					targetIndex = Math.min(activities.length - 1, selectedIndex + 1);
				else
					targetIndex = Math.max(0, selectedIndex - 1);								
			}
			
			// Find the nearest screen
			target = activities.getItemAt(targetIndex) as Activity;
			lookAt(target);
		}
		
		/**
		 * @private
		 */
		protected function onSwipe(evt:TransformGestureEvent):void{
			var currentIndex:Number = activities.getItemIndex(currentActivity);
			
			if(evt.offsetX == 1){
				updateProxy(currentActivity);
				
				// Swipe to left
				if(currentIndex != 0)
					lookAt(activities.getItemAt(currentIndex - 1) as Activity);
			}
			else if(evt.offsetX == -1){
				updateProxy(currentActivity);
				
				// Swipe to right
				if(currentIndex != activities.length - 1)
					lookAt(activities.getItemAt(currentIndex + 1) as Activity);
				
			}
		}
		
		/**
		 * @private
		 */
		protected function onScrollStart(evt:TouchInteractionEvent):void{
			// Update the proxy of the current selection, to minimize glithes.
			updateProxy(currentActivity);
			
			currentState = "transition";
		}
		
		/**
		 * @private
		 */
		protected function onScrollEnd(evt:TouchInteractionEvent):void{
			var target:Activity = getNearestActivity();
			if(target != currentActivity){
				updateProxy(target);
			}
			
			lookAt(target);				
		}
		
		/**
		 * @protected
		 * 
		 * Get the activity that most likely to be in the middle of screen based
		 * on the horizontalScrollPosition value of the scroller
		 */
		public function getNearestActivity():Activity{
			var minDist:Number = -1;
			var nearestIndex:Number;
			
			// Find the nearest activity
			for (var i:uint = 0; i < proxyGroup.numElements; i++){
				var proxy:BitmapImage = proxyGroup.getElementAt(i) as BitmapImage;
				var dist:Number = Math.abs(proxy.x - proxyScroller.viewport.horizontalScrollPosition);
				
				if(minDist == -1 || dist < minDist){
					minDist = dist;
					nearestIndex = i;
				}
			}
			
			return contentGroup.getElementAt(nearestIndex) as Activity;
		}
		
		/**
		 * Initialize MXML based children
		 * @private
		 */
		protected function init(evt:FlexEvent = null):void{
			removeEventListener(FlexEvent.CREATION_COMPLETE, init);
			setupListeners();
			
			for(var i:uint = 0; i < contentGroup.numElements; i++){
				var activity:Activity = contentGroup.getElementAt(i) as Activity;
				activities.addItem(activity);				
				adjustActivityWidth(activity);
				updateProxy(activity);
			}			
			
			if(contentGroup.numElements != 0){
				currentActivity = contentGroup.getElementAt(0) as Activity;
				currentState = "normal";
			}
		}
		
		/**
		 * @public
		 */
		public function addActivityToFront(activity:Activity):void{
			if(activities.length == 0)
				addActivity(activity);
			else
				addActivityBefore(activity, currentActivity);
		}
		
		/**
		 * @public
		 * 
		 * This method inserts an activity before the target, and effectly
		 * auto-focus on the newly added activity
		 */
		public function addActivityBefore(activity:Activity, target:Activity):void{
			targetingActivity = activity;
			
			// Update the old target's proxy image
			updateProxy(target);
			
			// Enter transition state
			currentState = "transition";
			activity.backgroundIsTransparent = _transparentActivityBackground;
			
			// Add the activity to the contentGroup first, to give a head start for its initialization
			targetingActivityIndex = contentGroup.numElements == 0 ? 0 : contentGroup.getElementIndex(target);
			
			// Insert an empty proxy into the proxy group. The new proxy has no background and has a width
			// of 0, which is simply a place holder
			var proxy:BitmapImage = new BitmapImage();
			proxy.width = 0;
			proxy.height = getDefaultActivityHeight();
			proxy.source = loadingFace;
			proxy.horizontalAlign = "center";
			proxy.verticalAlign = "middle";
			proxy.fillMode = "clip";
			proxyGroup.addElementAt(proxy, targetingActivityIndex);
			
			// Here is a dirty hack: in the situation that the skin doesn not respond fast enough to enable the visibility of
			// all of the proxies, there will be a blink happen when there is only one activity left. We have to make sure this activity
			// has its proxy image visible
			for(var i:uint = 0; i < proxyGroup.numElements; i++){
				proxyGroup.getElementAt(i).visible = true;
			}
			
			// Play an animation to "push" the affected activities away by increasing the with of the new proxy image
			var mp:SimpleMotionPath = new SimpleMotionPath("width");
			mp.valueTo = getDefaultActivityWidth();
			creationAnimate = new Animate(proxy);
			creationAnimate.motionPaths = Vector.<MotionPath>([mp]);
			creationAnimate.duration = 250;			
			creationAnimate.addEventListener(EffectEvent.EFFECT_END, onCreationAnimateEnd);
			creationAnimate.play();			
		}
		
		/**
		 * @private
		 */
		private function onCreationAnimateEnd(evt:EffectEvent):void{
			creationAnimate.removeEventListener(EffectEvent.EFFECT_END, onCreationAnimateEnd);
			
			if(!targetingActivity)
				return;
			
			contentGroup.addElementAt(targetingActivity, targetingActivityIndex);
			activities.addItemAt(targetingActivity, targetingActivityIndex);
			adjustActivityWidth(targetingActivity);
			
			lookAt(targetingActivity);
			
			getProxyOf(targetingActivity).source = null;
			targetingActivity = null;
		}
		
		/**
		 * @public
		 * 
		 * Add an activity to the rear of the queue. This method does not auto-focus at
		 * the newly added activity, nor does it change the currentActivity property
		 */
		public function addActivity(activity:Activity):void{
			activity.backgroundIsTransparent = _transparentActivityBackground;
			contentGroup.addElement(activity);
			activities.addItem(activity);
			adjustActivityWidth(activity);
			
			// Create an initial proxy
			activity.addEventListener(FlexEvent.CREATION_COMPLETE, onActivityInitialized, false, 0, true);
			
			// If this is the only activity, then set it to be the current activity
			if(contentGroup.numElements == 1){
				currentActivity = activity;
			}
		}
		
		/**
		 * @public
		 * 
		 * Remove an activity, and auto-focus on the one that comes after it
		 */
		public function removeActivity(activity:Activity):void{
			// Update the proxy image
			updateProxy(activity);
			
			// Enter transition state
			currentState = "transition";
			targetingActivity = activity;
			targetingActivityIndex = activities.getItemIndex(activity);
			var proxy:BitmapImage = getProxyOf(activity);
			
			// Perform a fly-out animation
			proxyGroup.autoLayout = false;
			
			var flyMp:SimpleMotionPath = new SimpleMotionPath("y");
			flyMp.valueTo = -targetingActivity.height;
			
			removeAnimate = new Animate(proxy);
			removeAnimate.suspendBackgroundProcessing = true;
			removeAnimate.motionPaths = Vector.<MotionPath>([flyMp]);
			removeAnimate.duration = 250;
			removeAnimate.addEventListener(EffectEvent.EFFECT_END, onRemoveAnimationStage1End);
			removeAnimate.play();
		}
		
		/**
		 * @private
		 */
		private function onRemoveAnimationStage1End(evt:EffectEvent):void{
			if(removeAnimate){
				removeAnimate.removeEventListener(EffectEvent.EFFECT_END, onRemoveAnimationStage1End);
				removeAnimate = null;
			}
			
			if(!targetingActivity)
				return;
			
			var proxy:BitmapImage = getProxyOf(targetingActivity);
			proxy.visible = false;
			proxyGroup.autoLayout = true;
			
			// Perform a discard animation
			var mp:SimpleMotionPath = new SimpleMotionPath("width");
			mp.valueTo = 0;
			
			discardAnimate = new Animate(proxy);
			discardAnimate.motionPaths = Vector.<MotionPath>([mp]);
			discardAnimate.duration = 250;
			discardAnimate.addEventListener(EffectEvent.EFFECT_END, onRemoveAnimationStage2End);
			discardAnimate.play();
		}
		
		/**
		 * @private
		 */
		private function onRemoveAnimationStage2End(evt:EffectEvent):void{
			if(discardAnimate){
				discardAnimate.removeEventListener(EffectEvent.EFFECT_END, onRemoveAnimationStage2End);
				discardAnimate = null;
			}
			
			if(!targetingActivity)
				return;
			
			var proxy:BitmapImage = getProxyOf(targetingActivity);
			
			contentGroup.removeElement(targetingActivity);
			proxyGroup.removeElement(proxy);
			activities.removeItemAt(targetingActivityIndex);
			
			// Force invalidate layout elements. This is very important to avoid blinking and 
			// incorrect layout
			proxyGroup.invalidateSize();
			proxyGroup.invalidateDisplayList();
			proxyGroup.validateNow();
			
			// Auto focus on the next activity, and exit transition state
			targetingActivity.destroy();
			targetingActivity = null;
			proxy = null;
			
			var nextActivity:Activity = getNearestActivity();
			lookAt(nextActivity);
		}
		
		/**
		 * @public
		 * 
		 * Batch remove activities
		 */
		public function removeActivities(activitiesToBeClosed:Array):void{
			proxyGroup.autoLayout = false;
			
			for each(var activity:Activity in activitiesToBeClosed){
				var index:Number = contentGroup.getElementIndex(activity);
				var proxy:BitmapImage = proxyGroup.getElementAt(index) as BitmapImage;
				contentGroup.removeElement(activity);
				proxyGroup.removeElement(proxy);
				activities.removeItemAt(activities.getItemIndex(activity));
				
				activity = null;
				proxy = null;
			}
			
			if(activities.length != 0){
				proxyGroup.autoLayout = true;
				var nextActivity:Activity = getNearestActivity();
				lookAt(nextActivity);
			}
		}
		
		/**
		 * @public
		 * 
		 * Select the target to be currentActivity, and focus on it
		 */
		public function lookAt(target:Activity):void{
			// Switch to transition mode
			if(currentState != "transition")
				currentState = "transition";
			
			// Remember the old activity
			var previousActivity:Activity = currentActivity;
			
			var index:Number = contentGroup.getElementIndex(target);
			var targetProxy:BitmapImage = proxyGroup.getElementAt(index) as BitmapImage;
			var	targetX:Number = targetProxy.x - target.x;
			
			var evt:ActivityDeckEvent = new ActivityDeckEvent(ActivityDeckEvent.ACTIVITY_CHANGED);
			evt.selectedActivity = target;
			
			if(proxyGroup.horizontalScrollPosition != targetX){
				var mp:SimpleMotionPath = new SimpleMotionPath("horizontalScrollPosition");
				mp.valueTo = targetX;
				
				var animate:Animate = new Animate(proxyGroup);
				animate.suspendBackgroundProcessing = true;
				animate.motionPaths = Vector.<MotionPath>([mp]);
				animate.duration = 200;
				animate.play();
				animate.addEventListener(EffectEvent.EFFECT_END, function(event:EffectEvent):void{
					currentActivity = target;
					currentState = "normal";
					dispatchEvent(evt);
					
					// If the activity has changed, deactive the old one and active the new one
					if(previousActivity && previousActivity != currentActivity){
						previousActivity.dispatchEvent(new ActivityContainerEvent(ActivityContainerEvent.DEACTIVITIED));
						currentActivity.dispatchEvent(new ActivityContainerEvent(ActivityContainerEvent.ACTIVITIED));
					}
					
				}, false, 0, true);
			}
			else{
				currentActivity = target;
				currentState = "normal";
				dispatchEvent(evt);
				
				// If the activity has changed, deactive the old one and active the new one
				if(previousActivity && previousActivity != currentActivity){
					previousActivity.dispatchEvent(new ActivityContainerEvent(ActivityContainerEvent.DEACTIVITIED));
					currentActivity.dispatchEvent(new ActivityContainerEvent(ActivityContainerEvent.ACTIVITIED));
				}
				
			}
		}
		
		/**
		 * @private
		 */
		private function onActivityInitialized(evt:FlexEvent):void{
			var activity:Activity = evt.target as Activity;
			activity.removeEventListener(FlexEvent.CREATION_COMPLETE, onActivityInitialized);
			updateProxy(activity);
		}
		
		/**
		 * @private
		 */
		private function adjustActivityWidth(target:Activity):void{
			target.width = 	getDefaultActivityWidth();	
			target.height = height;
			
			if(fullScreenMode)
				target.x = width / 2 - target.width / 2;
			else
				target.x = 0;
		}
		
		/**
		 * @private
		 */
		private function getDefaultActivityWidth():Number{
			return Math.ceil(width * 0.9);
		}
		
		/**
		 * @private
		 */
		private function getDefaultActivityHeight():Number{
			return height;
		}
		
		/**
		 * @private
		 *
		 * Create/update a proxy
		 */
		public function updateProxy(target:Activity):void{
			try{
				// Lookup if the proxy already exists
				var index:Number = contentGroup.getElementIndex(target);
				var proxy:BitmapImage;
				
				if(target.width == 0 || target.height == 0){
					target.validateSize();
				}
				
				if(proxyGroup.numElements == contentGroup.numElements)
					proxy = proxyGroup.getElementAt(index) as BitmapImage;
				else{
					proxy = new BitmapImage();
					if(proxyGroup.numElements <= index)
						proxyGroup.addElement(proxy);
					else
						proxyGroup.addElementAt(proxy, index);
				}
				
				proxy.width = target.width;
				proxy.height = target.height;
				
				var bmp:BitmapData = new BitmapData(proxy.width, proxy.height, true, 0x000000);			
				bmp.draw(target);
				
				// Update proxy thumbnail
				proxy.source = bmp;
				
				var evt:ActivityContainerEvent = new ActivityContainerEvent(ActivityContainerEvent.PROXY_UPDATED);
				evt.proxy = proxy;
				target.dispatchEvent(evt);
			}
			catch(e:Error){
				// Ignore any exceptions
				trace(e.getStackTrace());
			}
			
			if(target == currentActivity)
				proxy.visible = false;
		}
		
		/**
		 * @public
		 */
		public function getProxyOf(activity:Activity):BitmapImage{
			return proxyGroup.getElementAt(activities.getItemIndex(activity)) as BitmapImage;
		}
		
		/**
		 * @private
		 */
		protected function onCloseActivity(evt:ActivityContainerEvent):void{
			removeActivity(evt.activity);
		}
		
		/**
		 * @public
		 */
		public function enterFullScreen():void{
			fullScreenMode = true;
			proxyGroup.gap = DEFAULT_FULL_SCREEN_GAP;
			resize();
		}
		
		/**
		 * @public
		 */
		public function exitFullScreen():void{
			fullScreenMode = false;
			proxyGroup.gap = DEFAULT_GAP;
			resize();			
		}
		
		/**
		 * @public
		 */
		public function resize():void{
			if(currentState != "transition")
				currentState = "transition";
			
			for each(var activity:Activity in activities){
				adjustActivityWidth(activity);
				updateProxy(activity);
			}
			
			proxyGroup.invalidateSize();
			proxyGroup.invalidateDisplayList();
			proxyGroup.validateNow();
			
			for each(activity in activities){
				activity.dispatchEvent(new ActivityContainerEvent(ActivityContainerEvent.RESIZE_COMPLETE));
			}
			
			lookAt(currentActivity);
		}
		
	}
}