package frameworks.crescent.activity.events
{
	import flash.events.Event;
	
	import frameworks.crescent.activity.Activity;
	
	public class ActivityDeckEvent extends Event
	{
		/**
		 * @public
		 */
		public static const ACTIVITY_CHANGED:String = "activityChanged";
		
		/**
		 * @public
		 */
		public var selectedActivity:Activity;
		
		/**
		 * Constructor
		 */
		public function ActivityDeckEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}