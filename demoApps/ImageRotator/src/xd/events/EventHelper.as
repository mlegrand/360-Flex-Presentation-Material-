package xd.events
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.geom.Point;

	public class EventHelper
	{
		
		public static function getTargetForDispatchMouseLike(stage:Stage, type:String, p:Point):DisplayObject {
			var targets:Array = stage.getObjectsUnderPoint(p);
			targets.reverse();
			targets.push(stage);
			for each(var dobj:DisplayObject in targets) {
				if(dobj.willTrigger(type))
					return dobj;
			}
			return null;
			
		}
		
		public static function getInteractiveObjectFor(d:DisplayObject):InteractiveObject {
			while(d) {
				if(d is InteractiveObject)
					return d as InteractiveObject;
				d = d.parent;
			}
			return  null;
		}
//		public static function dispatchMouselike(stage:Stage, p:Point, e:Event):Boolean {
//			var targets:Array = stage.getObjectsUnderPoint(p);
//			targets.reverse();
//			targets.push(stage);
//			for each(var dobj:DisplayObject in targets) {
//				if(dobj.willTrigger(e.type))
//					return dobj.dispatchEvent(e);
//			}
//			return false;
//		}
		
	}
}