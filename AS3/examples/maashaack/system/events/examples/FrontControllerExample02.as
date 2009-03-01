﻿
package examples 
{
    import system.events.EventDispatcher;
    import system.events.FrontController;
    
    import flash.display.Sprite;
    import flash.events.Event;    

    [SWF(width="740", height="480", frameRate="24", backgroundColor="#666666")]

    /**
     * This class provides an example of the FrontController class 
     * with this static method getInstance().
     */
    public class FrontControllerExample02 extends Sprite 
    {

        public function FrontControllerExample02()
        {
            var controller:FrontController = FrontController.getInstance( "myChannel" ) ;
            var dispatcher:EventDispatcher = EventDispatcher.getInstance( "myChannel" ) ;
            
            controller.add( "type1" , listener1 ) ;
            controller.add( "type2" , listener2 ) ;
            
            dispatcher.dispatchEvent( new Event( "type1" ) ) ; // # action1 : type1
            dispatcher.dispatchEvent( new Event( "type2" ) ) ; // # action2 : type2
        }
        
        public function listener1( e:Event ):void 
        {
            trace("# action1 : " + e.type ) ; 
        }

        public function listener2( e:Event ):void 
        {
            trace("# action2 : " + e.type ) ; 
        }
        
    }
}