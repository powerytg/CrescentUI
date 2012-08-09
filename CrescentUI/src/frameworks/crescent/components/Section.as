package frameworks.crescent.components
{
	import frameworks.crescent.components.supportClasses.SectionTitleBar;
	
	import mx.core.IVisualElement;
	
	import spark.components.HGroup;
	import spark.components.SkinnableContainer;
	
	public class Section extends SkinnableContainer
	{
		/**
		 * The title bar
		 */
		[SkinPart("titleBar")]
		public var titleBar:SectionTitleBar;

		/**
		 * @public
		 */
		[SkinPart]
		public var actionGroup:HGroup;
		
		/**
		 * Title
		 */
		[Bindable]
		public var title:String;
		
		/**
		 * The actionContent defines a group of optional components
		 * that you'd probably like to include in the title bar
		 */
		public var actions:Array;
		
		/**
		 * Constructor
		 */
		public function Section()
		{
			super();
		}
		
		/**
		 * @protected
		 */
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
			
			if(partName == "actionGroup"){
				createActionContent();
			}
		}
		
		/**
		 * @protected
		 * 
		 * Create the action children that defined in the actionContent array
		 */
		protected function createActionContent():void{
			for each(var element:IVisualElement in actions){
				actionGroup.addElement(element);
			}
		}
		
	}
}