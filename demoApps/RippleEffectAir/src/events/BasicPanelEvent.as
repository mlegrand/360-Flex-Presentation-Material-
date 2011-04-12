package events
{
	import flash.events.Event;

	public class BasicPanelEvent extends Event
	{
		
		public static const SHOW_SETTINGS_PANEL:String = "showSettingsPanel";
		
		public static const REFRESH_FLICKR_VIEW:String = "refreshFlickrView";
		
		public function BasicPanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}