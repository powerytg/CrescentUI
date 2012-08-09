package frameworks.crescent.activity.events
{
	import flash.events.Event;
	
	import frameworks.crescent.activity.Activity;
	
	import spark.primitives.BitmapImage;
	
	public class ActivityContainerEvent extends Event
	{
		/**
		 * @public
		 */
		public static const CLOSE_ACTIVITY:String = "closeActivity";
		
		/**
		 * @public
		 */
		public static const PROXY_UPDATED:String = "proxyUpdated";
		
		/**
		 * @public
		 */
		public static const ACTIVITIED:String = "activitied";

		/**
		 * @public
		 */
		public static const DEACTIVITIED:String = "deactivitied";

		/**
		 * @public
		 */
		public static const DESTROY:String = "destroy";
		
		/**
		 * @public
		 */
		public static const RESIZE_COMPLETE:String = "resizeComplete";		
		
		/**
		 * @public
		 */
		public var proxy:BitmapImage;
		
		/**
		 * @public
		 */
		public var activity:Activity;
		
		/**
		 * Constructor
		 */
		public function ActivityContainerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}