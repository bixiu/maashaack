﻿/*
  Version: MPL 1.1/GPL 2.0/LGPL 2.1
 
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the
  License.
  
  The Original Code is [maashaack framework].
  
  The Initial Developers of the Original Code are
  Zwetan Kjukov <zwetan@gmail.com> and Marc Alcaraz <ekameleon@gmail.com>.
  Portions created by the Initial Developers are Copyright (C) 2006-2010
  the Initial Developers. All Rights Reserved.
  
  Contributor(s):
  
  Alternatively, the contents of this file may be used under the terms of
  either the GNU General Public License Version 2 or later (the "GPL"), or
  the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
  in which case the provisions of the GPL or the LGPL are applicable instead
  of those above. If you wish to allow use of your version of this file only
  under the terms of either the GPL or the LGPL, and not to allow others to
  use your version of this file under the terms of the MPL, indicate your
  decision by deleting the provisions above and replace them with the notice
  and other provisions required by the LGPL or the GPL. If you do not delete
  the provisions above, a recipient may use your version of this file under
  the terms of any one of the MPL, the GPL or the LGPL.
*/

package examples 
{
    import graphics.FillStyle;
    import graphics.LineStyle;
    import graphics.drawing.Pen;
    import graphics.drawing.RectanglePen;
    import graphics.transitions.EasingController;
    import graphics.transitions.TweenLite;
    import graphics.transitions.easings.Back;
    import graphics.transitions.easings.Bounce;
    import graphics.transitions.easings.Elastic;
    
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    
    public class EasingControllerExample extends Sprite
    {
        {
            stage.scaleMode = "noScale" ;
            stage.addEventListener( KeyboardEvent.KEY_DOWN , keyDown ) ;
            
            /// build and draw the shape
            
            shape   = new Shape() ;
            shape.x = 50 ;
            shape.y = 60 ;
            
            addChild( shape ) ;
            
            var pen:Pen = new RectanglePen( shape ) ;
            
            pen.fill = new FillStyle(0xFFFFFF) ;
            pen.line = new LineStyle(1,0x999999) ;
            
            pen.draw(0,0,32,32,Align.CENTER) ;
            
            ///
            
            controller = new EasingController() ;
            
            controller.add( "back_ease_out"     , Back.easeOut   ) ;
            controller.add( "bounce_ease_out"   , Bounce.easeOut  ) ;
            controller.add( "elastic_ease_out"  , Elastic.easeOut ) ;
            
            easing = controller.getEasing( "elastic_ease_out" ) ;
            
            /// run
            
            tween = new TweenLite( shape, "x" , easing, 100, 500 , 2 , true, true ) ;
        }
        
        public var controller:EasingController ;
        
        public var easing:Function ;
        
        public var shape:Shape ;
        
        public var tween:TweenLite ;
        
        public function keyDown( e:KeyboardEvent ):void
        {
            if ( tween.running )
            {
                tween.stop() ;
            }
            var code:uint = e.keyCode ;
            switch( code )
            {
                case Keyboard.LEFT :
                {
                    easing = controller.getEasing( "back_ease_out" ) ;
                    break ;
                }
                case Keyboard.RIGHT :
                {
                    easing = controller.getEasing( "bounce_ease_out" ) ;
                    break ;
                }
                case Keyboard.UP :
                {
                    easing = controller.getEasing( "elastic_ease_out" ) ;
                    break ;
                }
            }
            tween = new TweenLite( shape , "x" , easing , 100 , 500 , 1 , true, true ) ;
        }
    }
}